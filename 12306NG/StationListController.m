//
//  StationListController.m
//  TicketsHunter
//
//  Created by Lei Sun on 10/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StationListController.h"
#import "TBXML.h"


static DataSourceProvider* _dataSourceProvider;

@implementation DataSourceProvider
@synthesize dataArray;
+(NSMutableArray*)LoadData
{
    //    NSXMLParser* stationsXML=[[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString: [[NSBundle mainBundle] pathForResource:@"stations" ofType:@"xml"]]];    
    //    stationsXML.delegate=(id<NSXMLParserDelegate>)self;
    //    [stationsXML parse];
    
    NSMutableArray* array=[NSMutableArray array];
    
    NSString* fileName=[[NSBundle mainBundle] pathForResource:@"stations" ofType:@"xml"];
    TBXML* xmlParser=[TBXML tbxmlWithXMLData:[NSData dataWithContentsOfFile:fileName]];    
    TBXMLElement* root=xmlParser.rootXMLElement;    
    if (root) {
        
        TBXMLElement * option = [TBXML childElementNamed:@"option" parentElement:root];
        while(option != nil){            
            [array addObject:[TBXML textForElement:option]];
            option=[TBXML nextSiblingNamed:@"option" searchFromElement:option];
        }
    }    
    return array;
    
    
}
+(DataSourceProvider*)sharedDataSourceProvider
{
    if (_dataSourceProvider==nil) {
        _dataSourceProvider=[[DataSourceProvider alloc] init];
        _dataSourceProvider->dataArray=[self LoadData];
    }
    return _dataSourceProvider;
}
- (id)init
{
    self = [super init];
    if (self) {
        _dataSourceProvider=self;
    }
    return self;
}
@end


@implementation StationListController
@synthesize stationArray,searchBar,resultArray,tableView;
@synthesize delegate,name,tag;




- (id)init
{
    self = [super init];
    if (self) {
        self.stationArray=[DataSourceProvider sharedDataSourceProvider].dataArray;
    }
    return self;
}
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect=CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44);
    tableView=[[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.dataSource=self;
    tableView.delegate=self;
    [self.view addSubview:tableView];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem =
    
    
    self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)] autorelease];
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	//	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
	self.searchBar.delegate =(id<UISearchBarDelegate>)self;
    [self.view addSubview:self.searchBar];
	//	self.searchBar.backgroundColor =moaIniCorwS(ImageBGR);
	//[self.view addSubview:self.searchBar];
    //self.tableView.tableHeaderView=self.searchBar;
	
	//	// Create the search display controller
    
    
    UISearchDisplayController* sdc=[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
 	sdc.searchResultsDataSource = self;
	sdc.searchResultsDelegate = self;
	
	sdc.delegate = (id<UISearchDisplayDelegate>)self;
	//self.searchDisplayController

    
    self.resultArray=[[self.stationArray mutableCopy] autorelease];
   
    
    
    
}
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
            
   

}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.resultArray=[[self.stationArray mutableCopy] autorelease] ;
    [self.tableView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    LogDebug(@"textDidChange");
	if ([searchText length]> 0) {
            
        if (self.resultArray.count>0) {
            [self.resultArray removeAllObjects];
        }
        
        for (int i =0; i<self.stationArray.count;i++) {
            
            NSRange range = [[self.stationArray objectAtIndex:i] rangeOfString:searchText];
            if (range.length>0) {
                
               [self.resultArray addObject:[self.stationArray objectAtIndex:i]];
                
            }
        }
       [self.searchDisplayController.searchResultsTableView  reloadData];
	}
    
	
    //	LogDebug(@"---count:%d",pyarray.count);
	
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; 
//{
//    if (section==0) {
//        return self.searchBar;
//    }
//    return nil;
//}
//
//- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        return self.searchBar.frame.size.height;
//    }
//    return 0;
//}
// custom view for header. will be 
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    // Configure the cell...
   
     cell.textLabel.text=[resultArray objectAtIndex:indexPath.row];
    return cell ;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    if (delegate&&[delegate respondsToSelector:@selector(listView:didSelectWithValue:)]) {
        [delegate listView:self didSelectWithValue:[self.resultArray objectAtIndex:indexPath.row]];        
    }
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissModalViewControllerAnimated:YES];
    }
   
}
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    
//    return [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",nil];  
//    
//}// return list of section titles to display in section index view (e.g. "ABCD...Z#")
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index 
//{
//    
//    
//    return index%4;
//    
//}
// tell table which section corresponds to section title/index (e.g. "B",1))

@end
