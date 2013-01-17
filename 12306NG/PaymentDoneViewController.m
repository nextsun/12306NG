//
//  PaymentDoneViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "PaymentDoneViewController.h"

@interface PaymentDoneViewController ()

@end

@implementation PaymentDoneViewController

@synthesize orderDict;
@synthesize successTable;

-(id)initWithorderDict:(NSDictionary *)orderDict_{
    if (self) {
        // Custom initialization
        self.orderDict=orderDict_;
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload{
    self.orderDict    = nil;
    self.successTable = nil;
}

// init data
- (void)initData{
    self.title=@"已支付订单";
    self.view.backgroundColor=[UIColor clearColor];
    [self showCustomBackButton];
    
    CGRect rect=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-40);
    self.successTable=[[[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped] autorelease]  ;
    [self.view addSubview:self.successTable];
    successTable.backgroundColor=[UIColor clearColor];
    successTable.backgroundView=nil;
    successTable.dataSource=(id<UITableViewDataSource>)self;
    successTable.delegate=(id<UITableViewDelegate>)self;
    successTable.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    float totalMoney = 0.0f;
    
    if (indexPath.row == 0) {
        UIView* trainView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        
        UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        labelValue.textAlignment=UITextAlignmentLeft;
        labelValue.textColor=[UIColor blackColor];
        labelValue.font = [UIFont fontWithName:@"Helvetica" size:14];
        labelValue.text=@"车次：";
        labelValue.backgroundColor=[UIColor clearColor];
        [trainView addSubview:labelValue];
        [labelValue release];
        
        
        UILabel* train=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 60, 30)];
        train.textAlignment=UITextAlignmentLeft;
        train.textColor=[UIColor blackColor];
        train.font = [UIFont fontWithName:@"Helvetica" size:14];
        train.text=[self.orderDict objectForKey:@"train"];
        train.backgroundColor=[UIColor clearColor];
        [trainView addSubview:train];
        [train release];
        
        UIImage *start = [UIImage imageNamed:@"start_station"];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(130, 5, 20, 20)];
        img.image = start;
        [trainView addSubview:img];
        [img release];
        
        UILabel* station=[[UILabel alloc] initWithFrame:CGRectMake(150, 0, 150, 30)];
        station.textAlignment=UITextAlignmentLeft;
        station.textColor=[UIColor blackColor];
        station.font = [UIFont fontWithName:@"Helvetica" size:14];
        station.text=[orderDict objectForKey:@"station"];
        station.backgroundColor=[UIColor clearColor];
        [trainView addSubview:station];
        [station release];
        
        cell.accessoryView=trainView;
        [trainView release];
        
    }else if (indexPath.row == 1){
        UIView* dateView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        
        UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        labelValue.textAlignment=UITextAlignmentLeft;
        labelValue.textColor=[UIColor blackColor];
        labelValue.font = [UIFont fontWithName:@"Helvetica" size:14];
        labelValue.text=@"日期：";
        labelValue.backgroundColor=[UIColor clearColor];
        [dateView addSubview:labelValue];
        [labelValue release];
        
        UILabel* date=[[UILabel alloc] initWithFrame:CGRectMake(150, 0, 150, 30)];
        date.textAlignment=UITextAlignmentLeft;
        date.textColor=[UIColor blackColor];
        date.font = [UIFont fontWithName:@"Helvetica" size:14];
        date.text=[self.orderDict objectForKey:@"date"];
        date.backgroundColor=[UIColor clearColor];
        [dateView addSubview:date];
        [date release];
        
        cell.accessoryView=dateView;
        [dateView release];
    }else if (indexPath.row == 2){
        UIView* timeView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        
        UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        labelValue.textAlignment=UITextAlignmentLeft;
        labelValue.textColor=[UIColor blackColor];
        labelValue.font = [UIFont fontWithName:@"Helvetica" size:14];
        labelValue.text=@"时间：";
        labelValue.backgroundColor=[UIColor clearColor];
        [timeView addSubview:labelValue];
        [labelValue release];
        
        UILabel* time=[[UILabel alloc] initWithFrame:CGRectMake(150, 0, 150, 30)];
        time.textAlignment=UITextAlignmentLeft;
        time.textColor=[UIColor blackColor];
        time.font = [UIFont fontWithName:@"Helvetica" size:14];
        time.text=[self.orderDict objectForKey:@"time"];
        time.backgroundColor=[UIColor clearColor];
        [timeView addSubview:time];
        [time release];
        
        cell.accessoryView=timeView;
        [timeView release];
    }else if (indexPath.row == 3){
        NSString *money1 = [NSString stringWithFormat:@"%@",[self.orderDict objectForKey:@"money"]];
        money1 = [money1 stringByReplacingOccurrencesOfString:@"元" withString:@""];
        
        totalMoney = totalMoney + [money1 floatValue];
        UIView* passengerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        
        if (indexPath.row == 3) {
            UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            labelValue.textAlignment=UITextAlignmentLeft;
            labelValue.textColor=[UIColor blackColor];
            labelValue.font = [UIFont fontWithName:@"Helvetica" size:14];
            labelValue.text=@"乘客：";
            labelValue.backgroundColor=[UIColor clearColor];
            [passengerView addSubview:labelValue];
            [labelValue release];
        }
        
        UIImage *point = [UIImage imageNamed:@"start_point"];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(38, 12, 6, 6)];
        img.image = point;
        [passengerView addSubview:img];
        [img release];
        
        UILabel* passenger=[[UILabel alloc] initWithFrame:CGRectMake(44, 0, 70, 30)];
        passenger.textAlignment=UITextAlignmentLeft;
        passenger.textColor=[UIColor blackColor];
        passenger.font = [UIFont fontWithName:@"Helvetica" size:14];
        passenger.text=[self.orderDict objectForKey:@"passenger"];
        passenger.backgroundColor=[UIColor clearColor];
        [passengerView addSubview:passenger];
        [passenger release];
        
        UIImage *type = [[[UIImage alloc] init] autorelease];
        if ([[self.orderDict objectForKey:@"type"] isEqualToString:@"成人票,"]) {
            type = [UIImage imageNamed:@"adult_ticket"];
        }else if ([[self.orderDict objectForKey:@"type"] isEqualToString:@"儿童票,"]) {
            type = [UIImage imageNamed:@"child_ticket"];
        }else if ([[self.orderDict objectForKey:@"type"] isEqualToString:@"学生票,"]) {
            type = [UIImage imageNamed:@"student_ticket"];
        }else{
            type = [UIImage imageNamed:@"adult_ticket"];
        }
        UIImageView *typeImg = [[UIImageView alloc] initWithFrame:CGRectMake(95, 5, 25, 20)];
        typeImg.image = type;
        [passengerView addSubview:typeImg];
        [typeImg release];
        
        NSMutableString *tmpStr = [NSMutableString stringWithFormat:@"%@",[orderDict objectForKey:@"car"]];
        [tmpStr appendString:[self.orderDict objectForKey:@"seat"]];
//        [tmpStr appendString:[self.orderDict objectForKey:@"number"]];
    
        UILabel* car=[[UILabel alloc] initWithFrame:CGRectMake(125, 0, 120, 30)];
        car.textAlignment=UITextAlignmentLeft;
        car.textColor=[UIColor grayColor];
        car.font = [UIFont fontWithName:@"Helvetica" size:10];
        car.text=tmpStr;
        car.backgroundColor=[UIColor clearColor];
        [passengerView addSubview:car];
        [car release];
        
        UILabel* money=[[UILabel alloc] initWithFrame:CGRectMake(220, 0, 80, 30)];
        money.textAlignment=UITextAlignmentLeft;
        money.textColor=[UIColor blackColor];
        money.font = [UIFont fontWithName:@"Helvetica" size:14];
        money.text=[self.orderDict objectForKey:@"money"];
        money.backgroundColor=[UIColor clearColor];
        [passengerView addSubview:money];
        [money release];
        
        cell.accessoryView=passengerView;
        [passengerView release];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView* footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        
        UILabel* info=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
        info.textAlignment=UITextAlignmentLeft;
        info.numberOfLines=2;
        info.textColor=[UIColor grayColor];
        info.font = [UIFont fontWithName:@"Helvetica" size:14];
        info.text=@"暂不支持客户端退改签票服务，请至12306官网www.12306.cn办理相关信息";
        info.backgroundColor=[UIColor clearColor];
        [footerView addSubview:info];
        [info release];
        
        return footerView;;
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [orderDict    release];
    [successTable release];
    [super dealloc];
}

@end
