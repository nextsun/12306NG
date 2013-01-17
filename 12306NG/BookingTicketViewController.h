//
//  BookingTicketViewController.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingTicketViewController : UITableViewController
{
    NSMutableArray* tableArray;
    //UITableView* mainTableView;
    NSMutableDictionary* dataDict;
    
    BOOL isKeyBoardShow;
    
     
    NSMutableArray* userListArray;
    //UITableView* userListTableView;
    BOOL isUserListTableLoaded;
    
    NSString* orderString;


}
@property(nonatomic,retain)NSString* orderString;
@end
