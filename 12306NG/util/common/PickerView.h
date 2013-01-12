//
//  PickerView.h
//  TicketsHunter
//
//  Created by Lei Sun on 10/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerView;
@protocol PickerViewDelegate
-(void)pickerView:(PickerView*)picker didPickedWithValue:(NSObject*)value;
-(void)pickerViewCancle:(PickerView*)picker;
@end 

@interface PickerView : UIView
{
    UIPickerView* picker;
    id<PickerViewDelegate> delegate;
    NSObject* currentValue;
    UIView* _superView;
    
    UIPopoverController* popoverController;
    NSMutableArray* dataArray;

}
@property(nonatomic,retain)NSObject* currentValue;
@property(nonatomic,retain)NSMutableArray* dataArray;
@property(nonatomic,assign)id<PickerViewDelegate> delegate;
- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;
- (void)showInView:(UIView *)view withRect:(CGRect)rect;
@end
