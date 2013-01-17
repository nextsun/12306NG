//
//  PaymentDoneViewController.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentDoneViewController : UIViewController{
    NSDictionary *orderDict;
    UITableView  *successTable;
}

@property (nonatomic ,retain) NSDictionary *orderDict;
@property (nonatomic ,retain) UITableView  *successTable;

// init data
- (void)initData;

@end
