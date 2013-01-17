//
//  OrderListViewController.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "MBProgressHUD.h"
#import "PaymentViewController.h"
#import "PaymentDoneViewController.h"

@interface OrderListViewController : UIViewController{
    BOOL           UNPAID;
    BOOL           PAID;
    float          totalMoney;
    UITableView    *orderTableView;
    UIButton       *paymentBtn;
    UIButton       *cancelBtn;
    NSDictionary   *postOrder;
    NSMutableArray *orderArray;
    NSMutableArray *successArray;
    NSMutableArray *orderSections;
}

@property (nonatomic ,retain) UITableView    *orderTableView;
@property (nonatomic ,retain) NSDictionary   *postOrder;
@property (nonatomic ,retain) NSMutableArray *orderArray;
@property (nonatomic ,retain) NSMutableArray *successArray;
@property (nonatomic ,retain) NSMutableArray *orderSections;

// init data info
- (void) initData;

// pressed the payment button
- (void) paymentPressed:(id)sender;

// pressed the cancel button
- (void) cancelPressed:(id)sender;

@end
