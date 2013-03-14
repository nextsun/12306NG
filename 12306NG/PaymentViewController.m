//
//  PaymentViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "PaymentViewController.h"
#import "CMBPayViewController.h"
#import "SVWebViewController.h"
#import "NSDate-Helper.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

@synthesize paymentDict;
@synthesize epayDict;
@synthesize paymentArray;
@synthesize paymentTable;

-(id)initWithpaymentDict:(NSDictionary *)paymentDict_{
    if (self) {
        // Custom initialization
        self.paymentDict=paymentDict_;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload{
    self.paymentArray = nil;
    self.paymentDict  = nil;
    self.epayDict     = nil;
    self.paymentTable = nil;
}

- (void)initData{
    self.title=@"支付方式";
    self.view.backgroundColor=[UIColor clearColor];
    [self showCustomBackButton];
    
    
    self.paymentArray = [[NSArray alloc] initWithObjects:@"招商银行",@"建设银行(银联)",@"交通银行(银联)",@"浦东发展银行(银联)",@"中国银联", nil];
     self.epayDict = [[OrderModel sharedOrderModel] queryEpayInfo:paymentDict];
   
    NSString *message = [self.epayDict objectForKey:@"message"];
    
//    if (message.length > 0){
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    CGRect rect=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-40);
    self.paymentTable=[[[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped] autorelease]  ;
    [self.view addSubview:self.paymentTable];
    paymentTable.backgroundColor=[UIColor clearColor];
    paymentTable.backgroundView=nil;
    paymentTable.dataSource=(id<UITableViewDataSource>)self;
    paymentTable.delegate=(id<UITableViewDelegate>)self;
    paymentTable.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.paymentArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0) {
        UIView* paymentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 60)];
        paymentView.backgroundColor = [UIColor clearColor];
        
        UIImage *backGround = [UIImage imageNamed:@"pay_bottom"];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 310, 60)];
        img.image = backGround;
        [paymentView addSubview:img];
        [img release];
        
        UIImage *bank = [UIImage imageNamed:@"cmb"];
        UIImageView *bankView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        bankView.image = bank;
        [paymentView addSubview:bankView];
        [bankView release];
        
        UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 40)];
        labelValue.textAlignment=UITextAlignmentLeft;
        //labelValue.textColor=[UIColor whiteColor];
        labelValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        labelValue.text=[self.paymentArray objectAtIndex:indexPath.section];
        labelValue.backgroundColor=[UIColor clearColor];
        [paymentView addSubview:labelValue];
        [labelValue release];
        
        UILabel* labelValue1=[[UILabel alloc] initWithFrame:CGRectMake(60, 35, 200, 15)];
        labelValue1.textAlignment=UITextAlignmentLeft;
        //labelValue1.textColor=[UIColor whiteColor];
        labelValue1.font = [UIFont fontWithName:@"Helvetica" size:14];
        labelValue1.text=@"支持手机支付";
        labelValue1.backgroundColor=[UIColor clearColor];
        [paymentView addSubview:labelValue1];
        [labelValue1 release];
        
        UIImage *point = [UIImage imageNamed:@"setting_black_triangle"];
        UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 25, 10, 10)];
        pointView.image = point;
        [paymentView addSubview:pointView];
        [pointView release];
        
        cell.accessoryView=paymentView;
        [paymentView release];
        
    }else if (indexPath.section == 1){
        UIView* paymentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 60)];
        paymentView.backgroundColor = [UIColor clearColor];
        
        UIImage *backGround = [UIImage imageNamed:@"pay_bottom"];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 310, 60)];
        img.image = backGround;
        [paymentView addSubview:img];
        [img release];
        
        UIImage *bank = [UIImage imageNamed:@"ccb"];
        UIImageView *bankView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        bankView.image = bank;
        [paymentView addSubview:bankView];
        [bankView release];
        
        UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 40)];
        labelValue.textAlignment=UITextAlignmentLeft;
        //labelValue.textColor=[UIColor whiteColor];
        labelValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        labelValue.text=[self.paymentArray objectAtIndex:indexPath.section];
        labelValue.backgroundColor=[UIColor clearColor];
        [paymentView addSubview:labelValue];
        [labelValue release];
        
        UILabel* labelValue1=[[UILabel alloc] initWithFrame:CGRectMake(60, 35, 200, 15)];
        labelValue1.textAlignment=UITextAlignmentLeft;
        //labelValue1.textColor=[UIColor whiteColor];
        labelValue1.font = [UIFont fontWithName:@"Helvetica" size:14];
        labelValue1.text=@"支持账号支付.可到建设银行官网开通";
        labelValue1.backgroundColor=[UIColor clearColor];
        [paymentView addSubview:labelValue1];
        [labelValue1 release];
        
        UIImage *point = [UIImage imageNamed:@"setting_black_triangle"];
        UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 25, 10, 10)];
        pointView.image = point;
        [paymentView addSubview:pointView];
        [pointView release];
        
        cell.accessoryView=paymentView;
        [paymentView release];
    }else if (indexPath.section == 2){
        UIView* paymentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 60)];
        paymentView.backgroundColor = [UIColor clearColor];
        
        UIImage *backGround = [UIImage imageNamed:@"pay_bottom"];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 310, 60)];
        img.image = backGround;
        [paymentView addSubview:img];
        [img release];
        
        UIImage *bank = [UIImage imageNamed:@"bankcomm"];
        UIImageView *bankView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        bankView.image = bank;
        [paymentView addSubview:bankView];
        [bankView release];
        
        UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(60, 15, 200, 30)];
        labelValue.textAlignment=UITextAlignmentLeft;
        //labelValue.textColor=[UIColor whiteColor];
        labelValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        labelValue.text=[self.paymentArray objectAtIndex:indexPath.section];
        labelValue.backgroundColor=[UIColor clearColor];
        [paymentView addSubview:labelValue];
        [labelValue release];
        
        UIImage *point = [UIImage imageNamed:@"setting_black_triangle"];
        UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 25, 10, 10)];
        pointView.image = point;
        [paymentView addSubview:pointView];
        [pointView release];
        
        cell.accessoryView=paymentView;
        [paymentView release];
    }else if (indexPath.section == 3){
        UIView* paymentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 60)];
        paymentView.backgroundColor = [UIColor clearColor];
        
        UIImage *backGround = [UIImage imageNamed:@"pay_bottom"];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 310, 60)];
        img.image = backGround;
        [paymentView addSubview:img];
        [img release];
        
        UIImage *bank = [UIImage imageNamed:@"spdb"];
        UIImageView *bankView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        bankView.image = bank;
        [paymentView addSubview:bankView];
        [bankView release];
        
        UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(60, 15, 200, 30)];
        labelValue.textAlignment=UITextAlignmentLeft;
        //labelValue.textColor=[UIColor whiteColor];
        labelValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        labelValue.text=[self.paymentArray objectAtIndex:indexPath.section];
        labelValue.backgroundColor=[UIColor clearColor];
        [paymentView addSubview:labelValue];
        [labelValue release];
        
        UIImage *point = [UIImage imageNamed:@"setting_black_triangle"];
        UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 25, 10, 10)];
        pointView.image = point;
        [paymentView addSubview:pointView];
        [pointView release];
        
        cell.accessoryView=paymentView;
        [paymentView release];
    }else if (indexPath.section == 4){
        UIView* paymentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 310, 60)];
        paymentView.backgroundColor = [UIColor clearColor];
        
        UIImage *backGround = [UIImage imageNamed:@"pay_bottom"];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 310, 60)];
        img.image = backGround;
        [paymentView addSubview:img];
        [img release];
        
        UIImage *bank = [UIImage imageNamed:@"up"];
        UIImageView *bankView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        bankView.image = bank;
        [paymentView addSubview:bankView];
        [bankView release];
        
        UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(60, 15, 200, 30)];
        labelValue.textAlignment=UITextAlignmentLeft;
        //labelValue.textColor=[UIColor whiteColor];
        labelValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        labelValue.text=[self.paymentArray objectAtIndex:indexPath.section];
        labelValue.backgroundColor=[UIColor clearColor];
        [paymentView addSubview:labelValue];
        [labelValue release];
        
        UIImage *point = [UIImage imageNamed:@"setting_black_triangle"];
        UIImageView *pointView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 25, 10, 10)];
        pointView.image = point;
        [paymentView addSubview:pointView];
        [pointView release];
        
        cell.accessoryView=paymentView;
        [paymentView release];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"即将在下个版本上线，尽情期待！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    return;
    
    
    if (indexPath.section==0) {
        
        
        
        
        /*
        
        NSString* dateString=[[NSDate dateWithTimeIntervalSinceNow:0] stringWithFormat:@"yyyyMMdd"];
        
       
        NSString* billNoString=@"0155005358";
         NSString* moneyString=@"6.00";
        
        
        NSString* formatString=@"https://netpay.cmbchina.com/netpayment/BaseHttp.dll?MfcISAPICommand=TestPrePayWAP&BranchID=0010&CoNo=000000&BillNo=%@&Amount=%@&Date=%@&MerchantUrl=&MerchantPara=";
        
        NSString* realUrlString=[NSString stringWithFormat:formatString,billNoString,moneyString,dateString];
        
        
        
        NSURL *URL = [NSURL URLWithString:realUrlString];
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
        
        [self.navigationController pushViewController:webViewController animated:YES];
        
        [webViewController showCustomBackButton];
        showCustomBackButton
        [webViewController release];
        */
        
        
        CMBPayViewController* cmbpay=[[CMBPayViewController alloc] init];
        [self.navigationController pushViewController:cmbpay animated:YES];
        [cmbpay release];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 4) {
        UIView* footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        
        UILabel* info=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
        info.textAlignment=UITextAlignmentLeft;
        info.numberOfLines=3;
        info.textColor=[UIColor grayColor];
        info.font = [UIFont fontWithName:@"Helvetica" size:14];
        info.text=@"工行、农行、邮政、中国银行等银行无法在iphone安装相关控件，所以无法进行支付，敬请谅解";
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
    [paymentArray    release];
    [paymentDict     release];
    [epayDict        release];
    [paymentTable    release];
    [super dealloc];
}

@end
