//
//  KeyValuePickerView.m
//  12306NG
//
//  Created by Sun on 1/4/13.
//  Copyright (c) 2013 12306NG. All rights reserved.
//

#import "KeyValuePickerView.h"

@implementation KeyValuePickerView

//@synthesize valueField;
@synthesize textField;


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[dataArray objectAtIndex:row] objectForKey:textField];
}
@end
