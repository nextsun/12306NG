//
//  KeyValuePickerView.h
//  12306NG
//
//  Created by Sun on 1/4/13.
//  Copyright (c) 2013 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerView.h"

@interface KeyValuePickerView : PickerView
{
    
    //NSString* valueField;
    NSString* textField;
}
//@property(nonatomic,retain)NSString* valueField;
@property(nonatomic,retain)NSString* textField;
@end
