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
@interface QueryTicketViewController ()
- (void) jsonpaste:(NSDictionary *)results;
-(void)CheckAndProcessResponeData:(NSData*)data;
@end

@implementation QueryTicketViewController

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
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.view.backgroundColor=[UIColor whiteColor];
	//[self.navigationController setNavigationBarHidden:YES];
	self.title=@"查询";
    
    
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
	HUD.labelText = @"  亲，正在努力为你查询...    ";
	HUD.margin = 10.f;
	HUD.yOffset = -120.f;
	[self.view addSubview:HUD];
	[HUD showWhileExecuting:@selector(requestData) onTarget:self withObject:nil animated:YES];
	
	
	
}



-(void)requestData
{
	

	ASIFormDataRequest* req=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://dynamic.12306.cn/otsquery/query/queryRemanentTicketAction.do?method=queryLeftTicket"]];    
	req.delegate=(id<ASIHTTPRequestDelegate>)self;
	[req setValidatesSecureCertificate:NO];
	[req addRequestHeader:@"Accept" value:@"application/json,text/javascript,*/*"];
	[req addRequestHeader:@"Referer" value:@"http://dynamic.12306.cn/otsquery/query/queryRemanentTicketAction.do?method=init"];
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
	 
//    
//	req.requestCookies=[NSMutableArray arrayWithArray:[CookiesHelper sharedCookiesHelper].cookies];
//
//	LogInfo(@"requestCookies %@ ",req.requestCookies);
	//53174e1302ff09f8
	NSString* str=@"orderRequest.train_date=2013-01-10&orderRequest.from_station_telecode=BJP&orderRequest.to_station_telecode=SHH&orderRequest.train_no=&trainPassType=QB&trainClass=QB%23D%23Z%23T%23K%23QT%23&includeStudent=00&seatTypeAndNum=&orderRequest.start_time_str=00%3A00--24%3A00";
	
	//NSString* strF=@"date=%@&fromstation=%@&tostation=%@&starttime=%@";
	//NSString* str=[NSString stringWithFormat:strF,queryDate,beginStation.stationCode,endStatation.stationCode,queryTimeString];
	//NSString* str=[NSString stringWithFormat:strF,@"2012-12-31",@"00:00--24:00"];
	
//	str=[str stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
//	str=[str stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
	

	[req setPostBody:[NSMutableData dataWithData:[str dataUsingEncoding:NSUTF8StringEncoding]]]; 
	
	[req startSynchronous];
	
	
	[self CheckAndProcessResponeData:req.responseData];
	
	
}

//{"datas":"0,<span id='id_240000K5070J' class='base_txtdiv' onmouseover=javascript:onStopHover('240000K5070J#BXP#CUW') onmouseout='onStopOut()'>K507<\/span>,<img src='/otsquery/images/tips/first.gif'>&nbsp;&nbsp;&nbsp;&nbsp;北京西&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;21:35,&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;重庆北&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;00:36,27:01,--,--,--,--,--,<font color='darkgray'>无<\/font>,<font color='darkgray'>无<\/font>,--,<font color='darkgray'>无<\/font>,<font color='darkgray'>无<\/font>,--,\\n1,<span id='id_240000K61907' class='base_txtdiv' onmouseover=javascript:onStopHover('240000K61907#BXP#CUW') onmouseout='onStopOut()'>K619<\/span>,<img src='/otsquery/images/tips/first.gif'>&nbsp;&nbsp;&nbsp;&nbsp;北京西&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;23:11,<img src='/otsquery/images/tips/last.gif'>&nbsp;&nbsp;&nbsp;&nbsp;重庆北&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;07:03,31:52,--,--,--,--,--,<font color='darkgray'>无<\/font>,<font color='darkgray'>无<\/font>,--,<font color='darkgray'>无<\/font>,<font color='darkgray'>无<\/font>,--,","time":"16:39"}
// K507 北京西 21:35 重庆北 00:36 27:01
// K507 北京西 23:11 重庆北 07:03 31:52
-(void)CheckAndProcessResponeData:(NSData*)data
{
	
	if (!data||[data length]==0) {
		return;
	}
	NSString* ResponeString= [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
	if (!ResponeString) {
		return;
	}
	
	
//	LogDebug(@"\n\n==================================ResponeString==================\n%@\n==================================EndResponeString==================\n",ResponeString);
    
    id results = [[[[SBJsonParser alloc] init] autorelease] objectWithString:ResponeString];
    
    [self jsonpaste:results];
	
		
	
}


- (void) jsonpaste:(NSDictionary *)results
{

    //解析数据 
    //1,<span id='id_240000G10506' class='base_txtdiv' onmouseover=javascript:onStopHover('240000G10506#VNP#AOH') onmouseout='onStopOut()'>G105<\/span>,<img src='/otsquery/images/tips/first.gif'>&nbsp;&nbsp;&nbsp;&nbsp;北京南&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;07:30,<img src='/otsquery/images/tips/last.gif'>&nbsp;&nbsp;上海虹桥&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp;&nbsp;13:07,05:37,24,--,145,454,--,--,--,--,--,--,--,\\n

    //获取返回数据转换成NSData格式
    NSString *htmlString = [results valueForKey:@"datas"]; 
    NSData *htmlData=[htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *mstr = [[NSMutableString alloc] init];  
    NSRange substr;  
    //对\\n进行分隔获取列表数据
    NSArray *trainNumArray = [htmlString componentsSeparatedByString:@"\\n"]; 
    int trainNumCount = trainNumArray.count;
    
    self.xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData]; 
    NSArray *elements  = [self.xpathParser searchWithXPathQuery:@"//span"];  
    
    for (int i=0; i<trainNumCount; i++) {
        
        TicketModel *ticketModel = [[TicketModel alloc] init];
        
        //TFHpple 解析有规律的HTML数据,抓取span标签获取 车次
        TFHppleElement *element = [elements objectAtIndex:i]; 
        NSString *elementContent = [element text];
        ticketModel.trainCode = elementContent;
        
        //根据字符串的分隔 解析每一行的数据
        NSArray *trainNumChildArray = [[trainNumArray objectAtIndex:i] componentsSeparatedByString:@","];
        
        //解析发站和发站时间
        NSString *childTitle1 = [trainNumChildArray objectAtIndex:2];
        mstr = [NSMutableString stringWithString:childTitle1];  
        substr = [mstr rangeOfString:@"<img src='/otsquery/images/tips/first.gif'>"];  
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
        ticketModel.fromLocation = [[mstr componentsSeparatedByString:@"<br>"] objectAtIndex:0];
        ticketModel.fromTime = [[mstr componentsSeparatedByString:@"<br>"] objectAtIndex:1];
        
        //解析发站和发站时间
        NSString *childTitle2 = [trainNumChildArray objectAtIndex:3];
        mstr = [NSMutableString stringWithString:childTitle2];  
        substr = [mstr rangeOfString:@"<img src='/otsquery/images/tips/last.gif'>"];  
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
        

        
        ticketModel.toLocation = [[mstr componentsSeparatedByString:@"<br>"] objectAtIndex:0];
        ticketModel.toTime = [[mstr componentsSeparatedByString:@"<br>"] objectAtIndex:1];
        
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
        ticketModel.BOneSeat = [trainNumChildArray objectAtIndex:9];
        //软卧
        ticketModel.BOneSeat = [trainNumChildArray objectAtIndex:10];
        //硬卧
        ticketModel.BOneSeat = [trainNumChildArray objectAtIndex:11];
        //软座
        ticketModel.BOneSeat = [trainNumChildArray objectAtIndex:12];
        //硬座
        ticketModel.BOneSeat = [trainNumChildArray objectAtIndex:13];
        //无座
        ticketModel.BOneSeat = [trainNumChildArray objectAtIndex:14];
        //其它
        ticketModel.BOneSeat = [trainNumChildArray objectAtIndex:15];
        
        [self.trainNumberArray addObject:ticketModel];
        [ticketModel release];
        
        

        
    }
    
    QueryTicketResultViewController *queryTicketResultVC = [[QueryTicketResultViewController alloc] init];
    queryTicketResultVC.trainNumberArray = self.trainNumberArray;
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
	NSLog(@"%d",listView.tag);
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
	NSLog(@"listStationView %d",listView.tag);
	if (listView.tag<10000) {
		return;
	}
	NSLog(@"%d",listView.tag);
	int section=(listView.tag-10000)/100;
	int row=(listView.tag-10000)%100;
	
	
	if (section==0&&row==1) {
		beginStation=[stationInfo retain];
		NSLog(@"beginStation %@",beginStation.stationName);
		
	}else if (section==0&&row==2) {
		endStatation=[stationInfo retain];
		NSLog(@"endStatation %@",endStatation.stationName);
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
				
				NSDateFormatter *formater = [[NSDateFormatter alloc] init];
				formater.dateFormat = @"yyyy-MM-dd";
				queryDate=[formater stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
				[cellValue setText:queryDate];
				
				//[cellValue sizeToFit];
				[formater release];
				[cell.contentView addSubview:cellValue];
				[cellValue release];
				
				break;
			}
				
			case 1:
			{
				
				[cellTitle setText:@"起点站"];
				[cell.contentView addSubview:cellTitle];
				
				//[cellValue setText:@"北京"];
				[cell.contentView addSubview:cellValue];
				
				
				break;
			}
			case 2:
			{
				
				[cellTitle setText:@"终点站"];
				[cell.contentView addSubview:cellTitle];
				
				//[cellValue setText:@"上海"];
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
			NSLog(@"tag %d ",10000+indexPath.section*100+indexPath.row);
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
			
			
			
			NSMutableArray* stationResultArray=[self getStationArray];
			
			
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
			[(UILabel*)[cell.contentView viewWithTag:1001 ] setText:[date stringWithFormat:@"YYYY-MM-dd"]];
		} 
	}
}
-(void)pickerView:(PickerView*)picker didPickedWithValue:(NSObject*)value
{
	NSIndexPath* indexPath;
	
	if (picker.tag==101) {
		indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
		
		queryTimeString=[(NSString*)value retain];
		
		
		
		
	}else {
		indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
		
		
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
	[req setValidatesSecureCertificate:NO];
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
	
	NSLog(@"%@",str);
	
	[req setPostBody:[NSMutableData dataWithData:[str dataUsingEncoding:NSUTF8StringEncoding]]]; 
	
	[req startSynchronous];
	
	
	NSString* data=req.responseString;
	
	if (!data||[data length]==0) {
		return nil;
	}   
	return  [data JSONValue];
	
}
@end
