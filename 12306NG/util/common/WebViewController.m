//
//  WebViewController.m
//  TicketsHunter
//
//  Created by Lei Sun on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "ASIHTTPRequest.h"
#import "HTMLParser.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize htmlString;
@synthesize baseUrl;
- (id)initWithWithHtmlString:(NSString*)string andBaseUrl:(NSURL*)url;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        
          
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.view.backgroundColor=[UIColor whiteColor];
    
    
    ASIHTTPRequest* request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/sysuser/editMemberAction.do?method=initEdit"]];
    
    
    [request startSynchronous];
    
    
    HTMLParser* parse=[[HTMLParser alloc] initWithData:request.responseData error:nil];
    [request release];
    
    HTMLNode* body=parse.body;
    [parse release];
    
    LogInfo(@"%@",[body rawContents]);
    
    
    
    NSString* showString=@"";
    
    NSArray* arr=[body findChildrenOfClass:@"pim_right"];
    
    //[body release];
    for (HTMLNode* node in arr) {
        showString=[showString stringByAppendingString:[node rawContents]];
    }
    
    UIWebView* webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    // [webView loadHTMLString:string baseURL:url];
    [webView loadHTMLString:showString  baseURL:[NSURL URLWithString:@"https://dynamic.12306.cn/otsweb/sysuser/"]];
    [self.view addSubview:webView];
    webView.delegate=(id<UIWebViewDelegate>)self;

    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
