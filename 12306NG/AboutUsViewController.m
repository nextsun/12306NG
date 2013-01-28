//
//  AboutUsViewController.m
//  12306NG
//
//  Created by Zhao Yang on 12/13/12.
//  Copyright (c) 2012 12306NG. All rights reserved.
//

#import "AboutUsViewController.h"
#import <MessageUI/MessageUI.h>

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    tipsView.text=@"   此软件能够帮助你轻松预订买火车票，该版本实现了车票查询,车票预订和个人信息管理功能，如有任何问题，可以直接联系我们";
    [tipsView setUserInteractionEnabled:NO];
    [tipsView release];
    
    
    
    UIButton* btnMail=[UIButton buttonWithType:UIButtonTypeCustom];
    btnMail.frame=CGRectMake(30, OffsetY+190, 220, 20);
    btnMail.titleLabel.textAlignment=UITextAlignmentLeft;
    [btnMail setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [btnMail setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btnMail.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [btnMail setTitle:@"邮箱:12306helper@gmail.com  " forState:UIControlStateNormal];
    //btnRegist.showsTouchWhenHighlighted=YES;
    [btnMail addTarget:self action:@selector(onMailClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnMail];
    
    UIView* lineView=[[UIView alloc] initWithFrame:CGRectMake(30, 20, 180, 1)];
    lineView.backgroundColor=[UIColor whiteColor];
    [btnMail addSubview:lineView];
    [lineView release];
    
    
    UIButton* btnRegist=[UIButton buttonWithType:UIButtonTypeCustom];
     btnRegist.titleLabel.textAlignment=UITextAlignmentLeft;
    btnRegist.frame=CGRectMake(30, OffsetY+220, 220, 20);
    [btnRegist setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [btnRegist setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btnRegist.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [btnRegist setTitle:@"微博:http://weibo.com/nextsun" forState:UIControlStateNormal];
    //btnRegist.showsTouchWhenHighlighted=YES;
    [btnRegist addTarget:self action:@selector(onRegistClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRegist];
    
    UIView* lineView2=[[UIView alloc] initWithFrame:CGRectMake(30, 20, 190, 1)];
    lineView2.backgroundColor=[UIColor whiteColor];
    [btnRegist addSubview:lineView2];
    [lineView2 release];



    
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
-(void)onRegistClick
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/nextsun"]];
}

-(void)onMailClick
{

if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController* mail=[[MFMailComposeViewController alloc] init];
    [mail setToRecipients:@[@"12306helper@gmail.com"]];
    mail.mailComposeDelegate=(id<MFMailComposeViewControllerDelegate>)self;
    mail.navigationBar.tintColor=[UIColor blackColor];
    [self presentModalViewController:mail animated:YES];
    
}
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result==MFMailComposeResultFailed) {
        
    }
    [controller dismissModalViewControllerAnimated:YES];
}
@end
