//
//  TicketModel.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketModel : NSObject


@property(nonatomic, retain)NSString *number; //ID
@property(nonatomic, retain)NSString *trainCode;  //车次
@property(nonatomic, retain)NSString *fromLocation;//发站
@property(nonatomic, retain)NSString *toLocation; //到站
@property(nonatomic, retain)NSString *fromTime; //发站时间
@property(nonatomic, retain)NSString *toTime;//到站时间
@property(nonatomic, retain)NSString *duration; //历时

@property(nonatomic, retain)NSString *hardSeat; //硬座
@property(nonatomic, retain)NSString *softSeat; //软座
@property(nonatomic, retain)NSString *hardBed; //硬卧
@property(nonatomic, retain)NSString *softBed; //软卧
@property(nonatomic, retain)NSString *noSeat; //无座
@property(nonatomic, retain)NSString *otherSeat; //其他
@property(nonatomic, retain)NSString *advancedSoftBed; //高级软卧

@property(nonatomic, retain)NSString *businessSeat; //商务座
@property(nonatomic, retain)NSString *specialSeat; //特等座

@property(nonatomic, retain)NSString *AOneSeat; //一等座
@property(nonatomic, retain)NSString *BOneSeat; //二等座


@property(nonatomic, assign)int isFrom; //是否是起点
@property(nonatomic, assign)int isTO; //是否是终点

@property(nonatomic, retain)NSString* orderString; //
@property(nonatomic, retain)NSString* beginSalesString; //


@end
