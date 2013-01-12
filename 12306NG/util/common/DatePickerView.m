//
//  DatePickerView.m
//  TicketsHunter
//
//  Created by Lei Sun on 10/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "DatePickerView.h"
#import "NSDate-Helper.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3

@implementation DatePickerView
@synthesize delegate;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)_delegate
{
    
    self = [super initWithFrame:CGRectMake(0, 0, 320, 260)];
    if (self) {
        // Initialization code
        self.frame=CGRectMake(0, 0, 320, 260);
        self.delegate=_delegate;
        
        _superView=[[UIView alloc] init];
        _superView.layer.opacity=0.2;
        _superView.backgroundColor=[UIColor blackColor];
        
        
        datepicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 260-44)];
        [self addSubview:datepicker];
        
        [datepicker setDatePickerMode:UIDatePickerModeDate];
        
        
        
//        [datepicker setMinimumDate: [((NSDate*)[NSDate dateWithTimeIntervalSinceNow:0]) dateAfterDay:-3]];        
//        [datepicker setMaximumDate: [((NSDate*)[NSDate dateWithTimeIntervalSinceNow:0]) dateAfterDay:12]];
//        
        //datepicker addTarget:self action:@selector(<#selector#>) forControlEvents:<#(UIControlEvents)#>
        
        
        UIImageView* imgBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [imgBar setImage:[UIImage imageNamed:@"bg_023.png"]];
        
        imgBar.contentMode=UIViewContentModeScaleToFill;
        [self addSubview:imgBar];
        imgBar.layer.opacity=0.8;
        [imgBar release];
        
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 11, 320, 21)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textAlignment=UITextAlignmentCenter;
        titleLabel.textColor=[UIColor whiteColor];
        [self addSubview:titleLabel];
         
        titleLabel.text=title;
        
        [titleLabel release];
        
        UIButton* cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 1, 42, 42)];
       
        [cancelBtn setShowsTouchWhenHighlighted:YES];
        [cancelBtn setImage:[UIImage imageNamed:@"btn_021@2x.png"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
         [self addSubview:cancelBtn];
        [cancelBtn release];
        
        
        UIButton* okBtn=[[UIButton alloc] initWithFrame:CGRectMake(268, 1, 42, 42)];
        [self addSubview:okBtn];
        [okBtn setShowsTouchWhenHighlighted:YES];
        [okBtn setImage:[UIImage imageNamed:@"btn_020@2x.png"] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(locate:) forControlEvents:UIControlEventTouchUpInside];
        
        [okBtn release];
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (void)showInView:(UIView *) view withRect:(CGRect)rect
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {        
        [view addSubview:_superView];
        _superView.frame=view.bounds;
        
        CATransition *animation = [CATransition  animation];
        animation.delegate = self;
        animation.duration = kDuration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        [self setAlpha:1.0f];
        [self.layer addAnimation:animation forKey:@"DDLocateView"];        
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);        
        [view addSubview:self];
        
    }else {
        
        UIViewController* rootC=[[UIViewController alloc]init];
        rootC.view=self;        
        popoverController=[[UIPopoverController alloc] initWithContentViewController:rootC];
        [popoverController setPopoverContentSize:self.frame.size];
        [popoverController presentPopoverFromRect:rect inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [rootC release];
        
    }
    
    
}


- (IBAction)cancel:(id)sender {
    
    if (popoverController) {
        [popoverController dismissPopoverAnimated:YES];
        return;
    }
    
    
    [_superView removeFromSuperview];
    
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    

    
        if(self.delegate&&[self.delegate respondsToSelector:@selector(datePickerViewCancle:)]) {
            [self.delegate datePickerViewCancle:self];
        }
}

- (IBAction)locate:(id)sender {
    
    
    if (popoverController) {
        [popoverController dismissPopoverAnimated:YES];
        if(self.delegate&&[self.delegate respondsToSelector:@selector(datePickerView:didPickedWithDate:)]) {
            [self.delegate datePickerView:self didPickedWithDate:datepicker.date];
        }
        return;
    }
    
    
    [_superView removeFromSuperview];
    
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate datePickerView:self didPickedWithDate:datepicker.date];
    }
    
}
-(void)setCurrentDate:(NSDate *)currentDate_
{
    if (currentDate_) {
         [datepicker setDate:currentDate_];
    }

    
}
-(NSDate*)currentDate
{    
    return datepicker.date;
}


@end
