//
//  QueryTicketResultViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "QueryTicketResultViewController.h"
#import "TicketModel.h"

//详情cell
@interface  QueryTicketResultCell: UITableViewCell

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
        
        
        self.fromLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 65, 20)];
        [self.fromLocationLabel setTextAlignment:UITextAlignmentLeft];
        [self.fromLocationLabel setBackgroundColor:[UIColor clearColor]];
        self.fromLocationLabel.font = [UIFont systemFontOfSize:13];
        self.fromLocationLabel.numberOfLines = 0;
        [self.contentView addSubview:self.fromLocationLabel];
        
        
        self.toLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 10, 65, 20)];
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
        
        self.toTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 45, 20)];
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
        
	}
    
	return self;
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
    if ([[UIScreen mainScreen] bounds].size.height == 568.0) {
        self = [super initWithNibName:@"QueryTicketResultViewController_ip5" bundle:nibBundleOrNil];
    }else{
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainTableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	mainTableView.dataSource=(id<UITableViewDataSource>)self;
	mainTableView.delegate=(id<UITableViewDelegate>)self;
	mainTableView.backgroundView=nil;
	mainTableView.backgroundColor=[UIColor clearColor];
    
    [self showCustomBackButton];
    
    [self.view addSubview:mainTableView];
    
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
	
	return 70.0f;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * identifier = @"identifier";
	QueryTicketResultCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[[QueryTicketResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
		
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
	
	// Configure the cell...
	
	return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	

}



@end
