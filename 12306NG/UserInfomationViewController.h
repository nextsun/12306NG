//
//  UserInfomationViewController.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+backButtonAction.h"
#import "PickerView.h"
#import "DDHelper.h"
#import "DatePickerView.h"
#import "NSDate-Helper.h"


typedef enum
{
    UserInfoMe,
    UserInfoOther
}UserInfoKey;


@interface UserInfomationViewController : UIViewController<UITextFieldDelegate>
{
    UserInfoKey userInfoKey;
    
    UIScrollView* mainScrollView;
    
    NSMutableArray* tableArray;
    UITableView* mainTableView;
    BOOL isMainTableLoaded;
    
    
    NSMutableArray* userListArray;
    UITableView* userListTableView;
    BOOL isUserListTableLoaded;
    
    NSMutableDictionary* dataDict;
    NSMutableDictionary* dataDictOrigin;
    
    UISegmentedControl* segControlTop;
    
    
    BOOL isKeyBoardShow;
    
    UIView* loadingView;
    
    UITextField* activeField;
    
    BOOL isNeedsToReLoadWhileViewWillAppear;
    
    UILabel* activeLabel;

}
-(id)initWithUserInfoKey:(UserInfoKey)userInfoKey;
@property(nonatomic,assign)UserInfoKey userInfoKey;
@property(nonatomic,assign)BOOL isNeedsToReLoadWhileViewWillAppear;
@end
