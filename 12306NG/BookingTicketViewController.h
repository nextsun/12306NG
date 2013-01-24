//
//  BookingTicketViewController.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ChooseTravelCompanionViewController.h"

@interface BookingTicketViewController : UITableViewController<UITextFieldDelegate,ChooseTravelCompanionDelegate>
{
    NSMutableArray* tableArray;
    //UITableView* mainTableView;
    NSMutableDictionary* dataDict;
    
    BOOL isKeyBoardShow;
    
     
    //NSMutableArray* userListArray;
    //UITableView* userListTableView;
    BOOL isUserListTableLoaded;
    
    NSString* orderString;
    
    NSString* tokenString;
    NSString* leftTicketsString;
    
    UITextField* textCode;
    
    UIButton* imgBtn;

    ASIHTTPRequest* requestImg;
    
    NSMutableArray* seatArray;
    
    NSMutableArray* passagesArray;
    
    NSMutableArray* passagesIsOpenArray;
    
    BOOL isInit;
    
    



}
@property(nonatomic,retain)NSString* orderString;

@end
