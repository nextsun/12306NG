//
//  BookingTicketViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "BookingTicketViewController.h"
#import "AddPassengerViewController.h"
#import "ChooseTravelCompanionViewController.h"
#import "ASIFormDataRequest.h"

@interface BookingTicketViewController ()
@property(nonatomic,retain)NSMutableArray* tableArray;
@property(nonatomic,retain)NSMutableDictionary* dataDict;
@property(nonatomic,retain)NSMutableArray* userListArray;
@end

@implementation BookingTicketViewController
@synthesize tableArray,dataDict,userListArray;
@synthesize orderString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        orderString=@"";
        
        self.tableArray=[NSMutableArray arrayWithObjects:
                         [NSMutableArray arrayWithObjects:
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"车次",@"title",@"trainLine",@"id",@"",@"value",@"",@"mask",nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"日期",@"title",@"trainDate",@"id",@"",@"value",@"",@"mask", nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"时间",@"title",@"trainTime",@"id",@"",@"value",@"",@"mask", nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"证席别",@"title",@"trainSeatType",@"id",@"",@"value",@"",@"mask", nil],
                          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"验证码",@"title",@"code",@"id",@"",@"value",@"",@"mask", nil],
                          
                          nil],nil];
        
        
        self.dataDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"C209",@"trainLine",
                       @"2013-02-02",@"trainDate",
                       @"18:00-23:00",@"trainTime",
                       @"",@"trainSeatType",
                       @"",@"code",
                       nil];

        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor=[UIColor clearColor];
    self.title=NSLocalizedString(@"新增订单", nil);
    //self.navigationItem.rightBarButtonItem=self.editButtonItem;
    [self showCustomBackButton];
    
    NGCustomButton* subButton=[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [subButton addTarget:self action:@selector(onSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    subButton.titleLabel.text=@"提交订单";
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:subButton] autorelease];
    [subButton release];

    
//    CGRect rect=CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-44);
//    self.mainTableView=[[[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped] autorelease]  ;
//    [self.view addSubview:self.mainTableView];
//    mainTableView.backgroundColor=[UIColor clearColor];
//    mainTableView.backgroundView=nil;
//    mainTableView.dataSource=(id<UITableViewDataSource>)self;
//    mainTableView.delegate=(id<UITableViewDelegate>)self;
//    mainTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    //isKeyBoardShow=NO;
    
    //[self registerForKeyboardNotifications];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [tableArray count]+2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
         return [[tableArray objectAtIndex:section]  count];
    }else if (section==1)
    {
        return [userListArray count];
    }
    else if (section==2)
    {
        return 1;
    }
    return 0;
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //static NSString *CellIdentifier = @"Cell_ABC";
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell-%d-%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    
    if (indexPath.section==0) {
        
    
        NSMutableDictionary* cellDict=[[tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text=[cellDict valueForKey:@"title"];
        cell.textLabel.textColor=[UIColor colorWithWhite:0.2 alpha:0.9];
        
        NSString* itemID=[cellDict objectForKey:@"id"];
        if ([itemID isEqualToString:@"sex"]) {
            
            
            UISegmentedControl* segSexControl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"男",@"女", nil]];
            segSexControl.frame=CGRectMake(10, 15, 180, 30);
            segSexControl.segmentedControlStyle=UISegmentedControlStylePlain;
            [segSexControl addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventValueChanged];
            //segSexControl.selectedSegmentIndex=[[self.dataDict objectForKey:[cellDict objectForKey:@"id"]] isEqualToString:@"M"]?0:1;
            cell.accessoryView=segSexControl;
            //[segControl release];
            
            
        }
        else if ([itemID isEqualToString:@"birthday"]||[itemID isEqualToString:@"idType"]||[itemID isEqualToString:@"userType"])  {
            
            
            
            UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0,200, 30)];
            
            UILabel* labelValue=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
            
            labelValue.textAlignment=UITextAlignmentRight;
            labelValue.textColor=[UIColor greenColor];
            
            labelValue.tag=101;
//            if ([itemID isEqualToString:@"birthday"]) {
//                labelValue.text=[self.dataDict objectForKey:itemID];
//            }else
//            {
//                labelValue.text=[DDHelper nameForCode:[self.dataDict objectForKey:itemID] withKey:itemID];
//            }
//            
            
            labelValue.backgroundColor=[UIColor clearColor];
            [v addSubview:labelValue];
            [labelValue release];
            
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [btn setUserInteractionEnabled:NO];
            btn.frame=CGRectMake(170, 0, 30, 30);
            [v addSubview:btn];
            
            
            
            cell.accessoryView=v;
            [v release];
            
        }
        
        else {
            
            
            
            UITextField* textName=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
            //textName.borderStyle=UITextBorderStyleLine;
            textName.borderStyle=UITextBorderStyleNone;
            textName.textColor=[UIColor greenColor];
            textName.accessibilityLabel=[cellDict objectForKey:@"id"];
            textName.text=[self.dataDict objectForKey:[cellDict objectForKey:@"id"]];
            textName.placeholder=[cellDict objectForKey:@"mask"];
            textName.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            cell.accessoryView=textName;
            //textName.delegate=self;
            [textName release];
        }
    }
    
    
    else
        
        if (indexPath.section==1) {
    
        }
      else
            
            if (indexPath.section==2&&indexPath.row==0) {
                
                
                
                
                cell.accessoryType=UITableViewCellAccessoryNone;
                cell.textLabel.text=@"";
                //cell.backgroundColor=[UIColor whiteColor];
                //cell.backgroundView=nil;
                
                UIButton* labelValue=[UIButton buttonWithType:UIButtonTypeRoundedRect];
                [labelValue addTarget:self action:@selector(onAddNewCustomClick) forControlEvents:UIControlEventTouchUpInside];
                labelValue.frame=CGRectMake(0, 0, cell.frame.size.width-20, 44);
                labelValue.backgroundColor=[UIColor clearColor];
                [labelValue setTitle:@"✚添加乘客" forState:UIControlStateNormal];
                //                     labelValue sett=@"";
                //            labelValue.backgroundColor=[UIColor clearColor];
                cell.accessoryView=labelValue;
                cell.editingAccessoryView=labelValue;
                //[labelValue release];
                
            }else {
                
                cell.textLabel.text=[[userListArray objectAtIndex:indexPath.row] objectForKey:@"passenger_name"];
                cell.textLabel.backgroundColor=[UIColor clearColor];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.accessoryView=nil;
                cell.editingAccessoryView=nil;
            }

        
        
    
    return cell ;
}
-(void)onSubmitClick
{
    
    //
    
    
    NSMutableDictionary* orderDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"",@"",
                                    @"",@"",
                                    nil];
    
    
    [self confirmSingleForQueueOrderInfo:orderDict];
    
    
}

-(void)onAddNewCustomClick
{
    
    UIActionSheet* actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:@"在同行旅客中选择" otherButtonTitles:@"新建旅客", nil];
    [actionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex==1) {
        
        
        
        
        AddPassengerViewController* add=[[AddPassengerViewController alloc] init];        
        UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:add];
        [add release];
        [self.navigationController presentModalViewController:nav animated:YES];
        [nav release];
        
        
    }else if (buttonIndex==0)
    {
       
        ChooseTravelCompanionViewController* choose=[[ChooseTravelCompanionViewController alloc] init];
        UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:choose];
        [choose release];
        [self.navigationController presentModalViewController:nav animated:YES];
        [nav release];
    }
    
}

-(void)setOrderString:(NSString *)orderString_
{
    //D321#11:42#21:22#240000D32120#VNP#SHH#09:04#北京南#上海#01#04#O*****00004*****0149O*****3012#EE13F2035B56773B6EFAF3D07F612E1E0065CD96F40078B0A4D3BAFB#P2
    
   
    
    NSArray* arr=[orderString_ componentsSeparatedByString:@"#"];
    
    if ([arr count]>5) {
        
        
        self.dataDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                       [arr  objectAtIndex:0 ],@"trainLine",
                       @"2013-02-02",@"trainDate",
                       @"18:00-23:00",@"trainTime",
                       @"",@"trainSeatType",
                       @"",@"code",
                       nil];
        
        
        [orderString release];
        orderString=[orderString_ retain];
    }
    
    
    
    
}


-(void)confirmSingleForQueueOrderInfo:(NSMutableDictionary*)info
{
    
   //
//    (Request-Line)	POST /otsweb/order/confirmPassengerAction.do?method=confirmSingleForQueueOrder HTTP/1.1
//        Host	dynamic.12306.cn
//        User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
//        Accept	application/json, text/javascript, */*
//     Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
//     Accept-Encoding	gzip, deflate
//     Connection	keep-alive
//     Content-Type	application/x-www-form-urlencoded; charset=UTF-8
//     X-Requested-With	XMLHttpRequest
//     Referer	https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init
//     Content-Length	1211
//     Cookie	JSESSIONID=5533CC1E687540F36EE7E2CA0C7D7FD2; helper.regUser=; helper.regSn=03SunaaabdCebebhBABbaahFaagbaaaEaahiaagcaaebaafF; BIGipServerotsweb=2127823114.48160.0000
//     Pragma	no-cache
//     Cache-Control	no-cache
    
                                                     
 //                                                    org.apache.struts.taglib.html.TOKEN=ee2420fcec0f6ace0479038450305782&leftTicketStr=1001053128400935001310010500793006150064&textfield=%E4%B8%AD%E6%96%87%E6%88%96%E6%8B%BC%E9%9F%B3%E9%A6%96%E5%AD%97%E6%AF%8D&checkbox1=1&orderRequest.train_date=2013-02-04&orderRequest.train_no=270000260441&orderRequest.station_train_code=2601&orderRequest.from_station_telecode=BJP&orderRequest.to_station_telecode=LFP&orderRequest.seat_type_code=&orderRequest.ticket_type_order_num=&orderRequest.bed_level_order_num=000000000000000000000000000000&orderRequest.start_time=04%3A22&orderRequest.end_time=05%3A15&orderRequest.from_station_name=%E5%8C%97%E4%BA%AC&orderRequest.to_station_name=%E5%BB%8A%E5%9D%8A%E5%8C%97&orderRequest.cancel_flag=1&orderRequest.id_mode=Y&passengerTickets=3%2Cundefined%2C1%2C%E9%93%81%E8%B7%AF%2C1%2C110101198011111114%2C18912345678%2CY&oldPassengers=%E9%93%81%E8%B7%AF%2C1%2C110101198011111114&passenger_1_seat=3&passenger_1_ticket=1&passenger_1_name=%E9%93%81%E8%B7%AF&passenger_1_cardtype=1&passenger_1_cardno=110101198011111114&passenger_1_mobileno=18912345678&checkbox9=Y&oldPassengers=&checkbox9=Y&oldPassengers=&checkbox9=Y&oldPassengers=&checkbox9=Y&randCode=86jk&orderRequest.reserve_flag=A
    
   //{"errMsg":"Y"}
//
    //org.apache.struts.taglib.html.TOKEN=ee2420fcec0f6ace047903845030578\   token  \
    &leftTicketStr=1001053128400935001310010500793006150064\
    &textfield=%E4%B8%AD%E6%96%87%E6%88%96%E6%8B%BC%E9%9F%B3%E9%A6%96%E5%AD%97%E6%AF%8D\  中文或拼音首字母\
    &checkbox1=1\
    &orderRequest.train_date=2013-02-04\
    &orderRequest.train_no=270000260441\
    &orderRequest.station_train_code=2601\
    &orderRequest.from_station_telecode=BJP\
    &orderRequest.to_station_telecode=LFP\
    &orderRequest.seat_type_code=\
    &orderRequest.ticket_type_order_num=\
    &orderRequest.bed_level_order_num=000000000000000000000000000000\
    &orderRequest.start_time=04%3A22\
    &orderRequest.end_time=05%3A15\
    &orderRequest.from_station_name=%E5%8C%97%E4%BA%AC\
    &orderRequest.to_station_name=%E5%BB%8A%E5%9D%8A%E5%8C%97&orderRequest.cancel_flag=1\
    &orderRequest.id_mode=Y\
    &passengerTickets=3%2Cundefined%2C1%2C%E9%93%81%E8%B7%AF%2C1%2C110101198011111114%2C18912345678%2CY\
    &oldPassengers=%E9%93%81%E8%B7%AF%2C1%2C110101198011111114\
    &passenger_1_seat=3&passenger_1_ticket=1\
    &passenger_1_name=%E9%93%81%E8%B7%AF\
    &passenger_1_cardtype=1\
    &passenger_1_cardno=110101198011111114\
    &passenger_1_mobileno=18912345678\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &randCode=86jk\
    &orderRequest.reserve_flag=A
    
    
    
    
    
    
    
    
    
    
    
    
    
    ASIFormDataRequest* request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/passengerAction.do?method=modifyPassenger"]];
    
    [request setCachePolicy:ASIUseDefaultCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setValidatesSecureCertificate:NO];
    [request addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,*/*"];
    [request addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/passengerAction.do?method=initModifyPassenger"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    //[req addRequestHeader:@"Content-Length" value:@" 166"];
    [request addRequestHeader:@"Connection" value:@" Keep-Alive"];
    //[req addRequestHeader:@"Cache-Control" value:@" no-cache"];
    
    
    
    
    NSString* strF=@"org.apache.struts.taglib.html.TOKEN=%@&name=%@&old_name=%@&gender=%@&sex_code=%@&born_date=%@&country_code=CN&card_type=%@&old_card_type=%@&card_no=%@&old_card_no=%@&psgTypeCode=%@&passenger_type=%@&mobile_no=%@&phone_no=&email=%@&address=&postalcode=&studentInfo.province_code=11&studentInfo.school_code=&studentInfo.school_name=%E7%AE%80%E7%A0%81%2F%E6%B1%89%E5%AD%97&studentInfo.department=&studentInfo.school_class=&studentInfo.student_no=&studentInfo.school_system=4&studentInfo.enter_year=2002&studentInfo.preference_card_no=&studentInfo.preference_from_station_name=%E7%AE%80%E7%A0%81%2F%E6%B1%89%E5%AD%97&studentInfo.preference_from_station_code=&studentInfo.preference_to_station_name=%E7%AE%80%E7%A0%81%2F%E6%B1%89%E5%AD%97&studentInfo.preference_to_station_code=";
    
    
    NSString* tmp=[self getSubOrderTokenAndleftTicketStr];
    NSArray* arr=[tmp componentsSeparatedByString:@","];
    
    
    //D321#11:42#21:22#240000D32120#VNP#SHH#09:04#北京南#上海#01#04#O*****00004*****0149O*****3012#EE13F2035B56773B6EFAF3D07F612E1E0065CD96F40078B0A4D3BAFB#P2
    
    
    
    NSArray* arrOrder=[orderString componentsSeparatedByString:@"#"];
    
    
     [request setPostValue:[arr objectAtIndex:0] forKey:@"org.apache.struts.taglib.html.TOKEN"];
    [request setPostValue:[arr objectAtIndex:1] forKey:@"leftTicketStr"];
    [request setPostValue:@"1" forKey:@"checkbox1"];
    [request setPostValue:@"2013-02-04" forKey:@"orderRequest.train_date"];
    [request setPostValue:[arrOrder objectAtIndex:3] forKey:@"orderRequest.train_no"];
    [request setPostValue:[arrOrder objectAtIndex:0] forKey:@"orderRequest.station_train_code"];
    [request setPostValue:[arrOrder objectAtIndex:4] forKey:@"orderRequest.from_station_telecode"];
    [request setPostValue:[arrOrder objectAtIndex:5] forKey:@"orderRequest.to_station_telecode"];
    [request setPostValue:@"" forKey:@"orderRequest.seat_type_code"];
    [request setPostValue:@"" forKey:@"orderRequest.ticket_type_order_num"];
    [request setPostValue:@"000000000000000000000000000000" forKey:@"orderRequest.bed_level_order_num"];
    [request setPostValue:[arrOrder objectAtIndex:1] forKey:@"orderRequest.start_time"];
    [request setPostValue:[arrOrder objectAtIndex:2] forKey:@"orderRequest.end_time"];
    [request setPostValue:[arrOrder objectAtIndex:6] forKey:@"orderRequest.from_station_name"];
    [request setPostValue:[arrOrder objectAtIndex:7] forKey:@"orderRequest.to_station_name"];
    [request setPostValue:@"1" forKey:@"orderRequest.cancel_flag"];
    [request setPostValue:@"Y" forKey:@"orderRequest.id_mode"];
    [request setPostValue:@"3,0,1,铁路,1,110101198011111114,18912345678,Y" forKey:@"passengerTickets"];
    [request setPostValue:@"铁路,1,110101198011111114" forKey:@"oldPassengers"];
    [request setPostValue:@"3" forKey:@"passenger_1_seat"];
    [request setPostValue:@"" forKey:@"passenger_1_ticket"];
    [request setPostValue:@"" forKey:@"passenger_1_name"];
    [request setPostValue:@"" forKey:@"passenger_1_cardtype"];
    [request setPostValue:@"" forKey:@"passenger_1_cardno"];
     [request setPostValue:@"" forKey:@"passenger_1_mobileno"];
     [request setPostValue:@"Y" forKey:@"checkbox9"];
     [request setPostValue:@"" forKey:@"randCode"];
     [request setPostValue:@"A" forKey:@"orderRequest.reserve_flag"];
    
    //org.apache.struts.taglib.html.TOKEN=ee2420fcec0f6ace047903845030578\   token  \
    &leftTicketStr=1001053128400935001310010500793006150064\   和token 一起的\
    &textfield=%E4%B8%AD%E6%96%87%E6%88%96%E6%8B%BC%E9%9F%B3%E9%A6%96%E5%AD%97%E6%AF%8D\  中文或拼音首字母\
    &checkbox1=1\
    &orderRequest.train_date=2013-02-04\   \
    &orderRequest.train_no=270000260441\
    &orderRequest.station_train_code=2601\
    &orderRequest.from_station_telecode=BJP\
    &orderRequest.to_station_telecode=LFP\
    &orderRequest.seat_type_code=\
    &orderRequest.ticket_type_order_num=\
    &orderRequest.bed_level_order_num=000000000000000000000000000000\
    &orderRequest.start_time=04%3A22\
    &orderRequest.end_time=05%3A15\
    &orderRequest.from_station_name=%E5%8C%97%E4%BA%AC\
    &orderRequest.to_station_name=%E5%BB%8A%E5%9D%8A%E5%8C%97\
    &orderRequest.cancel_flag=1\
    &orderRequest.id_mode=Y\
    &passengerTickets=3%2Cundefined%2C1%2C%E9%93%81%E8%B7%AF%2C1%2C110101198011111114%2C18912345678%2CY\
    &oldPassengers=%E9%93%81%E8%B7%AF%2C1%2C110101198011111114\
    &passenger_1_seat=3\
    &passenger_1_ticket=1\
    &passenger_1_name=%E9%93%81%E8%B7%AF\
    &passenger_1_cardtype=1\
    &passenger_1_cardno=110101198011111114\
    &passenger_1_mobileno=18912345678\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &oldPassengers=\
    &checkbox9=Y\
    &randCode=86jk\
    &orderRequest.reserve_flag=A
    [request startSynchronous];
    
    
    

}


-(NSString*)getSubOrderTokenAndleftTicketStr
{
    //(Request-Line)	POST /otsweb/passengerAction.do?method=initAddPassenger& HTTP/1.1
    //Host	dynamic.12306.cn
    //User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
    //Accept	text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
    //Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
    //Accept-Encoding	gzip, deflate
    //Connection	keep-alive
    //Referer	https://dynamic.12306.cn/otsweb/passengerAction.do?method=initUsualPassenger
    //Cookie	JSESSIONID=E78564464379ABC2008F9A9E6EC0126E; BIGipServerotsweb=2345926922.62495.0000; BIGipServerotsquery=2363031818.59425.0000
    //Content-Type	application/x-www-form-urlencoded
    //Content-Length	217
    
    
    ASIFormDataRequest* request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/passengerAction.do?method=initModifyPassenger"]];
    [request setCachePolicy:ASIUseDefaultCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setValidatesSecureCertificate:NO];
    [request addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,*/*"];
    [request addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/passengerAction.do?method=initModifyPassenger"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    [request addRequestHeader:@"Connection" value:@" Keep-Alive"];
    
    [request startSynchronous];
    
    
    LogInfo(@"%@",request.responseString);
    
    //<input type="hidden" name="org.apache.struts.taglib.html.TOKEN" value="7464e55fe3305bfd4805669e14bff9ce">
    
    NSString* retString=request.responseString;
    
    NSRegularExpression* regexAlert=[[NSRegularExpression alloc] initWithPattern:@"<input type=[\"]hidden[\"] name=[\"]org.apache.struts.taglib.html.TOKEN[\"] value=[\"](.*)[\"]>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult* rAlert=  [regexAlert firstMatchInString:retString options:0 range:(NSRange){0,retString.length}];
    [regexAlert release];
    
    if (rAlert.range.length>0) {
        
        int pos=70+1;
        NSString* msg=[retString substringWithRange:(NSRange){rAlert.range.location+pos,rAlert.range.length-pos-2}];
        if (![msg isEqualToString:@""]) {
            
            
            //            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            //            [alert release];
            return  msg;
            
        }
    }
    
    return @"";
    
    
    
    
    
    
    
}

-(NSString*)getQueueCount
{
   
    
    //(Request-Line)	GET /otsweb/order/confirmPassengerAction.do?method=getQueueCount&train_date=2013-02-04&train_no=270000260441&station=2601&seat=3&from=BJP&to=LFP&ticket=1001053128400935001310010500793006150064 HTTP/1.1
//    Host	dynamic.12306.cn
//    User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
//    Accept	application/json, text/javascript, */*
//     Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
//     Accept-Encoding	gzip, deflate
//     Connection	keep-alive
//     Content-Type	application/x-www-form-urlencoded
//     X-Requested-With	XMLHttpRequest
//     Referer	https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=init
//     Cookie	JSESSIONID=5533CC1E687540F36EE7E2CA0C7D7FD2; helper.regUser=; helper.regSn=03SunaaabdCebebhBABbaahFaagbaaaEaahiaagcaaebaafF; BIGipServerotsweb=2127823114.48160.0000
//     
    
//     {"countT":0,"count":11,"ticket":"1001053128400935001310010500793006150064","op_1":true,"op_2":false}

    
    ASIFormDataRequest* request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/passengerAction.do?method=initModifyPassenger"]];
    [request setCachePolicy:ASIUseDefaultCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setValidatesSecureCertificate:NO];
    [request addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,*/*"];
    [request addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/passengerAction.do?method=initModifyPassenger"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    [request addRequestHeader:@"Connection" value:@" Keep-Alive"];
    
    [request startSynchronous];
    
    
}
@end
