//
//  RegisterViewController.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+backButtonAction.h"
#import "NGCustomButton.h"

#import "PickerView.h"
#import "DatePickerView.h"
#import "DDHelper.h"
#import "NSDate-Helper.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{
    
    NSMutableArray* tableArray;
    NSMutableDictionary* dataDict;
    UITableView* mainTableView;
    
    BOOL isKeyBoardShow;
    
    NSInteger tagIndex;
    
    UITextField* activeField;
    UILabel* activeLabel;
    
}

@end
