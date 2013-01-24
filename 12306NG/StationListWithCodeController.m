//
//  TicketsListWithCodeController.m
//  TicketsHunter
//
//  Created by Lei Sun on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "StationListWithCodeController.h"
#import "DDHelper.h"



@implementation StationInfo
@synthesize stationName;
@synthesize stationCode;
@synthesize stationPinYin;
@synthesize stationIndex;


- (id)init
{
    self = [super init];
    if (self) {
        stationCode=@"";
        stationName=@"";
        stationPinYin=@"";
        stationIndex=@"";
        
        
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:stationCode forKey:@"CODE"];
    [aCoder encodeObject:stationName forKey:@"NAME"];
    [aCoder encodeObject:stationPinYin forKey:@"PINYIN"];
    [aCoder encodeObject:stationIndex forKey:@"INDEX"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    if ((self=[self init])) {
    self.stationCode=[aDecoder decodeObjectForKey:@"CODE"];
    self.stationName=[aDecoder decodeObjectForKey:@"NAME"];
    self.stationPinYin=[aDecoder decodeObjectForKey:@"PINYIN"];
    self.stationIndex=[aDecoder decodeObjectForKey:@"INDEX"];
    }
    return self;
   
}

- (void)dealloc
{
    stationCode=nil;
    stationName=nil;
    stationPinYin=nil;
    stationIndex=nil;
    [super dealloc];
}
-(NSString*)debugDescription
{
    return [NSString stringWithFormat:@"\n\nstationName=%@\nstationCode=%@\nstationPinYin%@\nstationIndex=%@\n\n",stationName,stationCode,stationPinYin,stationIndex];
}
@end


@interface StationListWithCodeController ()

@property(nonatomic,retain) UISearchBar *searchBar;
@property(nonatomic,retain) UITableView *tableView1;
@property(nonatomic,retain) UITableView *tableView2;
@property(nonatomic,retain)UIScrollView* mainView;
@property(nonatomic,retain)UISegmentedControl* segCtl;

@property(nonatomic,retain)NSMutableArray* stationArray;
@property(nonatomic,retain)NSMutableArray* resultArray;

@property(nonatomic,assign)NSInteger pageIndex;
@end

@implementation StationListWithCodeController

@synthesize stationArray,resultArray;
@synthesize delegate,name,tag;
@synthesize infoEnd,infoStart;
@synthesize tableView1,tableView2,mainView,segCtl,searchBar;
@synthesize pageIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.stationArray=[[DDHelper allStations] mutableCopy];
        self.infoStart=[[[StationInfo alloc] init] autorelease];
        self.infoEnd=[[[StationInfo alloc] init] autorelease];
    }
    return self;
}
- (void)dealloc
{
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSLog(@"tags is %d ",self.tag);
    
    [self showCustomBackButton];
	
	// Do any additional setup after loading the view.
    
//    if (!infoStart.stationName) {
//        infoStart.stationName=@"";
//    }
//    if (!infoEnd.stationName) {
//        infoEnd.stationName=@"";
//    }

    
    
    self.segCtl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"起点站",@"终点站",nil]];
   // self.segCtl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:infoStart.stationName,@"To",infoEnd.stationName, nil]];

    segCtl.frame=CGRectMake(0, 0, 180, 30);
    //[segCtl setEnabled:NO];
//    [segCtl setWidth:50 forSegmentAtIndex:1];
//    [segCtl setEnabled:NO forSegmentAtIndex:1];
     segCtl.segmentedControlStyle=UISegmentedControlStyleBordered;
    [segCtl addTarget:self action:@selector(segChanged:) forControlEvents:UIControlEventValueChanged];
    //self.navigationItem.titleView=segCtl;
    [segCtl setSelectedSegmentIndex:0];
    
    
    
    
    
//    UIBarButtonItem* okButton=[[UIBarButtonItem alloc] initWithTitle:@"交换" style:UIBarButtonItemStylePlain target:self action:@selector(okClick:)];
//    self.navigationItem.rightBarButtonItem= okButton;   
//    [okButton release];
//    
    
    
    
    CGRect rect=CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44);
    
    mainView=[[UIScrollView alloc] initWithFrame:rect];
    mainView.contentSize=CGSizeMake(rect.size.width*2, rect.size.height);
    [mainView setPagingEnabled:YES];
    mainView.delegate=self;
   
    
    tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) style:UITableViewStyleGrouped];
    tableView1.backgroundColor=[UIColor clearColor];
    tableView1.backgroundView=nil;
    tableView1.dataSource=self;
    tableView1.delegate=self;
    [mainView  addSubview:tableView1];
    
    
    tableView2=[[UITableView alloc] initWithFrame:CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height) style:UITableViewStyleGrouped];
    tableView2.backgroundColor=[UIColor clearColor];
     tableView2.backgroundView=nil;
    tableView2.dataSource=self;
    tableView2.delegate=self;
    [mainView  addSubview:tableView2];
    
    
    
    [self.view addSubview:mainView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem =
    
//    UILabel* lbheader=[[UILabel  alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//    [self.view addSubview:lbheader];
//    [lbheader release];
    
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
    
    
    self.resultArray=[self.stationArray mutableCopy] ;
    
    
    //segCtl.selectedSegmentIndex=self.tag-100;
    [self setPageIndex:segCtl.selectedSegmentIndex];


}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.resultArray=[self.stationArray mutableCopy] ;
    [self.tableView1 reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    LogDebug(@"textDidChange");
	if ([searchText length]> 0) {
        
//        if (self.resultArray.count>0) {
//            [self.resultArray removeAllObjects];
//        }
//        
//        for (int i =0; i<self.stationArray.count;i++) {
//            
//            NSRange range = [[self.stationArray objectAtIndex:i] rangeOfString:searchText];
//            if (range.length>0) {
//                
//                [self.resultArray addObject:[self.stationArray objectAtIndex:i]];
//                
//            }
//        }
        
         self.resultArray= [[DDHelper seguestStationItemsByString:searchText] mutableCopy];
        
        [self.searchDisplayController.searchResultsTableView  reloadData];
	}
    
	
    //	LogDebug(@"---count:%d",pyarray.count);
	
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
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
//    if (section==0) {
//        return 1;
//    }else {
//        return [resultArray count];
//    }
//    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    // Configure the cell...
    
     cell.textLabel.text=[[resultArray objectAtIndex:indexPath.row] objectForKey:@"name" ];
//    if (indexPath.section==0) {
//        if (tableView_==tableView1) {
//             cell.textLabel.text=[NSString stringWithFormat:@"起点站：%@",infoStart.stationName];
//        }else  if(tableView_==tableView2){
//            cell.textLabel.text=[NSString stringWithFormat:@"终点站：%@",infoEnd.stationName];
//        }
//       
//    }else {
//        cell.textLabel.text=[[resultArray objectAtIndex:indexPath.row] objectForKey:@"name" ];
//    }
     return cell ;
    
}

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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    
//    NSMutableDictionary* dict=[self.resultArray objectAtIndex:indexPath.row];
//           
//    
//    if (tableView==tableView1) {
//        infoStart.stationName=[dict objectForKey:@"name"];
//        infoStart.stationCode=[dict objectForKey:@"code"];
//        infoStart.stationPinYin=[dict objectForKey:@"pinyin"];
//        infoStart.stationIndex=[dict objectForKey:@"index"];
//    } 
//    else  if (tableView==tableView1){
//        infoEnd.stationName=[dict objectForKey:@"name"];
//        infoEnd.stationCode=[dict objectForKey:@"code"];
//        infoEnd.stationPinYin=[dict objectForKey:@"pinyin"];
//        infoEnd.stationIndex=[dict objectForKey:@"index"];        
//    }
//    
//    [tableView reloadData];
    
    if (delegate&&[delegate respondsToSelector:@selector(listStationView:didSelectWithValue:)]) {
        
        NSMutableDictionary* dict=[self.resultArray objectAtIndex:indexPath.row];
        StationInfo* info=[[StationInfo alloc] init];
        
        info.stationName=[dict objectForKey:@"name"];
        info.stationCode=[dict objectForKey:@"code"];
        info.stationPinYin=[dict objectForKey:@"pinyin"];
        info.stationIndex=[dict objectForKey:@"index"];
        [delegate listStationView:self didSelectWithValue:info];      
        [info release];
    }
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    LogInfo(@"scrollViewDidEndDecelerating===%f",scrollView.contentOffset.x);    
    if (scrollView==mainView) {
        if (pageIndex!=(int)(scrollView.contentOffset.x/320)) {
            pageIndex=(int)(scrollView.contentOffset.x/320);
           // [segCtl setSelectedSegmentIndex:pageIndex==0?0:2];
            [segCtl setSelectedSegmentIndex:pageIndex==0?0:1];
             //self.tag=100+pageIndex;
        }

    }
}

-(void)setPageIndex:(NSInteger)index
{
   pageIndex=index;
   //self.tag=100+index;
   [ UIView animateWithDuration:0.3 animations:^{
         mainView.contentOffset=CGPointMake(320*index, 0);
   } ];
}

-(void)segChanged:(UISegmentedControl*)seg
{
    [self setPageIndex:seg.selectedSegmentIndex];
//    int p= segCtl.selectedSegmentIndex==0?0:1;
//    [self setPageIndex:p];
}
@end
