//
//  CMBPayViewController.m
//  12306NG
//
//  Created by Lei Sun on 1/28/13.
//  Copyright (c) 2013 12306NG. All rights reserved.
//

#import "CMBPayViewController.h"

@interface CMBPayViewController ()
@property(nonatomic,retain)UIWebView* webView;

@end

@implementation CMBPayViewController

@synthesize webView;
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
	// Do any additional setup after loading the view.
    
    //NSString* str=@"https://netpay.cmbchina.com/netpayment/BaseHttp.dll?MfcISAPICommand=TestPrePayWAP&BranchID=0100&CoNo=000000&BillNo=0154603744&Amount=8.00&Date=20130128&MerchantUrl=&MerchantPara=";
    
    
    self.title=@"招商银行手机支付";
    
    
    //Amount:6.00
//MerchantCode:|QOpQ/T34*qV/OumAj2deE7RIoUaF5fvBA7isHQX8FpvUYOajqQ==|2d833762413db1a584dd3b3aa942cbc8d95c4186
//BillNo:W2013012855005358
//Date:20130128
//MerchantUrl:http://epay.12306.cn/pay/payResponse
//CoNo:006958
//BranchID:0010
//MerchantPara:TRANS_ID=W2013012855005358|bankId=03080000|ExpireTime=20130128165425
    
//    NSString* str=@"https://netpay.cmbchina.com/netpayment/BaseHttp.dll?MfcISAPICommand=TestPrePayWAP&BranchID=0010&CoNo=000000&BillNo=0155005358&Amount=6.00&Date=20130129&MerchantUrl=&MerchantPara=";
    
    NSString* dateString=[[NSDate dateWithTimeIntervalSinceNow:0] stringWithFormat:@"yyyyMMdd"];
    
    
    NSString* billNoString=@"0155005358";
    NSString* moneyString=@"6.00";
    
    
    NSString* formatString=@"https://netpay.cmbchina.com/netpayment/BaseHttp.dll?MfcISAPICommand=TestPrePayWAP&BranchID=0010&CoNo=000000&BillNo=%@&Amount=%@&Date=%@&MerchantUrl=&MerchantPara=";
    
    NSString* realUrlString=[NSString stringWithFormat:formatString,billNoString,moneyString,dateString];
    
    
//    
//    NSURL *URL = [NSURL URLWithString:realUrlString];
//    
//    
    
    //[self.navigationController setToolbarHidden:NO];
    //self.navigationController.toolbar.barStyle=UIBarStyleBlack;
    //self.navigationController setToolbarItems:[]
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_black"]];    

    
    [self showCustomBackButton];
    
    
    
    
    NGCustomButton* subButton=[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [subButton addTarget:self action:@selector(payBills) forControlEvents:UIControlEventTouchUpInside];
    subButton.titleLabel.text=@"支付";
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:subButton] autorelease];
    [subButton release];

    
    NGCustomButton* prevButton=[[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 50, 50, 30)]autorelease];
    
    [prevButton addTarget:self action:@selector(prevPage) forControlEvents:UIControlEventTouchUpInside];
    prevButton.titleLabel.text=@"<<";
    UIBarButtonItem* b1=[[[UIBarButtonItem alloc] initWithCustomView:prevButton] autorelease];
    
    NGCustomButton* nextButton=[[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)] autorelease];
    nextButton.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
    [nextButton addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    nextButton.titleLabel.text=@">>";
    UIBarButtonItem* b2=[[[UIBarButtonItem alloc] initWithCustomView:nextButton] autorelease];
    
    
    NGCustomButton* reloadButton=[[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)]autorelease];
    
    [reloadButton addTarget:self action:@selector(reloadPage) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.titleLabel.text=@"刷新";
    UIBarButtonItem* b3=[[[UIBarButtonItem alloc] initWithCustomView:reloadButton] autorelease];

    
    NGCustomButton* stopButton=[[[NGCustomButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)] autorelease];
    
    [stopButton addTarget:self action:@selector(stopPage) forControlEvents:UIControlEventTouchUpInside];
    stopButton.titleLabel.text=@"停止";
    UIBarButtonItem* b4=[[[UIBarButtonItem alloc] initWithCustomView:stopButton] autorelease];

    
    UIBarButtonItem *spaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease];
    
    
    
    [self setToolbarItems:@[b1,spaceItem,b2,spaceItem,b3,spaceItem,b4] animated:YES];
    
    //self.navigationController.toolbarItems=[NSMutableArray arrayWithObjects:b, nil];
    

    

    self.webView=[[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
   
    self.webView.backgroundColor=[UIColor clearColor];
    self.webView.opaque=NO;
    for (UIView* subView in [self.webView subviews]) {
        
        if ([subView isKindOfClass:[UIScrollView class]]) {
            
            for (UIView* v in [subView subviews]) {
                
                if ( [v isKindOfClass:[UIImageView class]]) {
                    v.hidden=YES;
                }
                
            }            
        }
    }
    
    webView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:webView];
    
    
  // NSURL* rtl= [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"webBusiness" ofType:@"html"]];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:realUrlString]]];
    
    
    webView.delegate=(id<UIWebViewDelegate>)self;
    
    
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    HUD.mode=MBProgressHUDModeIndeterminate;
    HUD.yOffset=-50;
    [self.view addSubview:HUD];
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    
    [HUD show:YES];
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView_
{
   
   
    //[webView_ stringByEvaluatingJavaScriptFromString:@"alert(document.getElementById('div')"];
    
    [webView_ stringByEvaluatingJavaScriptFromString:@"document.forms[0].getElementsByTagName('div')[0].innerHTML=''"];    
     [HUD hide:YES];
}

-(void)prevPage
{
    
    [self.webView goBack];
    
}

-(void)nextPage
{
    
    [self.webView goForward];
}

-(void)reloadPage
{
    [self.webView reload];
    
}

-(void)stopPage
{
    [self.webView stopLoading];
    
}
-(void)payBills
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit()"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.webView setDelegate:self];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView setDelegate:nil];
    
    
}
@end
