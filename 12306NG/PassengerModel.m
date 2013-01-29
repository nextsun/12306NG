//
//  PassengerModel.m
//  12306NG
//
//  Created by Zhao Qi on 13-1-16.
//  Copyright (c) 2013年 12306NG. All rights reserved.
//

#import "PassengerModel.h"

@implementation PassengerModel

@synthesize first_letter;               //WS
@synthesize isUserSelf;                 //: "",
@synthesize mobile_no;                  //: "13511038980",
@synthesize old_passenger_id_no;        //: "",
@synthesize old_passenger_id_type_code; //: "",
@synthesize old_passenger_name;         //: "",
@synthesize passenger_flag;             //: "0",
@synthesize passenger_id_no;            //: "370728197612150211",
@synthesize passenger_id_type_code;     //: "1",
@synthesize passenger_id_type_name;     //: "",
@synthesize passenger_name;             //: "武松",
@synthesize passenger_type;             //: "1",
@synthesize passenger_type_name;        //: "",
@synthesize selectedFlag;
@synthesize seatType;
@synthesize ticketType;


- (id) init
{
    self = [super init];
    if ( self ) {
        self.selectedFlag = NO;
        self.seatType = @"1";   //硬座
        self.ticketType = @"1"; //成人票
    }
    return self;
}


- (void) dealloc
{
    [first_letter release];
    [isUserSelf release];
    [mobile_no release];
    [old_passenger_id_no release];
    [old_passenger_id_type_code release];
    [old_passenger_name release];
    [passenger_flag release];
    [passenger_id_no release];
    [passenger_id_type_code release];
    [passenger_id_type_name release];
    [passenger_name release];
    [passenger_type release];
    [passenger_type_name release];
    [seatType release];
    [ticketType release];
    [super dealloc];
}


- (NSString *)description
{
    NSString* s = [NSString stringWithFormat:@"card=%@, cardType=%@, name=%@, seatType=%@, ticketType=%@, selected=%d",
                   passenger_id_no, passenger_id_type_code, passenger_name, seatType, ticketType, selectedFlag];
    return s;
}

@end
