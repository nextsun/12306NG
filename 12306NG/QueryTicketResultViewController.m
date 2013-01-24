//
//  QueryTicketResultViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "BookingTicketViewController.h"
#import "QueryTicketResultViewController.h"
#import "TicketModel.h"
#import <QuartzCore/QuartzCore.h>
#import "CMPopTipView.h"
#import "GlobalClass.h"
#import "MBProgressHUD.h"
#import "NSDate-Helper.h"
#import "TicketsFilterView.h"

#define HEIGHT_FOR_FILTERVIEW 35

//详情cell
@interface  QueryTicketResultCell: UITableViewCell
{
    UILabel* LbTickets1;
    UILabel* LbTickets2;
    UILabel* LbTickets3;
    UILabel* LbTickets4;
    UILabel* LbTickets5;

}
-(void)refresh:(TicketModel*)mode;
@property(nonatomic, retain)UILabel *trainCodeLabel;  //车次
@property(nonatomic, retain)UILabel *fromLocationLabel;//发站
@property(nonatomic, retain)UILabel *toLocationLabel; //到站
@property(nonatomic, retain)UILabel *fromTimeLabel; //发站时间
@property(nonatomic, retain)UILabel *toTimeLabel;//到站时间
@property(nonatomic, retain)UILabel *durationLabel; //历时

@end

@implementation QueryTicketResultCell
@synthesize trainCodeLabel,fromLocationLabel,toLocationLabel,fromTimeLabel,toTimeLabel,durationLabel;
-(void)dealloc
{
    self.trainCodeLabel = nil;
	self.fromLocationLabel = nil;
    self.toLocationLabel = nil;
    self.fromLocationLabel = nil;
    self.fromTimeLabel = nil;
    self.toTimeLabel = nil;
    self.durationLabel = nil;

	[super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		// Initialization code

        self.trainCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 45, 20)];
        [self.trainCodeLabel setTextAlignment:UITextAlignmentLeft];
        [self.trainCodeLabel setBackgroundColor:[UIColor clearColor]];
         self.trainCodeLabel.font = [UIFont systemFontOfSize:13];
         self.trainCodeLabel.numberOfLines = 0;
        [self.contentView addSubview:self.trainCodeLabel];
        
        
        self.fromLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 60, 20)];
        [self.fromLocationLabel setTextAlignment:UITextAlignmentRight];
        [self.fromLocationLabel setBackgroundColor:[UIColor clearColor]];
        self.fromLocationLabel.font = [UIFont systemFontOfSize:13];
        self.fromLocationLabel.numberOfLines = 0;
        [self.contentView addSubview:self.fromLocationLabel];
        
        
        
        UILabel* labelArrow = [[UILabel alloc] initWithFrame:CGRectMake(145, 10, 20, 20)];
        [labelArrow setText:@"➡"];
        [labelArrow setTextAlignment:UITextAlignmentLeft];
        [labelArrow setBackgroundColor:[UIColor clearColor]];
        labelArrow.font = [UIFont systemFontOfSize:13];
        labelArrow.numberOfLines = 0;
        [self.contentView addSubview:labelArrow];
        [labelArrow release];
        
        self.toLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 10, 60, 20)];
        [self.toLocationLabel setTextAlignment:UITextAlignmentLeft];
        [self.toLocationLabel setBackgroundColor:[UIColor clearColor]];
        self.toLocationLabel.font = [UIFont systemFontOfSize:13];
        self.toLocationLabel.numberOfLines = 0;
        [self.contentView addSubview:self.toLocationLabel];
        
        self.fromTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 40, 20)];
        [self.fromTimeLabel setTextAlignment:UITextAlignmentLeft];
        [self.fromTimeLabel setBackgroundColor:[UIColor clearColor]];
        self.fromTimeLabel.font = [UIFont systemFontOfSize:13];
        self.fromTimeLabel.numberOfLines = 0;
        [self.contentView addSubview:self.fromTimeLabel];
        
        
        labelArrow = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 15, 20)];
        [labelArrow setText:@"--"];
        [labelArrow setTextAlignment:UITextAlignmentLeft];
        [labelArrow setBackgroundColor:[UIColor clearColor]];
        labelArrow.font = [UIFont systemFontOfSize:13];
        labelArrow.numberOfLines = 0;
        [self.contentView addSubview:labelArrow];
        [labelArrow release];
        
        self.toTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 35, 40, 20)];
        [self.toTimeLabel setTextAlignment:UITextAlignmentLeft];
        [self.toTimeLabel setBackgroundColor:[UIColor clearColor]];
        self.toTimeLabel.font = [UIFont systemFontOfSize:13];
        self.toTimeLabel.numberOfLines = 0;
        [self.contentView addSubview:self.toTimeLabel];
        
        
        UILabel* labelClock = [[UILabel alloc] initWithFrame:CGRectMake(120, 35, 20, 20)];
        [labelClock setText:@"⏰"];
        [labelClock setTextAlignment:UITextAlignmentLeft];
        [labelClock setBackgroundColor:[UIColor clearColor]];
        labelClock.font = [UIFont systemFontOfSize:13];
        labelClock.numberOfLines = 0;
        [self.contentView addSubview:labelClock];
        [labelClock release];
        
        
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 35, 80, 20)];
        [self.durationLabel setTextAlignment:UITextAlignmentLeft];
        [self.durationLabel setBackgroundColor:[UIColor clearColor]];
        self.durationLabel.font = [UIFont systemFontOfSize:13];
        self.durationLabel.numberOfLines = 0;
        [self.contentView addSubview:self.durationLabel];
        
        
        LbTickets1=[[UILabel alloc] initWithFrame:CGRectMake(20, 57, 60, 25)];
        [LbTickets1 setFont:[UIFont systemFontOfSize:11]];
        LbTickets1.textAlignment=UITextAlignmentCenter;
        
        [self addSubview:LbTickets1];
        LbTickets1.backgroundColor=[UIColor clearColor];
        [LbTickets1 setTextColor:[UIColor redColor]];
        
        
        LbTickets2=[[UILabel alloc] initWithFrame:CGRectMake(80, 57, 60, 25)];
        [LbTickets2 setFont:[UIFont systemFontOfSize:11]];
        LbTickets2.textAlignment=UITextAlignmentCenter;
        LbTickets2.backgroundColor=[UIColor clearColor];
        [self addSubview:LbTickets2];
        [LbTickets2 setTextColor:[UIColor blueColor]];
        
        LbTickets3=[[UILabel alloc] initWithFrame:CGRectMake(140, 57, 60, 25)];
        [LbTickets3 setFont:[UIFont systemFontOfSize:11]];
        LbTickets3.textAlignment=UITextAlignmentCenter;
        LbTickets3.backgroundColor=[UIColor clearColor];
        [self addSubview:LbTickets3];
        [LbTickets3 setTextColor:[UIColor magentaColor]];
        
        LbTickets4=[[UILabel alloc] initWithFrame:CGRectMake(200, 57, 60, 25)];
        [LbTickets4 setFont:[UIFont systemFontOfSize:11]];
        LbTickets4.textAlignment=UITextAlignmentCenter;
        LbTickets4.backgroundColor=[UIColor clearColor];
        [self addSubview:LbTickets4];
        [LbTickets4 setTextColor:[UIColor brownColor]];
        
        LbTickets5=[[UILabel alloc] initWithFrame:CGRectMake(260, 57, 60, 25)];
        [LbTickets5 setFont:[UIFont systemFontOfSize:11]];
        LbTickets5.textAlignment=UITextAlignmentCenter;
        LbTickets5.backgroundColor=[UIColor clearColor];
        [self addSubview:LbTickets5];
        [LbTickets5 setTextColor:[UIColor purpleColor]];

        
	}
    
	return self;
}


-(void)refresh:(TicketModel*)mode;
{
  
    NSArray* arrNameP=[NSArray arrayWithObjects:@"shangwuzuo",@"tedengzuo",@"yidengzuo",@"erdengzuo",@"gaojiruanwo",@"ruanwo",@"yingwo",@"ruanzuo",@"yingzuo",@"wuzuo", nil];
    NSArray* arrName=[NSArray arrayWithObjects:@"商务座",@"特等座",@"一等座",@"二等座",@"高级软卧",@"软卧",@"硬卧",@"软座",@"硬座",@"无座", nil];
    
    NSMutableDictionary* dataModel=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    mode.businessSeat,@"shangwuzuo",
                                    mode.specialSeat,@"tedengzuo",
                                    mode.AOneSeat,@"yidengzuo",
                                    mode.BOneSeat,@"erdengzuo",
                                    mode.advancedSoftBed,@"gaojiruanwo",
                                    mode.softBed,@"ruanwo",
                                    mode.hardBed,@"yingwo",
                                    mode.softSeat,@"ruanzuo",
                                    mode.hardSeat,@"yingzuo",
                                    mode.noSeat,@"wuzuo",
                                    nil];
    
    
    NSArray* lbArrays=[NSArray arrayWithObjects:LbTickets1,LbTickets2,LbTickets3,LbTickets4,LbTickets5, nil];
    
    int j=0;
    for (int i=0; i<[arrNameP count]; i++) {
        if (j==5)break;
        NSString* val=[dataModel objectForKey:[arrNameP objectAtIndex:i]];
        if (val&&![val isEqualToString:@"--"]) {
             UILabel* l=((UILabel*) [lbArrays objectAtIndex:j]);
            [l setText:[NSString stringWithFormat:@"%@:%@",[arrName objectAtIndex:i],val]];
            //l.backgroundColor=[UIColor lightGrayColor];
            j++;
        }
    }
    
    
    float padding=10.0;
    float width=(320.0-padding*2)/j;
    
    
    for (int k=0 ; k<j; k++) {
        
        UILabel* l=((UILabel*) [lbArrays objectAtIndex:k]);
        l.frame=CGRectMake(padding+width*k, 57, width, 25);
        l.hidden=NO;
        
        
    }
    
     while (j<5) {

         UILabel* l=((UILabel*) [lbArrays objectAtIndex:j]);
         [l setText:@""];
        l.hidden=YES;
            j++;
    }
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
}

@end


@interface QueryTicketResultViewController ()

@property(nonatomic,retain)NSMutableArray* selectedKeys;
@property(nonatomic,retain)NSMutableArray* trainNumberArray;
@end

@implementation QueryTicketResultViewController
@synthesize trainNumberArray;
@synthesize trainNo;
@synthesize xpathParser;
@synthesize startTimeStr;

@synthesize selectedKeys;

@synthesize trainNumberArrayAll;

- (void)dealloc 
{
    self.trainNumberArray = nil;
    self.trainNumberArrayAll=nil;
    [super dealloc];
}

-(void)setTrainNumberArrayAll:(NSMutableArray *)trainNumberArray_
{
    [trainNumberArray release];
    [trainNumberArrayAll release];
    trainNumberArray=[trainNumberArray_ retain];
    trainNumberArrayAll=[trainNumberArray_ retain];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return 2;
//}
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    
//    return @"AAA";
//    
//    
//}
-(void)ticketsFilterView:(TicketsFilterView*)picker didChangFilterKeys:(NSArray*)keys
{
     self.selectedKeys=picker.selectedKeys;
    [self filterData];
    
}

-(void)filterData
{
//    if ([keys count]<7) {
//        
//        return;
//    }
    
    if ([self.selectedKeys count]<7||[[self.selectedKeys objectAtIndex:0] isEqualToString:@"1"]) {
       
        self.trainNumberArray=self.trainNumberArrayAll;
        [mainTableView reloadData];
        return;
    }
    
    NSString* strQT=[self.selectedKeys objectAtIndex:6];   
    BOOL flag=[strQT isEqualToString:@"1"];
  
    NSMutableArray* arr=[NSMutableArray array];    
    
    if (![[self.selectedKeys  objectAtIndex:1] isEqualToString:strQT]) {
        [arr addObject:@"G"];
    }
    if (![[self.selectedKeys  objectAtIndex:2] isEqualToString:strQT]) {
        [arr addObject:@"D"];
    }
    if (![[self.selectedKeys  objectAtIndex:3] isEqualToString:strQT]) {
        [arr addObject:@"Z"];
    }
    if (![[self.selectedKeys  objectAtIndex:4] isEqualToString:strQT]) {
        [arr addObject:@"T"];
    }
    if (![[self.selectedKeys  objectAtIndex:5] isEqualToString:strQT]) {
        [arr addObject:@"K"];
    }
    
    self.trainNumberArray=[NSMutableArray arrayWithArray:[self.trainNumberArrayAll filteredArrayUsingPredicate:
     [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        
        TicketModel* t=evaluatedObject;
         for (NSString* str in arr) {
            if ([t.trainCode hasPrefix:str]) {
                return !flag;
            }
        }
       return flag;
        
    }]]];
    
    [mainTableView reloadData];
    
}

-(void)filterResult:(UIButton*)sender
{
    
    
//    UIPickerView* pickView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320-20, 100)];
//    pickView.dataSource=(id<UIPickerViewDataSource>)self;
//    pickView.delegate=(id<UIPickerViewDelegate>)self;
//    pickView.showsSelectionIndicator=YES;
//    
    
    UIView* hostView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
    TicketsFilterView* tableView1=[[TicketsFilterView alloc] initWithFrame:CGRectMake(2, 0, 150-4, 200)];
    //UITableView* tableView2=[[UITableView alloc] initWithFrame:CGRectMake(150+2, 0, 150-4, 200)];
    [hostView addSubview:tableView1];
    tableView1.selectedKeys=self.selectedKeys;
    tableView1.filterdelegate=(id<TicketsFilterViewDelegate>)self;
    //[hostView addSubview:tableView2];
    
    
    
    
//    UIButton* btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//                   btn.frame=CGRectMake(0, 0, 200, 200);
    
    
    CMPopTipView* pop=[[CMPopTipView alloc] initWithCustomView:hostView];
    
    

    pop.backgroundColor=[UIColor grayColor];
    pop.dismissTapAnywhere=YES;
    [pop presentPointingAtView:sender inView:self.navigationController.view animated:YES];
    
    [pop release];
    
    
    
    
    
    
    
    
    
}
-(void)onReloadClick
{
    [self queryTickets];
}
-(void)prevDay:(UIBarButtonItem*)sender
{
    
    NSString* format=@"yyyy-MM-dd";
    [GlobalClass sharedClass].dateString= [[[NSDate dateFromString:[GlobalClass sharedClass].dateString withFormat:format] dateAfterDay:-1] stringWithFormat:format];
    
    [self queryTickets];
    
}
-(void)nextDay:(UIBarButtonItem*)sender
{
    NSString* format=@"yyyy-MM-dd";
    [GlobalClass sharedClass].dateString= [[[NSDate dateFromString:[GlobalClass sharedClass].dateString withFormat:format] dateAfterDay:1] stringWithFormat:format];
    
    [self queryTickets];
    
}
-(void)onTitleClick:(UIButton*)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        
        if (!sortView.frame.origin.y==0) {
            sortView.frame=CGRectMake(0, 0, 320, HEIGHT_FOR_FILTERVIEW);
            mainTableView.contentInset=UIEdgeInsetsMake(HEIGHT_FOR_FILTERVIEW, 0, 0, 0);
            mainTableView.scrollIndicatorInsets=UIEdgeInsetsMake(HEIGHT_FOR_FILTERVIEW, 0, 0, 0);
            
            //mainTableView.contentOffset=CGPointMake(0, mainTableView.contentOffset.y-30);
            
            
            
        }
        else
        {
            sortView.frame=CGRectMake(0, -HEIGHT_FOR_FILTERVIEW, 320, HEIGHT_FOR_FILTERVIEW);
            mainTableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
            mainTableView.scrollIndicatorInsets=UIEdgeInsetsMake(0, 0, 0, 0);
            
//            if (mainTableView.contentOffset.y>30&&mainTableView.contentOffset.y<mainTableView.contentSize.height-mainTableView.frame.size.height-30)
//            {
//            
//               mainTableView.contentOffset=CGPointMake(0, mainTableView.contentOffset.y+30);
//            }
        }

    }];
    
        
       
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
     [self.navigationController setToolbarHidden:NO];
    
    self.navigationController.toolbar.barStyle=UIBarStyleBlack;
     //self.navigationController setToolbarItems:[]
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_black"]];
    
    
    //self.title= ;
    
    
    titleButton=[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    [titleButton addTarget:self action:@selector(onTitleClick:) forControlEvents:UIControlEventTouchUpInside];
    titleButton.titleLabel.text=[GlobalClass sharedClass].dateString;
    self.navigationItem.titleView=titleButton;

    
    
    
    
    
    [self showCustomBackButton];
    
    
    NGCustomButton* subButton=[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    //[subButton addTarget:self action:@selector(onReloadClick) forControlEvents:UIControlEventTouchUpInside];
    [subButton addTarget:self action:@selector(filterResult:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedKeys=[[[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil] autorelease];
    subButton.titleLabel.text=@"筛选";
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:subButton] autorelease];
    [subButton release];

    
    
    NGCustomButton* prevButton=[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 50, 50, 30)];
   
    [prevButton addTarget:self action:@selector(prevDay:) forControlEvents:UIControlEventTouchUpInside];
    prevButton.titleLabel.text=@"前一天";
    UIBarButtonItem* b1=[[[UIBarButtonItem alloc] initWithCustomView:prevButton] autorelease];

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    NGCustomButton* nextButton=[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 50, 50, 30)];
     nextButton.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
    [nextButton addTarget:self action:@selector(nextDay:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.titleLabel.text=@"后一天";
    UIBarButtonItem* b2=[[[UIBarButtonItem alloc] initWithCustomView:nextButton] autorelease];
    
     
    
    
    [self setToolbarItems:@[b1,spaceItem,b2] animated:YES];
    
    //self.navigationController.toolbarItems=[NSMutableArray arrayWithObjects:b, nil];
    
    
     [nextButton release];
    
    
    
   // int h=  [UIScreen mainScreen].bounds.size.height;
    
    //CGRect rect=CGRectMake(0, 0, self.view.bounds.size.width,h-20-44);
    
    mainTableView=[[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] autorelease];
//    mainTableView.contentInset=UIEdgeInsetsMake(HEIGHT_FOR_FILTERVIEW, 0, 0, 0);
//    mainTableView.scrollIndicatorInsets=UIEdgeInsetsMake(30, 0, 0, 0);
    [self.view addSubview:mainTableView];
    mainTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    mainTableView.backgroundColor=[UIColor clearColor];
    mainTableView.backgroundView=nil;
    mainTableView.dataSource=(id<UITableViewDataSource>)self;
    mainTableView.delegate=(id<UITableViewDelegate>)self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    
    sortView=[[UIView alloc] initWithFrame:CGRectMake(0, -HEIGHT_FOR_FILTERVIEW, 320, HEIGHT_FOR_FILTERVIEW)];
    sortView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:sortView];
    
    
    UISegmentedControl* segment=[[UISegmentedControl alloc] initWithItems:@[@" 始发",@"历时",@"到站",@"车次",@"有票"]];
     segment.frame=CGRectMake(-8, 0, 336, HEIGHT_FOR_FILTERVIEW);
    segment.tag=101;
    [sortView addSubview:segment];
    [segment setSelectedSegmentIndex:0];
    [segment addTarget:self action:@selector(onSortClick:) forControlEvents:UIControlEventValueChanged];
    segment.segmentedControlStyle=UISegmentedControlStylePlain;

    
    
    
    //self.toolbarItems=[NSMutableArray arrayWithObjects:@"aaa", nil];
    

    
    
    
     
    
    // Do any additional setup after loading the view from its nib.
}

-(void)onSortClick:(UISegmentedControl*)segController
{
    
    if (segController.selectedSegmentIndex==0) {
        
//        self.trainNumberArray=[NSMutableArray arrayWithArray:
        [self.trainNumberArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            TicketModel* t1=obj1;
            TicketModel* t2=obj2;
            return [t1.fromTime compare:t2.fromTime];
            
        }];
    }else if (segController.selectedSegmentIndex==1)
    {
        
        [self.trainNumberArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            TicketModel* t1=obj1;
            TicketModel* t2=obj2;
            return [t1.duration compare:t2.duration];
            
        }];
        
    }
    else if (segController.selectedSegmentIndex==2)
    {
        
        [self.trainNumberArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            TicketModel* t1=obj1;
            TicketModel* t2=obj2;
            return [t1.toTime compare:t2.toTime];
            
        }];

        
    }
    else if (segController.selectedSegmentIndex==3)
    {
      
        
        [self.trainNumberArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            TicketModel* t1=obj1;
            TicketModel* t2=obj2;
            return [t1.trainCode compare:t2.trainCode];
            
        }];

        
    }else if (segController.selectedSegmentIndex==4)
    {
       
        [self.trainNumberArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            TicketModel* t1=obj1;
            TicketModel* t2=obj2;
            return [t2.orderString compare:t1.orderString];
            
        }];

        
    }
       
    [mainTableView reloadData];
    
    
//    if ([self.trainNumberArray count]>0) {
//        [mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     [self.navigationController setToolbarHidden:NO animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)viewDidUnLoad
{
	[super viewDidUnload];
	[mainTableView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{ 
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
	// Return the number of rows in the section.
	return [self.trainNumberArray count];
	
	
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{		
	
	return 90.0f;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * identifier = @"identifier";
	QueryTicketResultCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[[QueryTicketResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
        
		
	}
    // [UIImageView ImageViewWithFrame:CGRectMake(0, 0, 320, 90) image:[self imageWithColor:FontColor779BCA]];

    
	TicketModel *ticketModel = nil;
	ticketModel = (TicketModel *)[self.trainNumberArray objectAtIndex:indexPath.row];
	cell.trainCodeLabel.text = ticketModel.trainCode;
    cell.fromLocationLabel.text = ticketModel.fromLocation;
    cell.toLocationLabel.text = ticketModel.toLocation;

    cell.fromTimeLabel.text = ticketModel.fromTime;
    cell.toTimeLabel.text = ticketModel.toTime;
    cell.durationLabel.text = ticketModel.duration;
    
    
    [cell refresh:ticketModel];

    
   
    if ([ticketModel.orderString isEqualToString:@""]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.9];
        
        
        if (![ticketModel.beginSalesString isEqualToString:@""])
        {
            
            UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(210, 10, 80, 50)];
            label.backgroundColor=[UIColor whiteColor];
            label.textColor=[UIColor redColor];
            //label.layer.opacity=0.8;
            label.textAlignment=UITextAlignmentCenter;
            label.numberOfLines=0;
            label.tag=333;
            label.layer.cornerRadius=5;
            //label.layer.masksToBounds=YES;
            label.text=ticketModel.beginSalesString;            
            [cell.contentView addSubview:label];
            [label release];
        }
        else
        {
            for (UIView* v in [cell.contentView subviews] ) {
                if (v.tag==333) {
                    [v removeFromSuperview];
                }
            }
            
            
        }
        //cell.layer.opacity=0.7;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.backgroundView=nil;
        cell.backgroundColor=[UIColor whiteColor];
        cell.layer.opacity=1;
        
        for (UIView* v in [cell.contentView subviews] ) {
            if (v.tag==333) {
                [v removeFromSuperview];
            }
        }

        
    }
    
    

	
	// Configure the cell...
	
	return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    
    TicketModel *ticketModel = nil;
	ticketModel = (TicketModel *)[self.trainNumberArray objectAtIndex:indexPath.row];

    
    if (cell.accessoryType==UITableViewCellAccessoryDisclosureIndicator) {
        
        
        BookingTicketViewController* book=[[BookingTicketViewController alloc] initWithStyle:UITableViewStyleGrouped];
        book.orderString=ticketModel.orderString;
        [self.navigationController pushViewController:book animated:YES];
        [book release];
        

    }
    
 }















-(void)queryTickets
{
    
	
	MBProgressHUD* HUD=[[MBProgressHUD alloc] initWithView:self.view];
	HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = @" 亲，正在努力为您查询... ";
	HUD.margin = 30.f;
	HUD.yOffset = -40.f;
	[self.view addSubview:HUD];
	[HUD showWhileExecuting:@selector(requestData) onTarget:self withObject:nil animated:YES];
	
	
	
}



-(void)requestData
{
	
    //(Request-Line)	GET /otsweb/order/querySingleAction.do?method=queryLeftTicket&orderRequest.train_date=2013-01-19&orderRequest.from_station_telecode=BJP&orderRequest.to_station_telecode=WHN&orderRequest.train_no=240000G50700&trainPassType=QB&trainClass=QB%23D%23Z%23T%23K%23QT%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%3A00--24%3A00 HTTP/1.1
    //Host	dynamic.12306.cn
    //    User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
    //    Accept	text/plain, */*
    //  Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
    //  Accept-Encoding	gzip, deflate
    //  Connection	keep-alive
    //  Content-Type	application/x-www-form-urlencoded
    //  X-Requested-With	XMLHttpRequest
    //  Referer	https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init
    //  Cookie	JSESSIONID=9315798C04796B32E95E9F2C45919049; helper.regUser=; helper.regSn=03SunaaabdCebebhBABbaahFaagbaaaEaahiaagcaaebaafF; BIGipServerotsweb=2413035786.62495.0000
    
    
    
    NSString* strF=@"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=queryLeftTicket&orderRequest.train_date=%@&orderRequest.from_station_telecode=%@&orderRequest.to_station_telecode=%@&orderRequest.train_no=%@&trainPassType=QB&trainClass=QB#D#Z#T#K#QT#&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=";
	
    
//    NSString* sss=@"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=queryLeftTicket&orderRequest.train_date=2013-01-21&orderRequest.from_station_telecode=BJP&orderRequest.to_station_telecode=SHH&orderRequest.train_no=&trainPassType=QB&trainClass=QB%23D%23Z%23T%23K%23QT%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%3A00--24%3A00";
//    
    
    //https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=queryLeftTicket&orderRequest.train_date=2013-02-09&orderRequest.from_station_telecode=WCN&orderRequest.to_station_telecode=HKN&orderRequest.train_no=&trainPassType=QB&trainClass=QB%23D%23Z%23T%23K%23QT%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%3A00--24%3A00
    
	//NSString* strF=@"date=%@&fromstation=%@&tostation=%@&starttime=%@";
    
    
    
   
    
	NSString* urlStr=[NSString stringWithFormat:strF,[GlobalClass sharedClass].dateString,[GlobalClass sharedClass].startStation.stationCode
                      
                      ,[GlobalClass sharedClass].endStation.stationCode,trainNo];
    
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr=[urlStr stringByAppendingString:[startTimeStr stringByReplacingOccurrencesOfString:@":" withString:@"%3A"]];
    
    
    
	ASIHTTPRequest* req=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    
    //
    //    [req setPostBody:[NSMutableData dataWithData:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setRequestMethod:@"GET"];
    
    //    (Request-Line)	GET /otsweb/order/querySingleAction.do?method=queryLeftTicket&orderRequest.train_date=2013-01-21&orderRequest.from_station_telecode=WCN&orderRequest.to_station_telecode=HKN&orderRequest.train_no=&trainPassType=QB&trainClass=QB%23D%23Z%23T%23K%23QT%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%3A00--24%3A00 HTTP/1.1
    //        Host	dynamic.12306.cn
    //        User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
    //        Accept	text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
    //        Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
    //        Accept-Encoding	gzip, deflate
    //        Connection	keep-alive
    //        Cookie	JSESSIONID=D0F2F9ACD13B7D58E69BF95CA0738EAE; helper.regUser=; helper.regSn=03SunaaabdCebebhBABbaahFaagbaaaEaahiaagcaaebaafF; BIGipServerotsweb=1490616586.22560.0000; BIGipServerportal=3168010506.17183.0000
    
    
    
    //    (Request-Line)	GET /otsweb/order/querySingleAction.do?method=queryLeftTicket&orderRequest.train_date=2013-01-21&orderRequest.from_station_telecode=BJP&orderRequest.to_station_telecode=SHH&orderRequest.train_no=&trainPassType=QB&trainClass=QB%23D%23Z%23T%23K%23QT%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%3A00--24%3A00 HTTP/1.1
    //        Host	dynamic.12306.cn
    //        User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
    //        Accept	text/plain, */*
    //          Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
    //          Accept-Encoding	gzip, deflate
    //          Connection	keep-alive
    //          Content-Type	application/x-www-form-urlencoded
    //          X-Requested-With	XMLHttpRequest
    //          Referer	https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init
    //          Cookie	JSESSIONID=D0F2F9ACD13B7D58E69BF95CA0738EAE; helper.regUser=; helper.regSn=03SunaaabdCebebhBABbaahFaagbaaaEaahiaagcaaebaafF; BIGipServerotsweb=1490616586.22560.0000; BIGipServerportal=3168010506.17183.0000
    
	req.delegate=(id<ASIHTTPRequestDelegate>)self;
    
    [req setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    [req setValidatesSecureCertificate:NO];
    [req setUseCookiePersistence:YES];
    [req applyCookieHeader];
    
	[req addRequestHeader:@"Accept" value:@"text/plain, */*"];
	[req addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init"];
	[req addRequestHeader:@"Accept-Language" value:@"zh-CN"];
	[req addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
	[req addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
	[req addRequestHeader:@"Accept-Encoding" value:@"gzip, deflate"];
	[req addRequestHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
	[req addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    //	[req addRequestHeader:@"Content-Length" value:@"72"];
	[req addRequestHeader:@"Connection" value:@" Keep-Alive"];
    //	[req addRequestHeader:@"Pragma" value:@" Keep-Alive"];
    //	[req addRequestHeader:@"Cache-Control" value:@" no-cache"];
    //
    
    
    //
    //	req.requestCookies=[NSMutableArray arrayWithArray:[CookiesHelper sharedCookiesHelper].cookies];
    //
    //	LogInfo(@"requestCookies %@ ",req.requestCookies);
	//53174e1302ff09f8
	//NSString* str=@"orderRequest.train_date=2013-01-10&orderRequest.from_station_telecode=BJP&orderRequest.to_station_telecode=SHH&orderRequest.train_no=&trainPassType=QB&trainClass=QB%23D%23Z%23T%23K%23QT%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%3A00--24%3A00";
	
    
 	//NSString* str=[NSString stringWithFormat:strF,@"2012-12-31",@"00:00--24:00"];
	
    //	str=[str stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    //	str=[str stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
	
	[req startSynchronous];
	
	
	[self CheckAndProcessResponeData:req.responseData];
	
	
}

//{"datas":"0,<span id='id_240000K5070J' class='base_txtdiv' onmouseover=javascript:onStopHover('240000K5070J#BXP#CUW') onmouseout='onStopOut()'>K507<\/span>,<img src='/otsquery/images/tips/first.gif'>&nbsp;&nbsp;&nbsp;&nbsp;北京西&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;21:35,&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;重庆北&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;00:36,27:01,--,--,--,--,--,<font color='darkgray'>无<\/font>,<font color='darkgray'>无<\/font>,--,<font color='darkgray'>无<\/font>,<font color='darkgray'>无<\/font>,--,\\n1,<span id='id_240000K61907' class='base_txtdiv' onmouseover=javascript:onStopHover('240000K61907#BXP#CUW') onmouseout='onStopOut()'>K619<\/span>,<img src='/otsquery/images/tips/first.gif'>&nbsp;&nbsp;&nbsp;&nbsp;北京西&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;23:11,<img src='/otsquery/images/tips/last.gif'>&nbsp;&nbsp;&nbsp;&nbsp;重庆北&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;07:03,31:52,--,--,--,--,--,<font color='darkgray'>无<\/font>,<font color='darkgray'>无<\/font>,--,<font color='darkgray'>无<\/font>,<font color='darkgray'>无<\/font>,--,","time":"16:39"}
// K507 北京西 21:35 重庆北 00:36 27:01
// K507 北京西 23:11 重庆北 07:03 31:52



-(void)CheckAndProcessResponeData:(NSData*)data
{
	
	if (!data||[data length]==0) {
        
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"没有任何车次" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
		return;
	}
	NSString* ResponeString= [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
	if (!ResponeString) {
		return;
	}
	
	
	LogDebug(@"\n\n==================================ResponeString==================\n%@\n==================================EndResponeString==================\n",ResponeString);
    
    //id results = [[[[SBJsonParser alloc] init] autorelease] objectWithString:ResponeString];
    
    [self jsonpaste:ResponeString];
	
    
	
}


- (void) jsonpaste:(NSString *)results
{
    
    NSRange range=  [results rangeOfString:@"网络可能存在问题，请您重试一下"];
    
    if (range.length>0) {
        
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"网络可能存在问题，请您重试一下" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
        
    }
    
    if (![results hasPrefix:@"0,"]) {
        return;
    }
    
    
    
    
    
    //解析数据
    //1,G105,北京南07:30,上海虹桥13:07,05:37,24,--,145,454,--,--,--,--,--,--,--,\\n
    
    //获取返回数据转换成NSData格式
    
    //0,<span id='id_330000K5980K' class='base_txtdiv' onmouseover=javascript:onStopHover('330000K5980K#BXP#XGN') onmouseout='onStopOut()'>K599</span>,&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;北京西&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;05:25,&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;孝感&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;19:23,13:58,--,--,--,--,--,<font color='darkgray'>无</font>,<font color='darkgray'>无</font>,--,<font color='darkgray'>无</font>,<font color='darkgray'>无</font>,--,<a class='btn130' style='text-decoration:none;'>预&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;订</a>
    
    
    // 0,<span id='id_330000K5980K' class='base_txtdiv' onmouseover=javascript:onStopHover('330000K5980K#BXP#XGN') onmouseout='onStopOut()'>K599</span>,&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;北京西&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;05:25,&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;孝感&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;19:23,13:58,--,--,--,--,--,<font color='darkgray'>无</font>,<font color='darkgray'>无</font>,--,<font color='darkgray'>无</font>,<font color='darkgray'>无</font>,--,<a class='btn130' style='text-decoration:none;'>预&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;订</a>\n1,<span id='id_240000G50700' class='base_txtdiv' onmouseover=javascript:onStopHover('240000G50700#BXP#XJN') onmouseout='onStopOut()'>G507</span>,<img src='/otsweb/images/tips/first.gif'>&nbsp;&nbsp;&nbsp;&nbsp;北京西&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;07:00,&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;孝感北&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;11:49,04:49,1,--,19,<font color='darkgray'>无</font>,--,--,--,--,--,--,--,<a name='btn130_2' class='btn130_2' style='text-decoration:none;' onclick=javascript:getSelected('G507#04:49#07:00#240000G50700#BXP#XJN#11:49#北京西#孝感北#01#09#O*****0001M*****00209*****0001#29FB7E37FD14CF548081EECA5DF73F7BBE75962C4CF835ADED09F1BA#P3')>预&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;订</a>
    
    
   
    
    NSMutableArray* queryResult=[NSMutableArray array];
    
    //    NSString *htmlString = [results valueForKey:@"datas"];
    //
    //    if ([[htmlString stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
    //        return;
    //    }
    NSData *htmlData=[results dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *mstr = [[NSMutableString alloc] init];
    NSRange substr;
    //对\\n进行分隔获取列表数据
    NSArray *trainNumArray = [results componentsSeparatedByString:@"\\n"];
    int trainNumCount = trainNumArray.count;
    
    self.xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [self.xpathParser searchWithXPathQuery:@"//span"];
    
    for (int i=0; i<trainNumCount; i++) {
        
        TicketModel *ticketModel = [[TicketModel alloc] init];
        
        //TFHpple 解析有规律的HTML数据,抓取span标签获取 车次
        TFHppleElement *element = [elements objectAtIndex:i];
        NSString *elementContent = [element text];
        ticketModel.trainCode = elementContent ;
        
        //根据字符串的分隔 解析每一行的数据
        NSArray *trainNumChildArray = [[[[trainNumArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"<font color='darkgray'>无</font>" withString:@"无"] stringByReplacingOccurrencesOfString:@"<font color='#008800'>有</font>" withString:@"有"] componentsSeparatedByString:@","];
        
        //解析发站和发站时间
        NSString *childTitle1 = [trainNumChildArray objectAtIndex:2];
        mstr = [NSMutableString stringWithString:childTitle1];
        substr = [mstr rangeOfString:@"<img src='/otsweb/images/tips/first.gif'>"];
        if (substr.location != NSNotFound) {
            ticketModel.isFrom = 1;
            [mstr deleteCharactersInRange:substr];
        }
        for (int k=0; k<3; k++) {
            substr = [mstr rangeOfString:@"&nbsp;&nbsp;&nbsp;&nbsp;"];
            if (substr.location != NSNotFound) {
                [mstr deleteCharactersInRange:substr];
            }
        }
        ticketModel.fromLocation = [[[mstr componentsSeparatedByString:@"<br>"] objectAtIndex:0]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        ticketModel.fromTime = [[[mstr componentsSeparatedByString:@"<br>"] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        
        //解析发站和发站时间
        NSString *childTitle2 = [trainNumChildArray objectAtIndex:3];
        mstr = [NSMutableString stringWithString:childTitle2];
        substr = [mstr rangeOfString:@"<img src='/otsweb/images/tips/last.gif'>"];
        if (substr.location != NSNotFound) {
            ticketModel.isTO = 1;
            [mstr deleteCharactersInRange:substr];
        }
        substr = [mstr rangeOfString:@"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"];
        if (substr.location != NSNotFound) {
            [mstr deleteCharactersInRange:substr];
        }
        
        for (int k=0; k<2; k++) {
            substr = [mstr rangeOfString:@"&nbsp;&nbsp;"];
            if (substr.location != NSNotFound) {
                [mstr deleteCharactersInRange:substr];
            }
        }
        
        
        substr = [mstr rangeOfString:@"&nbsp;&nbsp;&nbsp;&nbsp;"];
        if (substr.location != NSNotFound) {
            [mstr deleteCharactersInRange:substr];
        }
        
        
        
        ticketModel.toLocation = [[[mstr componentsSeparatedByString:@"<br>"] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        ticketModel.toTime = [[[mstr componentsSeparatedByString:@"<br>"] objectAtIndex:1] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        
        //历时
        ticketModel.duration = [trainNumChildArray objectAtIndex:4];
        //商务座
        ticketModel.businessSeat = [trainNumChildArray objectAtIndex:5];
        //特等座
        ticketModel.specialSeat = [trainNumChildArray objectAtIndex:6];
        //一等座
        ticketModel.AOneSeat = [trainNumChildArray objectAtIndex:7];
        //二等座
        ticketModel.BOneSeat = [trainNumChildArray objectAtIndex:8];
        //高级软卧
        ticketModel.advancedSoftBed = [trainNumChildArray objectAtIndex:9];
        //软卧
        ticketModel.softBed = [trainNumChildArray objectAtIndex:10];
        //硬卧
        ticketModel.hardBed = [trainNumChildArray objectAtIndex:11];
        //软座
        ticketModel.softSeat = [trainNumChildArray objectAtIndex:12];
        //硬座
        ticketModel.hardSeat = [trainNumChildArray objectAtIndex:13];
        //无座
        ticketModel.noSeat = [trainNumChildArray objectAtIndex:14];
        //其它
        ticketModel.otherSeat = [trainNumChildArray objectAtIndex:15];
        
        
        NSString* tmpOrderString=[trainNumChildArray objectAtIndex:16];
        
        
        
        
        NSRegularExpression* regexAlert=[[NSRegularExpression alloc] initWithPattern:@"[(][\'](.*)[\'][)]" options:NSRegularExpressionCaseInsensitive error:nil];
        NSTextCheckingResult* rAlert=  [regexAlert firstMatchInString:tmpOrderString options:0 range:(NSRange){0,tmpOrderString.length}];
        [regexAlert release];
        
        if (rAlert.range.length>0) {
            
            int pos=2;
            NSString* msg=[tmpOrderString substringWithRange:(NSRange){rAlert.range.location+pos,rAlert.range.length-pos-2}];
            
            ticketModel.orderString=msg;
            
            
        }else
        {
            
            NSRegularExpression* regexAlert=[[NSRegularExpression alloc] initWithPattern:@"<a class='btn130' style='text-decoration:none;'>(.*)</a>" options:NSRegularExpressionCaseInsensitive error:nil];
            NSTextCheckingResult* rAlert=  [regexAlert firstMatchInString:tmpOrderString options:0 range:(NSRange){0,tmpOrderString.length}];
            [regexAlert release];
            
            if (rAlert.range.length>0) {
                
                int pos=48;
                NSString* msg=[tmpOrderString substringWithRange:(NSRange){rAlert.range.location+pos,rAlert.range.length-pos-4}];
                
                if ([[msg stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""] isEqualToString:@"预订"]) {
                    msg=@"";
                }
                
                ticketModel.beginSalesString=msg;
                
                
            }else
            {
                ticketModel.beginSalesString=@"";
            }
            
            
            
            ticketModel.orderString=@"";
            
            
            //<a class='btn130' style='text-decoration:none;'>01月25日8点起售</a>
        }
        
        
        //        if (<#condition#>) {
        //            <#statements#>
        //        }
        
        
        //  <a name='btn130_2' class='btn130_2' style='text-decoration:none;' onclick=javascript:getSelected('D321#11:42#21:22#240000D32120#VNP#SHH#09:04#北京南#上海#01#04#O*****00004*****0153O*****3008#77ADDD8CE7F36E90E16A18FE04FE2D05224FF4E1E2F7D188659C4F9A#P2')>预&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;订</a>
        
        
        
        //<a class='btn130' style='text-decoration:none;'>预&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;订</a>
        
        
        [queryResult addObject:ticketModel];
        [ticketModel release];
        
        
        
        
    }
    titleButton.titleLabel.text=[GlobalClass sharedClass].dateString;
    [titleButton setNeedsDisplay];
    
//    
//     self.selectedKeys=[[[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil] autorelease];
//    
    
     self.trainNumberArrayAll=queryResult;
    
    //[mainTableView reloadData];
    [self filterData];
    [self onSortClick:(UISegmentedControl*)[sortView viewWithTag:101]];

    

}



@end
