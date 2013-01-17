//
//  OrderModel.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface OrderModel : NSObject{
    
}

//init
- (id)init;

// init order model
+(id)sharedOrderModel;

// get the user unpaid order
-(NSMutableArray *)getUnpaidOrder;

// return unpaid order dict
-(NSMutableDictionary *)getUnPaidOrder:(NSArray*)array;

// get the user payment success order
-(NSMutableArray *)getPaymentSuccessOrder;

// cancel the chosen order
- (NSString *) cancelOrder:(NSDictionary *)dict;

// query the epay info
- (NSMutableDictionary *) queryEpayInfo:(NSDictionary *)dict;

@end
