
//
//  QueryTicketResultViewController.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"

@interface QueryTicketResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    	UITableView* mainTableView;
        UIView* sortView;
    NSString* trainNo;
    NSString* startTimeStr;
    NSMutableArray* selectedKeys;
     NSMutableArray* trainNumberArrayAll;
    
    NGCustomButton* titleButton;
}

@property(nonatomic,retain)NSString* trainNo;
@property(nonatomic,retain)NSString* startTimeStr;
//
@property(nonatomic,retain)NSMutableArray* trainNumberArrayAll;
@property(nonatomic,retain)TFHpple *xpathParser;

@end
