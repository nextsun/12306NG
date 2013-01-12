//
//  LocalStatus.m
//  SHTowerPortal
//
//  Created by Lei Sun on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalClass.h"
#import "NSDate-Helper.h"
#import "JSON.h"
//#import "WBAuthorizeWebView.h"
#import "UIColor+Helper.h"

//新浪微博
#define kWBSDKDemoAppKey @"3040017714"
#define kWBSDKDemoAppSecret @"69efd3b1b561f649e37d2136c19bdc38"


#ifndef kWBSDKDemoAppKey
#error
#endif

#ifndef kWBSDKDemoAppSecret
#error
#endif

static GlobalClass* _localStatusInstance;

@implementation GlobalClass
@synthesize dataArray=_dataArray;
@synthesize lanchtimes=_lanchtimes;
@synthesize showHelp=_showHelp;
@synthesize showLoading=_showLoading;
@synthesize towerDataArray=_towerDataArray;
//@synthesize weiBoEngine=_weiBoEngine;
@synthesize isLoginIn=_isLoginIn;
@synthesize userName=_userName;
@synthesize themeColor=_themeColor;
@synthesize isEnableBaiduInput=_isEnableBaiduInput;;

+(GlobalClass*)sharedClass;
{
    if (!_localStatusInstance) {
        _localStatusInstance=[[GlobalClass alloc] init];
    }
    return _localStatusInstance;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        _localStatusInstance=self;
        [self initLanchTimes];
        _dataArray=[[NSMutableArray alloc] init];        
        _showLoading=YES;
        _showHelp=YES;
        _isLoginIn=NO;
        _userName=@"";
        _themeColor=[UIColor colorWithHexString:@"000000"];
        _isEnableBaiduInput=true;
        
        
 /*
        _weiBoEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
//        [_weiBoEngine setRootViewController:self];
//        [_weiBoEngine setDelegate:(id<WBEngineDelegate>)self];
        [_weiBoEngine setRedirectURI:@"http://"];
        [_weiBoEngine setIsUserExclusive:NO];

  */
    }
    return self;
}
-(void)reset
{
    _lanchtimes=1;
    //[self loadConfig];
    
}
-(void)loadConfig
{
  
    if (_lanchtimes>1) {
        _showHelp=[[NSUserDefaults standardUserDefaults] boolForKey:@"showHelp"];
        _showLoading=[[NSUserDefaults standardUserDefaults] boolForKey:@"showLoading"]; 
        _isEnableBaiduInput=[[NSUserDefaults standardUserDefaults] boolForKey:@"enableBaiduInput"];
        _themeColor=[UIColor colorWithHexString:[[NSUserDefaults standardUserDefaults] stringForKey:@"themeColor" ]];
        
        
    }else {
        [self SaveConfig];
    }
    
    
}


- (void)initLanchTimes
{
    
    _lanchtimes=1;
    id va=[[NSUserDefaults standardUserDefaults] valueForKey:@"lanchTimes"];
    if (va&&[va intValue]>=1) {
        _lanchtimes=[va intValue]+1; 
    }    
    [[NSUserDefaults standardUserDefaults] setInteger:_lanchtimes forKey:@"lanchTimes"];   
}


-(void)initDataArray
{
    
    NSDate* dateTmp=[NSDate dateWithTimeIntervalSinceNow:0];
    
    for (int i=0; i<30; i++) {
        
        int t=arc4random()%15+1;
        
        for (int j=0; j<t; j++) {
            
            //            [NSDate dateWithTimeIntervalSinceNow:0] 
            
           [_dataArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                             [NSString stringWithFormat:@"%d",i],@"id",
                                                             [[dateTmp dateAfterDay:i-15] stringWithFormat:@"YYYY-MM-dd"],@"time",
                                                             [NSString stringWithFormat:@"test%d.png",arc4random()%9],@"img",
                                                             nil]];
        }
        
    }
}
-(void)loadTowerData
{
    
   // NSDictionary *config=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TowerData" ofType:@"plist"]];
  //  _towerDataArray=[config objectForKey:@"TowerData"] ;
    
    
   
//
//    LogDebug(@"%@",[NSHomeDirectory() stringByAppendingString:@"/timeline.json"]);
//    
//    
//    LogDebug(@"%@",[config JSONRepresentation]);
//    
//   
    
    
    
 //  
    
}

-(void)SaveConfig
{
    [[NSUserDefaults standardUserDefaults] setBool:_showHelp forKey:@"showHelp"];
    [[NSUserDefaults standardUserDefaults] setBool:_showLoading forKey:@"showLoading"];
    [[NSUserDefaults standardUserDefaults] setObject:[UIColor colorToHexString:_themeColor] forKey:@"themeColor"];
    [[NSUserDefaults standardUserDefaults] setBool:_isEnableBaiduInput forKey:@"enableBaiduInput"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)SaveConfigWithKey:(NSString*)key andValue:(NSObject*)value
{    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)showHTMLDoc:(NSString*)htmlString
{
    
//    WBAuthorizeWebView* w=[[WBAuthorizeWebView alloc] init];
//    w loadRequestWithURL:<#(NSURL *)#>
//    
    
}
@end
