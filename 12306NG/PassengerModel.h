//
//  PassengerModel.h
//  12306NG
//
//  Created by Zhao Qi on 13-1-16.
//  Copyright (c) 2013年 12306NG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassengerModel : NSObject
{
    NSString* first_letter;               //WS
    NSString* isUserSelf;                 //: "",
    NSString* mobile_no;                  //: "13511038980",
    NSString* old_passenger_id_no;        //: "",
    NSString* old_passenger_id_type_code; //: "",
    NSString* old_passenger_name;         //: "",
    NSString* passenger_flag;             //: "0",
    NSString* passenger_id_no;            //: "370728197612150211", 身份证号
    NSString* passenger_id_type_code;     //: "1",证件类型
    NSString* passenger_id_type_name;     //: "",证件号码
    NSString* passenger_name;             //: "武松",姓名
    NSString* passenger_type;             //: "1",
    NSString* passenger_type_name;        //: "",
    
    BOOL selectedFlag;
    NSString* seatType;                   //席别
    NSString* ticketType;                 //票种
}


@property (nonatomic, retain) NSString* first_letter;               //WS
@property (nonatomic, retain) NSString* isUserSelf;                 //: "",
@property (nonatomic, retain) NSString* mobile_no;                  //: "13511038980",
@property (nonatomic, retain) NSString* old_passenger_id_no;        //: "",
@property (nonatomic, retain) NSString* old_passenger_id_type_code; //: "",
@property (nonatomic, retain) NSString* old_passenger_name;         //: "",
@property (nonatomic, retain) NSString* passenger_flag;             //: "0",
@property (nonatomic, retain) NSString* passenger_id_no;            //: "370728197612150211",
@property (nonatomic, retain) NSString* passenger_id_type_code;     //: "1",
@property (nonatomic, retain) NSString* passenger_id_type_name;     //: "",
@property (nonatomic, retain) NSString* passenger_name;             //: "武松",
@property (nonatomic, retain) NSString* passenger_type;             //: "1",
@property (nonatomic, retain) NSString* passenger_type_name;        //: "",
@property (nonatomic, assign) BOOL selectedFlag;
@property (nonatomic, retain) NSString* seatType;                   //席别
@property (nonatomic, retain) NSString* ticketType;                 //票种

@end
