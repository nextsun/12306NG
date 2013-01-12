//
//  QueryTicketViewController.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "PickerView.h"
#import "StationListWithCodeController.h"
#import "TFHpple.h" 
#import <libxml/xpathInternals.h>   
@interface QueryTicketViewController : UIViewController<PickerViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
	UITableView* mainTableView;
	
	//UITextField* text;
	//UIButton* imgBtn;
	ASIHTTPRequest* requestImg;
	MBProgressHUD* HUD;
	//TFHpple *xpathParser;
	
	NSString* queryDate;
	NSString* queryTimeString;
	StationInfo* beginStation;
	StationInfo* endStatation;
	
	
}

@property(nonatomic,retain)NSMutableArray* trainNumberArray;
@property(nonatomic,retain)MBProgressHUD* HUD;
@property(nonatomic,retain)TFHpple *xpathParser;

@end
