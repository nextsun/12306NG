//
//  PaymentViewController.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface PaymentViewController : UIViewController{
    NSDictionary *paymentDict;
    NSDictionary *epayDict;
    NSArray      *paymentArray;
    UITableView  *paymentTable;
}

@property(nonatomic, retain) NSDictionary *paymentDict;
@property(nonatomic, retain) NSDictionary *epayDict;
@property(nonatomic, retain) NSArray      *paymentArray;
@property(nonatomic, retain) UITableView  *paymentTable;

//init data
- (void) initData;

@end
