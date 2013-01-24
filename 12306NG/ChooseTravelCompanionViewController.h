//
//  ChooseTravelCompanionViewController.h
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassengerModel.h"
#import "PickerView.h"

@class ChooseTravelCompanionViewController;
@protocol ChooseTravelCompanionDelegate
-(void)chooseTravelViewController:(ChooseTravelCompanionViewController*)picker didChosenWithArray:(NSArray*)arr;
//-(void)datePickerViewCancle:(ChooseTravelCompanionViewController*)picker;
@end


@interface ChooseTravelCompanionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PickerViewDelegate, UITextFieldDelegate>
{
    NSMutableArray* passengers;
    NSArray* selectedPassengers;

    UITableView* tableview;
    NSIndexPath* currentIndexPath;
    UITextField* currentTextField;
    
    NSDictionary* cardTypes;
    NSDictionary* seatTypes;
    NSDictionary* ticketTypes;
    
    id<ChooseTravelCompanionDelegate> chooseDelegate;
}

@property (nonatomic, retain) IBOutlet UITableView* tableview;
@property (nonatomic, retain) UITextField* currentTextField;
@property (nonatomic, retain) NSIndexPath* currentIndexPath;

@property (nonatomic, assign)id<ChooseTravelCompanionDelegate> chooseDelegate;

//输入参数，已经选中的旅客
@property (nonatomic, retain) NSArray* selectedPassengers;

//输入参数，当前车次的席别
@property (nonatomic, retain) NSDictionary* seatTypes;

@end
