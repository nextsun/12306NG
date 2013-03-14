//
//  QueryTicketViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "QueryTicketViewController.h"
#import "DatePickerView.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "CookiesHelper.h"
#import "PickerView.h"
#import "NSString+SBJSON.h"
#import "StationListController.h"
#import "JSON.h"
#import "TBXML.h"
#import "HTMLParser.h"
#import "TicketModel.h"
#import "QueryTicketResultViewController.h"

#import "GlobalClass.h"
#import "NSDate-Helper.h"

@interface QueryTicketViewController ()
//- (void) jsonpaste:(NSDictionary *)results;
@property(nonatomic,retain)NSMutableArray* stationResultArray;
@property(nonatomic,retain)NSString* trainNO;

-(void)CheckAndProcessResponeData:(NSData*)data;
@end

@implementation QueryTicketViewController
@synthesize stationResultArray;
@synthesize trainNO;
@synthesize HUD,trainNumberArray,xpathParser;

- (void)dealloc 
{
    self.trainNumberArray = nil;
    self.xpathParser = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = NSLocalizedString(@"Second", @"Second");
		self.tabBarItem.image = [UIImage imageNamed:@"second"];
        trainNO=@"";
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.view.backgroundColor=[UIColor clearColor];
	//[self.navigationController setNavigationBarHidden:YES];
	self.title=@"查询";
    
    
    beginStation=[GlobalClass sharedClass].startStation;
    endStatation=[GlobalClass sharedClass].endStation ;
    queryDate=[GlobalClass sharedClass].dateString;
    
    
    NGCustomButton* subButton=[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [subButton addTarget:self action:@selector(queryTickets:) forControlEvents:UIControlEventTouchUpInside];
    subButton.titleLabel.text=@"查询";
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:subButton] autorelease];
    [subButton release];
    
    //
    [self showCustomBackButton];
	
	
//	UIBarButtonItem* queryButton=[[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(queryTickets:)];
//	self.navigationItem.rightBarButtonItem= queryButton;   
//	[queryButton release];
	
	
	
	mainTableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	mainTableView.dataSource=(id<UITableViewDataSource>)self;
	mainTableView.delegate=(id<UITableViewDelegate>)self;
	mainTableView.backgroundView=nil;
	mainTableView.backgroundColor=[UIColor clearColor];
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
	
	UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
	[mainTableView addGestureRecognizer:tap];
	tap.delegate=(id<UIGestureRecognizerDelegate>)self;    
	[self.view addSubview:mainTableView];
	
    trainNumberArray = [[NSMutableArray alloc] init];
	
	
}
-(void)viewDidUnLoad
{
	[super viewDidUnload];
	[mainTableView release];
}
-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UITableViewCell* cell= [mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	
	if (cell) {
        
        
        UIView* v=  [cell.contentView viewWithTag:1001];
		
		if ((UILabel*)v) {
			
            
			[(UILabel*)[cell.contentView viewWithTag:1001 ] setText:[GlobalClass sharedClass].dateString];
            queryDate=[GlobalClass sharedClass].dateString;
		}
	}
    
    
}
-(void)tap:(id)sender
{
	//[text resignFirstResponder];
	[self.view endEditing:YES];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	return NO;
}
-(void)queryTickets:(UIButton*)btn
{
	//    
	//    if (!text||!text.text
	//        ||[@"" isEqualToString:[text.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
	//        
	//        
	//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];        
	//        hud.mode = MBProgressHUDModeText;
	//        hud.labelText = @"     请输入验证码！     ";
	//        hud.margin = 10.f;
	//        hud.yOffset = -120.f;
	//        hud.removeFromSuperViewOnHide = YES;	
	//        [hud hide:YES afterDelay:2];
	//        [text becomeFirstResponder];
	//        return;
	//        
	//        
	//        
	//        //[text becomeFirstResponder];
	//        return;
	//    }
	//    
	//    if (text.text.length!=1) {
	//        
	//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];        
	//        hud.mode = MBProgressHUDModeText;
	//        hud.labelText = @"     验证码长度有误！     ";
	//        hud.margin = 10.f;
	//        hud.yOffset = -120.f;
	//        hud.removeFromSuperViewOnHide = YES;	
	//        [hud hide:YES afterDelay:2];
	//        [text becomeFirstResponder];
	//        
	//        return;
	//    }
	//    if (![@"" isEqualToString:[text.text  stringByTrimmingCharactersInSet:[NSCharacterSet alphanumericCharacterSet]]]) {
	//        [text becomeFirstResponder];
	//        
	//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];        
	//        hud.mode = MBProgressHUDModeText;
	//        hud.labelText = @"     验证码输入非法！     ";
	//        hud.margin = 10.f;
	//        hud.yOffset = -120.f;
	//        hud.removeFromSuperViewOnHide = YES;	
	//        [hud hide:YES afterDelay:2];
	//        [text becomeFirstResponder];
	//        
	//        return;        
	//        
	//    }
	//    [text resignFirstResponder];
	//    
	
	
	HUD=[[MBProgressHUD alloc] initWithView:self.view];
	HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = @" 亲，正在努力为您查询... ";
	HUD.margin = 30.f;
	HUD.yOffset = -120.f;
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
	
    
    //https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=queryLeftTicket&orderRequest.train_date=2013-02-09&orderRequest.from_station_telecode=WCN&orderRequest.to_station_telecode=HKN&orderRequest.train_no=&trainPassType=QB&trainClass=QB%23D%23Z%23T%23K%23QT%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%3A00--24%3A00
    
	//NSString* strF=@"date=%@&fromstation=%@&tostation=%@&starttime=%@";
	NSString* urlStr=[NSString stringWithFormat:strF,queryDate,beginStation.stationCode,endStatation.stationCode,trainNO];

    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr=[urlStr stringByAppendingString:[queryTimeString stringByReplacingOccurrencesOfString:@":" withString:@"%3A" ]];
    
    

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
    
    
    [self.trainNumberArray removeAllObjects];
    
//    NSString *htmlString = [results valueForKey:@"datas"];
//    
//    if ([[htmlString stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
//        return;
//    }
   NSData *htmlData=[results dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *mstr = [[[NSMutableString alloc] init] autorelease];
    NSRange substr;
    //对\\n进行分隔获取列表数据
    NSArray *trainNumArray = [results componentsSeparatedByString:@"\\n"]; 
    int trainNumCount = trainNumArray.count;
    
    self.xpathParser = [[[TFHpple alloc] initWithHTMLData:htmlData] autorelease];
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
         ticketModel.orderString=@"";
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
 
    }
        
        
//        if (<#condition#>) {
//            <#statements#>
//        }
        
        
      //  <a name='btn130_2' class='btn130_2' style='text-decoration:none;' onclick=javascript:getSelected('D321#11:42#21:22#240000D32120#VNP#SHH#09:04#北京南#上海#01#04#O*****00004*****0153O*****3008#77ADDD8CE7F36E90E16A18FE04FE2D05224FF4E1E2F7D188659C4F9A#P2')>预&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;订</a>
        
        
        
        //<a class='btn130' style='text-decoration:none;'>预&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;订</a>
        
        
        [self.trainNumberArray addObject:ticketModel];
        [ticketModel release];
        
        

        
    }
    
    
    
    QueryTicketResultViewController *queryTicketResultVC = [[QueryTicketResultViewController alloc] init];
    queryTicketResultVC.trainNumberArrayAll = self.trainNumberArray;
    queryTicketResultVC.trainNo=trainNO;
    queryTicketResultVC.startTimeStr=queryTimeString;
    [self.navigationController pushViewController:queryTicketResultVC animated:YES];
    [queryTicketResultVC release];
}


-(NSString*)a1ertString:(NSString*)str pwd:(NSString*)pwd
{
	
	NSString* prand=@"";
	
	for (int i=0; i<pwd.length; i++) {        
		unichar c=[pwd characterAtIndex:i];
		prand=[prand stringByAppendingString:[NSString stringWithFormat:@"%d",c]];
	}
	int sPos=floor(prand.length/5.0);
	
	
	unichar c1=[prand characterAtIndex:sPos];
	unichar c2=[prand characterAtIndex:sPos*2];
	unichar c3=[prand characterAtIndex:sPos*3];
	unichar c4=[prand characterAtIndex:sPos*4];
	unichar c5=[prand characterAtIndex:sPos*5];
	long int mult=[[NSString stringWithFormat:@"%c%c%c%c%c",
			c1,c2,c3,c4,c5] intValue] ;
	
	
	int incr=ceil(pwd.length/2.0);
	
	int modu= pow(2, 31) - 1;
	int salt=(arc4random()*1000000000)%1000000000;  
	prand=[prand stringByAppendingFormat:@"%d",salt];
	
	
	int prand2= (mult * prand.length + incr) % modu;
	
	
	int enc_chr=0;    
	NSString* enc_str=@"";
	
	for (int i=0; i<str.length; i++) {
		enc_chr=((int)[str characterAtIndex:i])^(int)floor((double)prand2/modu*255);        
		if (enc_chr<16) {
			enc_str=[enc_str stringByAppendingFormat:@"0%x",enc_chr];
		}else {
			enc_str=[enc_str stringByAppendingFormat:@"%x",enc_chr];
		}  
		prand2 = (mult * prand2 + incr) % modu;        
	}
	NSString* salt2=[NSString stringWithFormat:@"%x",salt];
	
	while (salt2.length<8) {
		salt2=[@"0" stringByAppendingString:salt2];
	}    
	enc_str=[enc_str stringByAppendingString:salt2];    
	LogDebug(@"%@",enc_str);
	return enc_str;    
}   

- (void)requestFinished:(ASIHTTPRequest *)request_
{
	
	LogDebug(@"requestFinished");
}
- (void)requestFailed:(ASIHTTPRequest *)request{
	LogDebug(@"requestFailed:%@",request.error);
}
- (void)requestRedirected:(ASIHTTPRequest *)request
{
	LogDebug(@"requestRedirected");
	
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	} else {
		return YES;
	}
}
- (void)listView:(StationListController *)listView didSelectWithValue:(NSString*)stationName
{
	if (listView.tag<10000) {
		return;
	}
	//NSLog(@"%d",listView.tag);
	int section=(listView.tag-10000)/100;
	int row=(listView.tag-10000)%100;
	

	UITableViewCell* cell= [mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
	
	if (cell) {
		
		if ((UILabel*)[cell.contentView viewWithTag:1001]) {
			[(UILabel*)[cell.contentView viewWithTag:1001 ] setText:stationName];
		} 
	}
	
}
- (void)listStationView:(StationListWithCodeController *)listView didSelectWithValue:(StationInfo*)stationInfo
{
	//NSLog(@"listStationView %d",listView.tag);
	if (listView.tag<10000) {
		return;
	}
	//NSLog(@"%d",listView.tag);
	int section=(listView.tag-10000)/100;
	int row=(listView.tag-10000)%100;
	
	
	if (section==0&&row==1) {
        [beginStation release];
		beginStation=[stationInfo retain];
        
        [GlobalClass sharedClass].startStation=beginStation;
         [[GlobalClass sharedClass] SaveConfig];
        
		//NSLog(@"beginStation %@",beginStation.stationName);
		
	}else if (section==0&&row==2) {
        [endStatation release];
		endStatation=[stationInfo retain];
        [GlobalClass sharedClass].endStation=endStatation;
         [[GlobalClass sharedClass] SaveConfig];
		//NSLog(@"endStatation %@",endStatation.stationName);
	}
	UITableViewCell* cell= [mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
	
	if (cell) {
		
		if ((UILabel*)[cell.contentView viewWithTag:1001]) {
			[(UILabel*)[cell.contentView viewWithTag:1001 ] setText:stationInfo.stationName];
		} 
	}
    
   
	
	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
	return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"Cell_ABC";
	UITableViewCell *cell = [[tableView dequeueReusableCellWithIdentifier:CellIdentifier] retain];
	if (cell==nil) {
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
		
		
		
		
		// Configure the cell...
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle=UITableViewCellSelectionStyleGray;
		UILabel* cellTitle=[[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 50)] autorelease];
		UILabel* cellValue=[[[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width-150, 0, 100, 50)] autorelease];
		cellTitle.backgroundColor=[UIColor clearColor];
		cellValue.backgroundColor=[UIColor clearColor];
		cellTitle.tag=1000;
		cellValue.tag=1001;
		//    cellValue.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
		switch (indexPath.row) {
			case 0:
			{
				
				
				[cellTitle setText:@"出发日期"];
				[cell.contentView addSubview:cellTitle];
				
//				NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//				formater.dateFormat = @"yyyy-MM-dd";
				queryDate=[GlobalClass sharedClass].dateString;
				[cellValue setText:queryDate];
                
                
				
				//[cellValue sizeToFit];
				//[formater release];
				[cell.contentView addSubview:cellValue];
				
				
				break;
			}
				
			case 1:
			{
				
				[cellTitle setText:@"起点站"];
				[cell.contentView addSubview:cellTitle];
				
				[cellValue setText:beginStation.stationName];
				[cell.contentView addSubview:cellValue];
				
				
				break;
			}
			case 2:
			{
				
				[cellTitle setText:@"终点站"];
				[cell.contentView addSubview:cellTitle];
				
				[cellValue setText:endStatation.stationName];
				[cell.contentView addSubview:cellValue];
				
				break;
			}
			case 3:
			{
				
				
				
				queryTimeString=@"00:00--24:00";
				[cellTitle setText:@"出发时间"];
				[cell.contentView addSubview:cellTitle];
				[cellValue setText:@"00:00--24:00"];
				[cell.contentView addSubview:cellValue];
				
				break;
			}
			case 4:
			{
				
				
				
				
				[cellTitle setText:@"出发车次"];
				[cell.contentView addSubview:cellTitle];
				
				[cellValue setText:@""];
				[cell.contentView addSubview:cellValue];
                cellValue.frame=CGRectMake(tableView.frame.size.width-220, 0, 170, 50);
				
				break;
			}
				
				
				
			default:
				break;
		}
	}
	return [cell autorelease] ;
	
	
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
	switch (indexPath.row) {
		case 0:
		{
			
			DatePickerView* picker=[[DatePickerView alloc] initWithTitle:@"出发日期" delegate:self];
			NSString* datestr=  ((UILabel*)[[mainTableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:1001]).text;            
			[picker setCurrentDate:[NSDate dateFromString:datestr withFormat:@"yyyy-MM-dd"]];
			[picker showInView:self.navigationController.view withRect:[[tableView cellForRowAtIndexPath:indexPath] convertRect:CGRectMake(100, 0, 100, 40) toView:self.navigationController.view ] ];
			
			[picker release];
			break;
		}
		case 1:
		{
			StationListWithCodeController* list=[[StationListWithCodeController alloc]init];
            list.infoStart=[GlobalClass sharedClass].startStation;
			//NSLog(@"tag %d ",10000+indexPath.section*100+indexPath.row);
			list.tag=10000+indexPath.section*100+indexPath.row;
			list.delegate=(id<StationListWithCodeControllerDelegate>)self;
			[self.navigationController pushViewController:list animated:YES]; 
			[list release];
			break;
		}
		case 2:
		{
			
			StationListWithCodeController* list=[[StationListWithCodeController alloc]init];
			list.tag=10000+indexPath.section*100+indexPath.row;
            list.infoEnd=[GlobalClass sharedClass].endStation;
			list.delegate=(id<StationListWithCodeControllerDelegate>)self;            
			[self.navigationController pushViewController:list animated:YES]; 
			[list release];
			
			break;
		}
		case 3:
		{
			
			PickerView *pickerView=[[PickerView alloc] initWithTitle:@"出发时间" delegate:self];
			pickerView.tag=101;
			pickerView.dataArray=[NSMutableArray arrayWithObjects:@"00:00--24:00",@"00:00--00:06",@"06:00--12:00",@"12:00--18:00",@"18:00--24:00",nil];
			NSString* timetsr=  ((UILabel*)[[mainTableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:1001]).text;            
			[pickerView setCurrentValue:timetsr];
			
			
			[UIView animateWithDuration:0.3 animations:^{
				mainTableView.contentOffset=CGPointMake(0, 40);
			}];
			
			
			//            
			//            mainTableView.frame=CGRectMake(0, 0, mainTableView.frame.size.width,mainTableView.frame.size.height-260);            
			//            [mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
			//            
			
			[pickerView showInView:self.navigationController.view withRect:[[tableView cellForRowAtIndexPath:indexPath] convertRect:CGRectMake(100, 0, 100, 40) toView:self.navigationController.view ] ];            
			[pickerView release];
			
			break;
		}
		case 4:
		{
			
			
			
			self.stationResultArray=[self getStationArray];
			
			
			NSMutableArray* stationShowArray=[NSMutableArray array];
			
			for (NSMutableDictionary* dict in stationResultArray) {
				
				
				
				[stationShowArray addObject:[NSString stringWithFormat:@"%@(%@%@->%@%@)",
							     [dict objectForKey:@"value"],
							     [dict objectForKey:@"start_station_name"],
							     [dict objectForKey:@"start_time"],
							     [dict objectForKey:@"end_station_name"],
							     [dict objectForKey:@"end_time"]
							     ]];
				
				
			}
			[stationShowArray insertObject:@"         全部" atIndex:0];
			
			
			
			
			
			PickerView *pickerView=[[PickerView alloc] initWithTitle:@"出发车次" delegate:self];
			pickerView.tag=102;
			pickerView.dataArray=stationShowArray;
			
			[pickerView showInView:self.navigationController.view withRect:[[tableView cellForRowAtIndexPath:indexPath] convertRect:CGRectMake(100, 0, 100, 40) toView:self.navigationController.view ] ];
			//            
			//            mainTableView.frame=CGRectMake(0, 0, mainTableView.frame.size.width,mainTableView.frame.size.height-260);            
			//            [mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
			//
			NSString* timetsr=  ((UILabel*)[[mainTableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:1001]).text;            
			[pickerView setCurrentValue:timetsr];
			
			[UIView animateWithDuration:0.3 animations:^{
				mainTableView.contentOffset=CGPointMake(0, 80);
			}];
			
			[pickerView release];
			break;
		}
			
		default:
			break;
	}
	
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
	if ([tableView cellForRowAtIndexPath:indexPath].accessoryType!=UITableViewCellAccessoryNone) {        
		//[tableView.delegate performSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)];
		
		[tableView.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    //[mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    
//    [UIView beginAnimations:nil context:nil];    
//    mainTableView.contentOffset=CGPointMake(0, 100);
//    [UIView commitAnimations];
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [UIView beginAnimations:nil context:nil];
//    mainTableView.contentOffset=CGPointMake(0, 0);
//    [UIView commitAnimations];
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	[self.view endEditing:YES];
	
	
	[self queryTickets:nil];
	
	
	return YES;
}

-(void)datePickerView:(DatePickerView*)picker didPickedWithDate:(NSDate*)date
{
	UITableViewCell* cell= [mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	
	if (cell) {
		
		if ((UILabel*)[cell.contentView viewWithTag:1001]) {
			queryDate=[[date stringWithFormat:@"YYYY-MM-dd"] retain];
            [GlobalClass sharedClass].dateString=queryDate;
			[(UILabel*)[cell.contentView viewWithTag:1001 ] setText:[date stringWithFormat:@"YYYY-MM-dd"]];
		} 
	}
}

-(void)pickerView:(PickerView*)picker didPickedWithValue:(NSObject*)value
{
	NSIndexPath* indexPath;
	
	if (picker.tag==101) {
		indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
		
        [queryTimeString release];
		queryTimeString=[(NSString*)value retain];
		
		
		
		
	}else {
		indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
        
        
        NSString* s=(NSString*)value;
        
        if ([s isEqualToString:@"         全部"]) {
            self.trainNO=@"";
        }else
        {
            
            for (NSMutableDictionary* dict in self.stationResultArray) {
                  if ([s isEqualToString:[NSString stringWithFormat:@"%@(%@%@->%@%@)",
                                       [dict objectForKey:@"value"],
                                       [dict objectForKey:@"start_station_name"],
                                       [dict objectForKey:@"start_time"],
                                       [dict objectForKey:@"end_station_name"],
                                       [dict objectForKey:@"end_time"]
                                       ]]) {
                      
                      self.trainNO=[dict objectForKey:@"id"];
                      break;
                    
                }
            }
            
            
            
            
            
        }
        
        
        
        
		
		
	}
	
	UITableViewCell* cell= [mainTableView cellForRowAtIndexPath:indexPath];
	
	if (cell) {
		
		if ((UILabel*)[cell.contentView viewWithTag:1001]) {
			[(UILabel*)[cell.contentView viewWithTag:1001 ] setText:(NSString*)value];
		} 
	}
	[UIView animateWithDuration:0.3 animations:^{
		mainTableView.contentOffset=CGPointMake(0, 0);
	}];
}
-(void)pickerViewCancle:(PickerView*)picker
{
    [UIView animateWithDuration:0.3 animations:^{
		mainTableView.contentOffset=CGPointMake(0, 0);
	}];
    
}

-(void)loginClick:(id)sender
{
	[self.view endEditing:YES];
	
	
	//    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:@"你使用的是Lite版,请购买正式版!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"购买", nil];
	//    [alert show];
	//    [alert release]; 
	//    return;
	
//	LoginController* login=[[LoginController alloc] init]; 
//	UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:login];  
//	[login release];
//	[self presentModalViewController:nav animated:YES];
//	[nav release];
	
}
-(NSMutableArray*)getStationArray
{
	
	
	/*
	 
	 
	 (Request-Line)	POST /otsweb/order/querySingleAction.do?method=queryststrainall HTTP/1.1
	 Host	dynamic.12306.cn
	 User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20100101 Firefox/14.0.1
	 Accept	application/json, text/javascript, 
	 Accept-Language	zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3
	 Accept-Encoding	gzip, deflate
	 Connection	keep-alive
	 Content-Type	application/x-www-form-urlencoded; charset=UTF-8
	 X-Requested-With	XMLHttpRequest
	 Referer	https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init
	 Content-Length	72
	 Cookie	JSESSIONID=88E7E207FDDAFF51C4453A4DBFD72547; BIGipServerotsweb=2832466186.22560.0000
	 Pragma	no-cache
	 Cache-Control	no-cache
	 
	 
	 */
	
	
	
	
	ASIFormDataRequest* req=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=queryststrainall"]];
	req.delegate=(id<ASIHTTPRequestDelegate>)self;
	
    
    [req setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    [req setValidatesSecureCertificate:NO];
    [req setUseCookiePersistence:YES];
    [req applyCookieHeader];
    
	[req addRequestHeader:@"Accept" value:@"application/json,text/javascript,*/*"];
	[req addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init"];
	[req addRequestHeader:@"Accept-Language" value:@"zh-CN"];
	[req addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
	[req addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
	[req addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
	[req addRequestHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
	[req addRequestHeader:@"Host" value:@" dynamic.12306.cn"];
	[req addRequestHeader:@"Content-Length" value:@"72"];
	[req addRequestHeader:@"Connection" value:@" Keep-Alive"];
	[req addRequestHeader:@"Pragma" value:@" Keep-Alive"];
	[req addRequestHeader:@"Cache-Control" value:@" no-cache"];
	
	
	req.requestCookies=[NSMutableArray arrayWithArray:[CookiesHelper sharedCookiesHelper].cookies];
	
	LogInfo(@"%@",req.requestCookies);
	//53174e1302ff09f8
	NSString* strF=@"date=%@&fromstation=%@&tostation=%@&starttime=%@";
	
	
	NSString* str=[NSString stringWithFormat:strF,queryDate,beginStation.stationCode,endStatation.stationCode,queryTimeString];
	
	str=[str stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
	
	//NSLog(@"%@",str);
	
	[req setPostBody:[NSMutableData dataWithData:[str dataUsingEncoding:NSUTF8StringEncoding]]]; 
	
	[req startSynchronous];
	
	
	NSString* data=req.responseString;
	
	if (!data||[data length]==0) {
		return nil;
	}   
	return  [data JSONValue];
	
}
@end
