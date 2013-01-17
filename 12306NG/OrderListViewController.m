//
//  OrderListViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "OrderListViewController.h"

@interface OrderListViewController ()

@end

@implementation OrderListViewController
@synthesize orderArray;
@synthesize successArray;
@synthesize postOrder;
@synthesize orderSections;
@synthesize orderTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect rect=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-135);
    self.orderTableView=[[[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped] autorelease]  ;
    [self.view addSubview:self.orderTableView];
    orderTableView.backgroundColor=[UIColor clearColor];
    orderTableView.backgroundView=nil;
    orderTableView.dataSource=(id<UITableViewDataSource>)self;
    orderTableView.delegate=(id<UITableViewDelegate>)self;
    orderTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
}

- (void)viewDidUnload{
    self.orderArray     = nil;
    self.successArray   = nil;
    self.postOrder      = nil;
    self.orderSections  = nil;
    self.orderTableView = nil;
}

// init data info
- (void) initData{
    totalMoney = 0.0f;
    self.title=@"我的订单";
    self.view.backgroundColor=[UIColor clearColor];
    [self showCustomBackButton];
    
    orderSections = [[NSMutableArray alloc] initWithObjects:@"未 支 付 订 单",@"已 支 付 订 单", nil];
    self.orderArray   = [[OrderModel sharedOrderModel] getUnpaidOrder];
    if ([[self.orderArray objectAtIndex:0] isEqualToString:@"YES"]) {
        UNPAID = YES;
    }else{
        UNPAID = NO;
        paymentBtn.enabled = NO;
        cancelBtn.enabled  = NO;
    }
    
    self.postOrder =[self.orderArray objectAtIndex:1];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view addSubview:hud];
    hud.labelText = @"加载中，请稍后...";
    [hud show:YES];
    [hud hide:YES afterDelay:1.5];
    
    self.successArray = [[OrderModel sharedOrderModel] getPaymentSuccessOrder];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (UNPAID) {
            return (2 + [self.orderArray count]);
        }else{
            // Configure the cell.
            return 1;
        }
    }else{
        if ([self.successArray count] == 0) {
            return 1;
        }else{
            return [self.successArray count];
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0) {
        // Configure the cell.
        if (UNPAID) {
            NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
            dict = [self.orderArray objectAtIndex:2];
            
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
                train.text=[dict objectForKey:@"train"];
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
                station.text=[dict objectForKey:@"station"];
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
                date.text=[dict objectForKey:@"date"];
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
                time.text=[dict objectForKey:@"time"];
                time.backgroundColor=[UIColor clearColor];
                [timeView addSubview:time];
                [time release];
                
                cell.accessoryView=timeView;
                [timeView release];
            }
            
            for (int i = 2; i <= ([self.orderArray count] - 1);i++){
                if (indexPath.row == i + 1) {
                    dict = [self.orderArray objectAtIndex:i];
                    
                    NSString *money1 = [NSString stringWithFormat:@"%@",[dict objectForKey:@"money"]];
                    money1 = [money1 stringByReplacingOccurrencesOfString:@"元" withString:@""];
                    money1 = [money1 stringByReplacingOccurrencesOfString:@"," withString:@""];
                    
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
                    passenger.text=[dict objectForKey:@"passenger"];
                    passenger.backgroundColor=[UIColor clearColor];
                    [passengerView addSubview:passenger];
                    [passenger release];
                    
                    UIImage *type = [[[UIImage alloc] init] autorelease];
                    if ([[dict objectForKey:@"type"] isEqualToString:@"成人票,"]) {
                        type = [UIImage imageNamed:@"adult_ticket"];
                    }else if ([[dict objectForKey:@"type"] isEqualToString:@"儿童票,"]) {
                        type = [UIImage imageNamed:@"child_ticket"];
                    }else if ([[dict objectForKey:@"type"] isEqualToString:@"学生票,"]) {
                        type = [UIImage imageNamed:@"student_ticket"];
                    }else{
                        type = [UIImage imageNamed:@"adult_ticket"];
                    }
                    UIImageView *typeImg = [[UIImageView alloc] initWithFrame:CGRectMake(95, 5, 25, 20)];
                    typeImg.image = type;
                    [passengerView addSubview:typeImg];
                    [typeImg release];
                    
                    NSMutableString *tmpStr = [NSMutableString stringWithFormat:@"%@",[dict objectForKey:@"car"]];
                    [tmpStr appendString:[dict objectForKey:@"seat"]];
                    [tmpStr appendString:[dict objectForKey:@"number"]];
                    
                    UILabel* car=[[UILabel alloc] initWithFrame:CGRectMake(125, 0, 90, 30)];
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
                    money.text=[dict objectForKey:@"money"];
                    money.backgroundColor=[UIColor clearColor];
                    [passengerView addSubview:money];
                    [money release];
                    
                    cell.accessoryView=passengerView;
                    [passengerView release];
                }
            }
            
            if (indexPath.row == (1 + [orderArray count])){
                UIView* totalView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
                
                UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
                labelValue.textAlignment=UITextAlignmentLeft;
                labelValue.textColor=[UIColor blackColor];
                labelValue.font = [UIFont fontWithName:@"Helvetica" size:14];
                labelValue.text=@"合计：";
                labelValue.backgroundColor=[UIColor clearColor];
                [totalView addSubview:labelValue];
                [labelValue release];
                
                NSMutableString *tmpMon = [NSMutableString stringWithFormat:@"%.2f",totalMoney];
                [tmpMon appendString:@"元"];
                
                UILabel* money=[[UILabel alloc] initWithFrame:CGRectMake(150, 0, 200, 30)];
                money.textAlignment=UITextAlignmentLeft;
                money.textColor=[UIColor blackColor];
                money.font = [UIFont fontWithName:@"Helvetica" size:14];
                money.text=tmpMon;
                money.backgroundColor=[UIColor clearColor];
                [totalView addSubview:money];
                [money release];
                
                cell.accessoryView=totalView;
                [totalView release];
            }
            
        }else{
            // Configure the cell.
           cell.accessoryView=nil;
            NSString *str = [[[NSString alloc] init] autorelease];
            str = [self.orderArray objectAtIndex:1];
            [[cell textLabel] setText:str];
        }
    }else if (indexPath.section == 1) {
        cell.accessoryView=nil;
        if ([self.successArray count] == 0) {
            [[cell textLabel] setText:@"没有已支付订单"];
        }else{
            NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
            for (int i = 0; i <= ([self.successArray count] - 1);i++){
                if (indexPath.row == i) {
                    dict = [self.successArray objectAtIndex:i];
                    
                    UIView* successView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
                    
                    UILabel* train=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
                    train.textAlignment=UITextAlignmentLeft;
                    train.textColor=[UIColor blackColor];
                    train.font = [UIFont fontWithName:@"Helvetica" size:14];
                    train.text=[dict objectForKey:@"train"];
                    train.backgroundColor=[UIColor clearColor];
                    [successView addSubview:train];
                    [train release];
                    
                    UIImage *start = [UIImage imageNamed:@"start_station"];
                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(60, 5, 20, 20)];
                    img.image = start;
                    [successView addSubview:img];
                    [img release];
                    
                    UILabel* station=[[UILabel alloc] initWithFrame:CGRectMake(85, 0, 150, 30)];
                    station.textAlignment=UITextAlignmentLeft;
                    station.textColor=[UIColor blackColor];
                    station.font = [UIFont fontWithName:@"Helvetica" size:14];
                    station.text=[dict objectForKey:@"station"];
                    station.backgroundColor=[UIColor clearColor];
                    [successView addSubview:station];
                    [station release];
                    
                    UILabel* date=[[UILabel alloc] initWithFrame:CGRectMake(200, 0, 60, 30)];
                    date.textAlignment=UITextAlignmentLeft;
                    date.textColor=[UIColor blackColor];
                    date.font = [UIFont fontWithName:@"Helvetica" size:14];
                    date.text=[dict objectForKey:@"date"];
                    date.backgroundColor=[UIColor clearColor];
                    [successView addSubview:date];
                    [date release];
                    
                    UIImage *point = [UIImage imageNamed:@"triangle"];
                    UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 10, 10, 10)];
                    pointView.image = point;
                    [successView addSubview:pointView];
                    [pointView release];
                    
                    cell.accessoryView=successView;
                    [successView release];
                }
            }
        }
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
    if (indexPath.section == 1) {
        PaymentDoneViewController *done = [[PaymentDoneViewController alloc] init];
        done.orderDict = [self.successArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:done animated:YES];
        [done release];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section
{
    UIView* paymentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    paymentView.backgroundColor = [UIColor clearColor];
    
    
    UIImage *bank = [UIImage imageNamed:@"icon2"];
    UIImageView *bankView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 15, 20)];
    bankView.image = bank;
    [paymentView addSubview:bankView];
    [bankView release];
    
    UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200, 30)];
    labelValue.textAlignment=UITextAlignmentLeft;
    labelValue.textColor=[UIColor whiteColor];
    labelValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    labelValue.text=[orderSections objectAtIndex:section];
    labelValue.backgroundColor=[UIColor clearColor];
    [paymentView addSubview:labelValue];
    [labelValue release];
    
    return paymentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (UNPAID) {
            UIView* footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];

            paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect buttonRect = CGRectMake(25,15,125,40);
            [paymentBtn setFrame:buttonRect];
            paymentBtn.enabled = YES;
            [paymentBtn setBackgroundImage:[UIImage imageNamed:@"blue_btn@2x"] forState:UIControlStateNormal];
            [paymentBtn setTitle:@"支付"      forState:UIControlStateNormal];
            paymentBtn.showsTouchWhenHighlighted = YES;
            [paymentBtn addTarget:self action:@selector(paymentPressed:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:paymentBtn];

            cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect buttonRect1 = CGRectMake(170,15,125,40);
            [cancelBtn setFrame:buttonRect1];
            cancelBtn.enabled = YES;
            [cancelBtn setBackgroundImage:[UIImage imageNamed:@"blue_btn@2x"] forState:UIControlStateNormal];
            [cancelBtn setTitle:@"取消"      forState:UIControlStateNormal];
            cancelBtn.showsTouchWhenHighlighted = YES;
            [cancelBtn addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:cancelBtn];

            return footerView;
        }
    }else if (section == 1){
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

// pressed the payment button
- (void) paymentPressed:(id)sender{
    PaymentViewController* controller=[[PaymentViewController alloc] init];
    controller.paymentDict = self.postOrder;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

// pressed the cancel button
- (void) cancelPressed:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消订单" message:@"您确认取消订单吗?\r\n一天内3次申请车票成功后取消订单，当日将不能在网站购票！" delegate:self cancelButtonTitle:@"取消订单" otherButtonTitles:@"保留订单",nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
            [[OrderModel sharedOrderModel] cancelOrder:self.postOrder];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.view addSubview:hud];
            hud.labelText = @"订单取消中，请稍后...";
            [hud show:YES];
            [hud hide:YES afterDelay:2.0];
            
            self.orderArray   = [[OrderModel sharedOrderModel] getUnpaidOrder];
            if ([[self.orderArray objectAtIndex:0] isEqualToString:@"YES"]) {
                UNPAID = YES;
            }else{
                UNPAID = NO;
                paymentBtn.enabled = NO;
                cancelBtn.enabled  = NO;
                [self.orderTableView reloadData];
            }
            
			break;
        case 1:
            //do nothing
			break;
		default:
            break;
	}
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [orderTableView release];
    [postOrder      release];
    [orderArray     release];
    [successArray   release];
    [orderSections  release];
    [super dealloc];
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView* myView = [[[UIView alloc] init] autorelease];
//    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 22)];
//    if (section == 1) {
//        myView.frame   = CGRectMake(0.0f, 40.0f, 320.0f, 30.0f);
//    }
//
//    myView.backgroundColor = [UIColor clearColor];
//    titleLabel.textColor=[UIColor whiteColor];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.text=[self.orderSections objectAtIndex:section];
//    [myView addSubview:titleLabel];
//    [titleLabel release];
//
//    return myView;
//}

@end
