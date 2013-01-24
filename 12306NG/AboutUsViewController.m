//
//  AboutUsViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([[UIScreen mainScreen] bounds].size.height == 568.0) {
        self = [super initWithNibName:@"AboutUsViewController_ip5" bundle:nibBundleOrNil];
    }else{
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor clearColor];
    [self showCustomBackButton];
    
    int OffsetY=30;
    
    
    UIImageView* logoView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoView.frame=CGRectMake(20, OffsetY, 280, 70);
    [self.view addSubview:logoView];
    [logoView release];
    
    
    UITextView* tipsView=[[UITextView alloc] initWithFrame:CGRectMake(20, 120, 320-40, 300)];
    [self.view addSubview:tipsView];
    tipsView.backgroundColor=[UIColor clearColor];
    tipsView.textColor=[UIColor lightTextColor];
    tipsView.font=[UIFont systemFontOfSize:15];
    tipsView.text=@"   此软件能够帮助你轻松预订买火车票，该版本实现了车票查询,车票预订和个人信息管理功能，如有任何问题，可以直接联系我们\n\n  邮箱:12306helper@gmail.com\n  微博:http://weibo.com/nextsun";
    [tipsView setUserInteractionEnabled:NO];
    [tipsView release];

    
    UILabel* lbAppZJ=[[UILabel alloc] initWithFrame:CGRectMake(10, 330, 320-20*2, 20)];
    [lbAppZJ setText:NSLocalizedString(@"12306抢票助手 V1.0.0",nil)];
    lbAppZJ.font=[UIFont boldSystemFontOfSize:14];
    lbAppZJ.textAlignment=UITextAlignmentCenter;
    lbAppZJ.textColor=[UIColor whiteColor];
    lbAppZJ.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lbAppZJ];
    [lbAppZJ release];
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
