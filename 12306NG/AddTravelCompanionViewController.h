//
//  AddTravelCompanionViewController.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerView.h"
#import "NSDate-Helper.h"
@interface AddTravelCompanionViewController : UIViewController<UITextFieldDelegate>
{
    
    NSMutableArray* tableArray;
    NSMutableDictionary* dataDict;
    UITableView* mainTableView;
    
    BOOL isKeyBoardShow;
    
    NSInteger tagIndex;
    
    UITextField* activeField;
    
    UILabel* activeLabel;
    
    //zhaoqi
    BOOL isModelView;
}


@property (nonatomic, assign) BOOL isModelView;

@end
