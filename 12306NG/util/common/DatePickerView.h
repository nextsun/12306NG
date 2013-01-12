//
//  DatePickerView.h
//  TicketsHunter
//
//  Created by Lei Sun on 10/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate-Helper.h"
@class DatePickerView;
@protocol DatePickerViewDelegate
-(void)datePickerView:(DatePickerView*)picker didPickedWithDate:(NSDate*)date;
-(void)datePickerViewCancle:(DatePickerView*)picker;
@end 



@interface DatePickerView:UIView{
    UIDatePicker* datepicker;
    id<DatePickerViewDelegate> delegate;
    NSDate* currentDate;
    UIView* _superView;
    
    UIPopoverController* popoverController;
    
}
@property(nonatomic,retain)NSDate* currentDate;
@property(nonatomic,assign)id<DatePickerViewDelegate> delegate;
- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;
- (void)showInView:(UIView *)view withRect:(CGRect)rect;
@end
