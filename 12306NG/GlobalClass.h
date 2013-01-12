//
//  LocalStatus.h
//  SHTowerPortal
//
//  Created by Lei Sun on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "WBEngine.h"

@interface GlobalClass : NSObject{
    NSMutableArray* dataArray;
    NSMutableArray* towerDataArray;
    NSInteger lanchtimes;
    BOOL showHelp;
    BOOL showLoading;
   // WBEngine* weiBoEngine;
    BOOL isLoginIn;
    NSString* userName;
    UIColor* themeColor;
    BOOL isEnableBaiduInput;
}
@property(nonatomic,strong)NSMutableArray* dataArray;
@property(nonatomic,strong)NSMutableArray* towerDataArray;
@property(nonatomic,assign)NSInteger lanchtimes;
@property(nonatomic,assign)BOOL showHelp;
@property(nonatomic,assign)BOOL showLoading;
//@property(nonatomic,retain)WBEngine* weiBoEngine;
@property(nonatomic,assign)BOOL isLoginIn;
@property(nonatomic,retain)NSString* userName;
@property(nonatomic,retain)UIColor* themeColor;
@property(nonatomic,assign)BOOL isEnableBaiduInput;

+(GlobalClass*)sharedClass;
+(void)showHTMLDoc:(NSString*)htmlString;
-(void)loadConfig;
-(void)initDataArray;
-(void)loadTowerData;
-(void)SaveConfig;
@end
