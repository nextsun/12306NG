//
//  CookieHelper.m
//  TicketsHunter
//
//  Created by Lei Sun on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CookiesHelper.h"
#import "ASIHTTPRequest.h"

#define URLString @"http://dynamic.12306.cn/TrainQuery/leftTicketByStation.jsp"

#define URLString2 @"https://dynamic.12306.cn/otsweb/main.jsp"


static CookiesHelper*  _cookiesHelper;

@implementation CookiesHelper
@synthesize cookies;
@synthesize ictHiddenName,ictHiddenValue;
+(id)sharedCookiesHelper
{
    if (_cookiesHelper==nil) {
        _cookiesHelper=[[CookiesHelper alloc] init];
    }
    return _cookiesHelper;
}
- (id)init
{
    self = [super init];
    if (self) {
        _cookiesHelper=self;        
        ASIHTTPRequest* q=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
        [q startSynchronous];
        if(q.error.code==0)
        {
            
            
            
            
            
            cookies=[q.responseCookies retain]; ;        
            NSString* ResponeString=q.responseString;
            
            
            NSRegularExpression* regex=[[NSRegularExpression alloc] initWithPattern:@"<input type=\"hidden\" id=\"ict(.*)\" name=\"ict(.*)\" value=\"(.*)\"\\/>" options:NSRegularExpressionCaseInsensitive error:nil];
            
            NSArray* arr=  [regex matchesInString:ResponeString options:0 range:(NSRange){0,ResponeString.length}];
            [regex release];
            if ([arr count]>0) {
                
                NSTextCheckingResult* r=[arr objectAtIndex:0];
                
                NSString* tmpStr=[ResponeString substringWithRange:r.range];
                self.ictHiddenName=[tmpStr substringWithRange:(NSRange){25,4}];
                self.ictHiddenValue=[tmpStr substringWithRange:(NSRange){50,r.range.length-7-50+4}];
                
                LogDebug(@"%@",self.cookies);
                LogDebug(@"%@",self.ictHiddenName);
                LogDebug(@"%@",self.ictHiddenValue);
                
                
            }
        }
        [q release];
        
    }
    return self;
}
- (void)dealloc
{
    //[self.cookies release];
    self.cookies=nil;
    [super dealloc];
}

-(void)setCookies:(NSArray *)cookies_
{
    
    NSMutableArray* tmpCookieArray=[NSMutableArray arrayWithArray:cookies];    
    for (NSHTTPCookie* c in cookies_ ) {
        BOOL has=NO;
        for (int i=0;i<[tmpCookieArray count];i++) {
            if ([c.name isEqualToString:((NSHTTPCookie*)[tmpCookieArray objectAtIndex:i]).name]) {
                has=YES;
                [tmpCookieArray replaceObjectAtIndex:i withObject:c];
                
            }
        }
        if (!has) {
            [tmpCookieArray addObject:c];
        }
        
    }
    [cookies release];
    cookies=[tmpCookieArray retain];
}
-(void)clearCookies
{
    cookies=[NSArray arrayWithObject:nil];    
}
@end
