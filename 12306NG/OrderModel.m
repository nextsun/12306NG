//
//  OrderModel.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "OrderModel.h"
#import "HTMLParser.h"
#import "ASIDownloadCache.h"
#import "NSString+SBJSON.h"

@implementation OrderModel

static OrderModel* _sharedOrderModelIntance;

//init
- (id)init{
    self = [super init];
    if (self) {
        _sharedOrderModelIntance=self;
        
    }
    return self;
}

// init order model
+(id)sharedOrderModel{
    if (_sharedOrderModelIntance==nil) {
        _sharedOrderModelIntance=[[OrderModel alloc] init];
    }
    return _sharedOrderModelIntance;
}

// get the user unpaid order
-(NSMutableArray*)getUnpaidOrder{
    ASIHTTPRequest* request= [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order/myOrderAction.do?method=queryMyOrderNotComplete&leftmenu=Y"]];
    
    [request setCachePolicy:ASIUseDefaultCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    
    [request setValidatesSecureCertificate:NO];
    [request addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,*/*"];
    [request addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/sysuser/editMemberAction.do?method=initEdit"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    [request addRequestHeader:@"Connection" value:@" Keep-Alive"];
    
    
    [request startSynchronous];
    
    NSString* responseString=request.responseString;
    
    NSString *payBox = [[[NSString alloc] init] autorelease];
    NSString *token  = [[[NSString alloc] init] autorelease];
    
    if ([responseString rangeOfString:@"checkbox_pay_"].location != NSNotFound) {
        NSRange range = [responseString rangeOfString:@"checkbox_pay_"];
        
        NSRange tmpRange = NSMakeRange(range.location + 13, 10);
        
        payBox = [responseString substringWithRange:tmpRange];
    }
    
    NSMutableString *baseStr = [[NSMutableString alloc] initWithString:@"<input type=[\"]hidden[\"] id=[\"]checkbox_pay[\"] name=[\"]checkbox_pay_"];
    [baseStr appendString:payBox];
    [baseStr appendString:@"[\"] value=[\"](.*)[\"] />"];
    
    NSString *checkbox = [[[NSString alloc] init] autorelease];
    NSRegularExpression* regexCheck=[[NSRegularExpression alloc] initWithPattern:baseStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult* rCheck=  [regexCheck firstMatchInString:responseString options:0 range:(NSRange){0,responseString.length}];
    [regexCheck release];
    if (rCheck.range.length>0) {
        int pos=77;
        checkbox=[responseString substringWithRange:(NSRange){rCheck.range.location+pos,rCheck.range.length-pos-4}];
    }
    
    NSRegularExpression* regexAlert=[[NSRegularExpression alloc] initWithPattern:@"<input type=[\"]hidden[\"] name=[\"]org.apache.struts.taglib.html.TOKEN[\"] value=[\"](.*)[\"]>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult* rAlert=  [regexAlert firstMatchInString:responseString options:0 range:(NSRange){0,responseString.length}];
    [regexAlert release];
    if (rAlert.range.length>0) {
        
        int pos=70+1;
        token=[responseString substringWithRange:(NSRange){rAlert.range.location+pos,rAlert.range.length-pos-2}];
    }
    
    NSMutableDictionary *postDict = [[[NSMutableDictionary alloc] init] autorelease];
    [postDict setObject:payBox   forKey:@"sequence_no"];
    [postDict setObject:checkbox forKey:@"ticket_key"];
    [postDict setObject:token    forKey:@"org.apache.struts.taglib.html.TOKEN"];
    
    NSString* leftString=@"<!--right  -->";
    NSString* rightString=@"<!--right end-->";

    responseString=[[responseString componentsSeparatedByString:rightString] objectAtIndex:0];
    NSArray* tmpArray=[responseString componentsSeparatedByString:leftString];
    responseString=[tmpArray objectAtIndex:0];
    
    responseString=[responseString stringByReplacingOccurrencesOfString:@"</th>" withString:@""];
    NSString* html=[NSString stringWithFormat:@"<html><body>%@</body></html>",responseString];
    
    HTMLParser* parse=[[HTMLParser alloc] initWithString:html  error:nil];
    HTMLNode* body=parse.body;
    
    //order array 
    HTMLNode* nodeTD=[body findChildOfClass:@"table_clist"];
    NSArray* trArray=[nodeTD findChildTags:@"tr"];
    NSMutableArray *myMutableArray = [NSMutableArray arrayWithArray:trArray];
    
    NSMutableArray* orderArray=[NSMutableArray arrayWithArray:nil];
    
    if ([myMutableArray count] == 0) {
        //do nothing
        NSString *str   =[NSString stringWithFormat:@"没有未完成订单"];
        NSString *value = @"NO";
        [orderArray insertObject:value atIndex:0];
        [orderArray insertObject:str   atIndex:1];
    }else{
        [myMutableArray removeObjectAtIndex:0];
        [myMutableArray removeObjectAtIndex:([myMutableArray count] - 1)];
        
        NSString *value = @"YES";
        [orderArray insertObject:value    atIndex:0];
        [orderArray insertObject:postDict atIndex:1];
        
        for (HTMLNode* nodeTable in myMutableArray){
            NSString *tmpStr = [nodeTable allContents];
            tmpStr = [tmpStr stringByReplacingOccurrencesOfString: @"\r" withString:@""];
            tmpStr = [tmpStr stringByReplacingOccurrencesOfString: @"\n" withString:@""];
            
            NSArray* tmpArray=[tmpStr componentsSeparatedByString:@" "];
            NSMutableArray *tmpArray1 = [NSMutableArray arrayWithArray:tmpArray];
            [tmpArray1 removeObject:@""];
            
            tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@" " withString:@"#"];
            
            NSString *tmpSt2 = [tmpArray1 componentsJoinedByString:@"#"];
            
            NSArray* order=[tmpSt2 componentsSeparatedByString:@"#"];
            
            NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
            
            dict = [self getUnPaidOrder:order];
            
            [orderArray insertObject:dict atIndex:([myMutableArray indexOfObject:nodeTable]+2)];
        }
    }
    
    
     return orderArray;
}

// return unpaid order dict
-(NSMutableDictionary*)getUnPaidOrder:(NSArray*)array{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dict setObject:[array objectAtIndex:1]     forKey:@"train"];
    [dict setObject:[array objectAtIndex:2]     forKey:@"station"];
    [dict setObject:[array objectAtIndex:0]     forKey:@"date"];
    [dict setObject:[array objectAtIndex:3]     forKey:@"time"];
    [dict setObject:[array objectAtIndex:9]     forKey:@"passenger"];
    [dict setObject:[array objectAtIndex:7]     forKey:@"type"];
    [dict setObject:[array objectAtIndex:6]     forKey:@"seat"];
    [dict setObject:[array objectAtIndex:4]     forKey:@"car"];
    [dict setObject:[array objectAtIndex:5]     forKey:@"number"];
    [dict setObject:[array objectAtIndex:8]     forKey:@"money"];
    [dict setObject:[array objectAtIndex:10]    forKey:@"info" ];
    [dict setObject:[array objectAtIndex:11]    forKey:@"status"];
    
    return dict;
}

// get the user payment success order
-(NSMutableArray*)getPaymentSuccessOrder{
    ASIHTTPRequest* request= [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order/myOrderAction.do?method=queryMyOrder"]];
    
    [request setCachePolicy:ASIUseDefaultCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    
    [request setValidatesSecureCertificate:NO];
  
    [request addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,*/*"];
    [request addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/order/myOrderAction.do?method=init&showMessage=Y"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    [request addRequestHeader:@"Connection" value:@" Keep-Alive"];
    
    NSString* strF= @"https://dynamic.12306.cn/otsweb/order/myOrderAction.do?method=queryMyOrder&leftmenu=%@&org.apache.struts.taglib.html.TOKEN=%@&queryDataFlag=%@&queryOrderDTO.from_order_date=%@&queryOrderDTO.location_code=%@&queryOrderDTO.name=&queryOrderDTO.sequence_no=&queryOrderDTO.to_order_date=%@&queryOrderDTO.train_code=";
    
    NSString* urlStr=[NSString stringWithFormat:strF,
                      @"Y",
                      @"29af9f81da4d0fc56fb2d3c0f7dde402",
                      @"1",
                      @"2013-01-01",
                      @"_1",
                      @"2013-12-30"];
    
    
    [request setPostBody:[NSMutableData dataWithData:[urlStr dataUsingEncoding:NSUTF8StringEncoding]]];
    
    
    [request startSynchronous];
    
    NSString* responseString=request.responseString;
    
    NSString* leftString=@"<!--right  -->";
    NSString* rightString=@"<!--right end-->";
    
    responseString=[[responseString componentsSeparatedByString:rightString] objectAtIndex:0];
    NSArray* tmpArray=[responseString componentsSeparatedByString:leftString];
    responseString=[tmpArray objectAtIndex:0];
    
    responseString=[responseString stringByReplacingOccurrencesOfString:@"</th>" withString:@""];
    NSString* html=[NSString stringWithFormat:@"<html><body>%@</body></html>",responseString];
    
    HTMLParser* parse=[[HTMLParser alloc] initWithString:html  error:nil];
    HTMLNode* body=parse.body;
    
    //order array
    NSArray *sucArray =[body findChildrenOfClass:@"table_clist"];
    NSMutableArray* orderArray=[NSMutableArray arrayWithArray:nil];
    for (HTMLNode* nodeTD in sucArray) {
        NSArray* trArray=[nodeTD findChildTags:@"tr"];
        NSMutableArray *myMutableArray = [NSMutableArray arrayWithArray:trArray];
        
        if ([myMutableArray count] == 0) {
            //do nothing
            NSString *str   =[NSString stringWithFormat:@"没有已完成订单"];
            [orderArray insertObject:str   atIndex:0];
        }else{
            [myMutableArray removeObjectAtIndex:0];
            [myMutableArray removeObjectAtIndex:([myMutableArray count] - 1)];
            
            for (HTMLNode* nodeTable in myMutableArray){
                NSString *tmpStr = [nodeTable allContents];
                
                tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\t" withString:@"#"];
                tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"," withString:@"#"];
                
                tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                NSArray* tmpArray=[tmpStr componentsSeparatedByString:@"#"];
                NSMutableArray *tmpArray1 = [NSMutableArray arrayWithArray:tmpArray];
                [tmpArray1 removeObject:@""];
                NSString *tmpSt2 = [tmpArray1 componentsJoinedByString:@"#"];
                
                NSArray* order=[tmpSt2 componentsSeparatedByString:@"#"];
                
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                
                dict = [self getSuccessOrder:order];
                
                [orderArray insertObject:dict atIndex:[sucArray indexOfObject:nodeTD]];
            }
        }
    }
    
    return orderArray;
}

// return success order dict
-(NSMutableDictionary*)getSuccessOrder:(NSArray*)array{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dict setObject:[array objectAtIndex:0]     forKey:@"date"];
    [dict setObject:[array objectAtIndex:1]     forKey:@"train"];
    [dict setObject:[array objectAtIndex:2]     forKey:@"station"];
    [dict setObject:[array objectAtIndex:3]     forKey:@"time"];
    [dict setObject:[array objectAtIndex:5]     forKey:@"car"];
    [dict setObject:[array objectAtIndex:6]     forKey:@"number"];
    [dict setObject:[array objectAtIndex:4]     forKey:@"seat"];
    [dict setObject:[array objectAtIndex:7]     forKey:@"money"];
    [dict setObject:[array objectAtIndex:8]     forKey:@"passenger"];
    [dict setObject:[array objectAtIndex:9]     forKey:@"type"];
    [dict setObject:[array objectAtIndex:10]    forKey:@"info" ];
    //[dict setObject:[array objectAtIndex:11]    forKey:@"status"];
    
    return dict;
}

// cancel the chosen order
- (NSString *) cancelOrder:(NSDictionary *)dict{
    NSMutableString *str = [NSMutableString stringWithFormat:@"https://dynamic.12306.cn/otsweb/order/confirmPassengerAction.do?method=payOrder&orderSequence_no="];
    
    [str appendString:[dict objectForKey:@"sequence_no"]];
    
    
    ASIFormDataRequest* request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order/orderAction.do?method=cancelMyOrderNotComplete"]];
    //    ASIFormDataRequest* request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/order/payConfirmOnlineSingleAction.do?method=cancelOrder"]];
    
    [request setCachePolicy:ASIUseDefaultCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setValidatesSecureCertificate:NO];
    
    [request addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,*/*"];
    [request addRequestHeader:@"Referer" value:str];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    [request addRequestHeader:@"Connection" value:@" Keep-Alive"];
    
    NSString* strF= @"https://dynamic.12306.cn/otsweb/order/orderAction.do?method=cancelMyOrderNotComplete&orderRequest.tour_flag=&org.apache.struts.taglib.html.TOKEN=%@&sequence_no=%@";
    
    NSString* urlStr=[NSString stringWithFormat:strF,
                      [dict objectForKey:@"org.apache.struts.taglib.html.TOKEN"],
                      [dict objectForKey:@"sequence_no"]];
    
    //    NSString* strF= @"https://dynamic.12306.cn/otsweb/order/payConfirmOnlineSingleAction.do?method=cancelOrder&batch_no=%@&orderRequest.bed_level_order_num=%@&orderRequest.cancel_flag=%@&orderRequest.end_time=&orderRequest.from_station_name=&orderRequest.from_station_telecode=&orderRequest.id_mode=&orderRequest.seat_type_code=&orderRequest.start_time=&orderRequest.station_train_code=&orderRequest.ticket_type_order_num=&orderRequest.to_station_name=&orderRequest.to_station_telecode=&orderRequest.train_date=&orderRequest.train_no=&org.apache.struts.taglib.html.TOKEN=%@&sequence_no=%@";
    //
    //    NSString* urlStr=[NSString stringWithFormat:strF,
    //                      @"1",
    //                      @"000000000000000000000000000000",
    //                      @"2",
    //                      [dict objectForKey:@"org.apache.struts.taglib.html.TOKEN"],
    //                      [dict objectForKey:@"sequence_no"]];
    
    
    [request setPostBody:[NSMutableData dataWithData:[urlStr dataUsingEncoding:NSUTF8StringEncoding]]];
    
    [request startSynchronous];
    
    NSString* responseString=request.responseString;
    
    NSRegularExpression* regexAlert=[[NSRegularExpression alloc] initWithPattern:@"var message = [\"](.*)[\"]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    NSTextCheckingResult* rAlert=  [regexAlert firstMatchInString:responseString options:0 range:(NSRange){0,responseString.length}];
    [regexAlert release];
    
    if (rAlert.range.length>0) {
        
        NSString* msg=[responseString substringWithRange:(NSRange){rAlert.range.location+15,rAlert.range.length-15-1}];
        
        if (![msg isEqualToString:@""]) {
            
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
        return msg;
    }
    
return nil;
}

- (NSMutableDictionary *) queryEpayInfo:(NSDictionary *)dict{
    NSString *url = [NSString stringWithFormat:@"https://dynamic.12306.cn/otsweb/order/myOrderAction.do?method=laterEpay&orderSequence_no=Aion&con_pay_type=epay"];
    url = [url stringByReplacingOccurrencesOfString:@"Aion" withString:[dict objectForKey:@"sequence_no"]];
    
    ASIFormDataRequest* request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setCachePolicy:ASIUseDefaultCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setValidatesSecureCertificate:NO];
    
    [request addRequestHeader:@"Host" value:@"dynamic.12306.cn"];
    [request addRequestHeader:@"Accept" value:@"text/html,application/xhtml+xml,*/*"];
    [request addRequestHeader:@"Referer" value:@"https://dynamic.12306.cn/otsweb/order/myOrderAction.do?method=queryMyOrderNotComplete&leftmenu=Y"];
    [request addRequestHeader:@"Accept-Language" value:@"zh-CN"];
    [request addRequestHeader:@"User-Agent" value:@" Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [request addRequestHeader:@"Accept-Encoding" value:@" gzip, deflate"];
    [request addRequestHeader:@"Connection" value:@" Keep-Alive"];
    
    NSString* strF= @"https://dynamic.12306.cn/otsweb/order/myOrderAction.do?method=laterEpay&orderSequence_no=%@&con_pay_type=epay&org.apache.struts.taglib.html.TOKEN=%@&queryOrderDTO.from_order_date=&queryOrderDTO.to_order_date=&ticket_key=%@%3A";
    
    NSString* urlStr=[NSString stringWithFormat:strF,
                      [dict objectForKey:@"sequence_no"],
                      [dict objectForKey:@"org.apache.struts.taglib.html.TOKEN"],
                      [dict objectForKey:@"ticket_key"]];
    
    [request setPostBody:[NSMutableData dataWithData:[urlStr dataUsingEncoding:NSUTF8StringEncoding]]];
    
    [request startSynchronous];
    
    NSString* responseString=request.responseString;
    
    NSLog(@"response is ==%@",responseString);
    
    NSString *merSignMsg = [[[NSString alloc] initWithString:@""] autorelease];
    NSString *tranData   = [[[NSString alloc] init] autorelease];
    NSString *message    = [[[NSString alloc] init] autorelease];
    NSMutableDictionary *epayDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    
    NSRegularExpression* regexAlert=[[NSRegularExpression alloc] initWithPattern:@"var message = [\"](.*)[\"]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    NSTextCheckingResult* rAlert=  [regexAlert firstMatchInString:responseString options:0 range:(NSRange){0,responseString.length}];
    [regexAlert release];
    
    if (rAlert.range.length>0) {
        
        message=[responseString substringWithRange:(NSRange){rAlert.range.location+15,rAlert.range.length-15-1}];
        [epayDict setObject:message forKey:@"message"];
        
        if (![message isEqualToString:@""]) {
            
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            return epayDict;
            
        }
    }
    
    NSRegularExpression* regexMer=[[NSRegularExpression alloc] initWithPattern:@"name=[\"]merSignMsg[\"] value=[\"](.*[\r\n]*.*.*[\r\n]*.*)[\"]>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSLog(@"regexMer is ==%@",regexMer);
    
    NSTextCheckingResult* rMer=  [regexMer firstMatchInString:responseString options:0 range:(NSRange){0,responseString.length}];
    NSLog(@"rMer is ==%@",rMer);
    [regexMer release];
    if (rMer.range.length>0) {
        
        int pos=70+1;
        merSignMsg=[responseString substringWithRange:(NSRange){rMer.range.location+pos,rMer.range.length-pos-2}];
    }
    
    NSRegularExpression* regexData=[[NSRegularExpression alloc] initWithPattern:@"name=[\"]tranData[\"] value=[\"](.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*.*[\r\n]*.*)[\"]>" options:NSRegularExpressionCaseInsensitive error:nil];
     NSLog(@"regexData is ==%@",regexData);
    
    NSTextCheckingResult* rData=  [regexData firstMatchInString:responseString options:0 range:(NSRange){0,responseString.length}];
     NSLog(@"rData is ==%@",rData);
    [regexData release];
    if (rData.range.length>0) {
        
        int pos=70+1;
        tranData=[responseString substringWithRange:(NSRange){rData.range.location+pos,rData.range.length-pos-2}];
    }
    
    [epayDict setObject:message    forKey:@"message"];
    [epayDict setObject:merSignMsg forKey:@"merSignMsg"];
    [epayDict setObject:tranData   forKey:@"tranData"];
    
    return  epayDict;
}

-(NSString*)ignorePluraldata:(NSString*)aStr
{
    const char* data=[aStr UTF8String];
    int totalLen=strlen(data);
    char* result=(char *)malloc(totalLen*sizeof(char)+1);
    int index=0;
    while (index<totalLen) {
        int resultLen=strlen(result);
        if (index==0) {
            result[0]=data[index];
            result[resultLen+1]='\0';
        }else
        {
            if ((data[index]!='#')||('#'!=result[resultLen-1])) {
                result[resultLen]=data[index];
                result[resultLen+1]='\0';
            }
        }
        
        
        
        index++;
    }
    NSString* str=[[[NSString alloc] initWithBytes:result length:strlen(result) encoding:NSUTF8StringEncoding] autorelease];
    free(result);
    return str;
}

-(NSString*)ignorePluralData:(NSString*)aStr
{
    const char* data=[aStr UTF8String];
   
    int totalLen=strlen(data);
    char* result=(char *)malloc(totalLen*sizeof(char)+1);
    int index=0;
    while (index<totalLen) {
        int resultLen=strlen(result);
        if (index==0) {
            result[0]=data[index];
            result[resultLen+1]='\0';
        }else
        {
            if (data[index]!=result[resultLen-1]) {
                result[resultLen]=data[index];
                result[resultLen+1]='\0';
            }
        }
        
        index++;
    }
    NSString* str=[[[NSString alloc] initWithBytes:result length:strlen(result) encoding:NSUTF8StringEncoding] autorelease];
    free(result);
    
    return str;
}
@end
