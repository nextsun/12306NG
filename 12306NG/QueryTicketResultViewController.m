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
        
        self.fromTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 45, 20)];
        [self.fromTimeLabel setTextAlignment:UITextAlignmentLeft];
        [self.fromTimeLabel setBackgroundColor:[UIColor clearColor]];
        self.fromTimeLabel.font = [UIFont systemFontOfSize:13];
        self.fromTimeLabel.numberOfLines = 0;
        [self.contentView addSubview:self.fromTimeLabel];
        
        
        labelArrow = [[UILabel alloc] initWithFrame:CGRectMake(65, 35, 10, 20)];
        [labelArrow setText:@"--"];
        [labelArrow setTextAlignment:UITextAlignmentLeft];
        [labelArrow setBackgroundColor:[UIColor clearColor]];
        labelArrow.font = [UIFont systemFontOfSize:13];
        labelArrow.numberOfLines = 0;
        [self.contentView addSubview:labelArrow];
        [labelArrow release];
        
        self.toTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 35, 45, 20)];
        [self.toTimeLabel setTextAlignment:UITextAlignmentLeft];
        [self.toTimeLabel setBackgroundColor:[UIColor clearColor]];
        self.toTimeLabel.font = [UIFont systemFontOfSize:13];
        self.toTimeLabel.numberOfLines = 0;
        [self.contentView addSubview:self.toTimeLabel];
        
        
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 35, 80, 20)];
        [self.durationLabel setTextAlignment:UITextAlignmentLeft];
        [self.durationLabel setBackgroundColor:[UIColor clearColor]];
        self.durationLabel.font = [UIFont systemFontOfSize:13];
        self.durationLabel.numberOfLines = 0;
        [self.contentView addSubview:self.durationLabel];
        
        
        LbTickets1=[[UILabel alloc] initWithFrame:CGRectMake(20, 55, 60, 25)];
        [LbTickets1 setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:LbTickets1];
        LbTickets1.backgroundColor=[UIColor clearColor];
        [LbTickets1 setTextColor:[UIColor redColor]];
        
        
        LbTickets2=[[UILabel alloc] initWithFrame:CGRectMake(80, 55, 60, 25)];
        [LbTickets2 setFont:[UIFont systemFontOfSize:12]];
        LbTickets2.backgroundColor=[UIColor clearColor];
        [self addSubview:LbTickets2];
        [LbTickets2 setTextColor:[UIColor blueColor]];
        
        LbTickets3=[[UILabel alloc] initWithFrame:CGRectMake(140, 55, 60, 25)];
        [LbTickets3 setFont:[UIFont systemFontOfSize:12]];
        LbTickets3.backgroundColor=[UIColor clearColor];
        [self addSubview:LbTickets3];
        [LbTickets3 setTextColor:[UIColor magentaColor]];
        
        LbTickets4=[[UILabel alloc] initWithFrame:CGRectMake(200, 55, 60, 25)];
        [LbTickets4 setFont:[UIFont systemFontOfSize:12]];
        LbTickets4.backgroundColor=[UIColor clearColor];
        [self addSubview:LbTickets4];
        [LbTickets4 setTextColor:[UIColor brownColor]];
        
        LbTickets5=[[UILabel alloc] initWithFrame:CGRectMake(260, 55, 60, 25)];
        [LbTickets5 setFont:[UIFont systemFontOfSize:12]];
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
            [((UILabel*) [lbArrays objectAtIndex:j]) setText:[NSString stringWithFormat:@"%@:%@",[arrName objectAtIndex:i],val]];
            j++;
        }
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
}

@end


@interface QueryTicketResultViewController ()

@end

@implementation QueryTicketResultViewController
@synthesize trainNumberArray;

- (void)dealloc 
{
    self.trainNumberArray = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor=[UIColor clearColor];
    self.title=NSLocalizedString(@"查询结果", nil);
    
    [self showCustomBackButton];
    
    CGRect rect=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-44);
    mainTableView=[[[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped] autorelease]  ;
    [self.view addSubview:mainTableView];
    mainTableView.backgroundColor=[UIColor clearColor];
    mainTableView.backgroundView=nil;
    mainTableView.dataSource=(id<UITableViewDataSource>)self;
    mainTableView.delegate=(id<UITableViewDelegate>)self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    

    
    
    
     
    
    // Do any additional setup after loading the view from its nib.
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

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([ticketModel.orderString isEqualToString:@""]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        //cell.backgroundView=nil;
        cell.backgroundColor=[UIColor lightGrayColor];
        cell.layer.opacity=0.7;
    }
    
    

	
	// Configure the cell...
	
	return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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



@end
