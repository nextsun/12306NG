//
//  PopAlertWebView.h
//  TicketsHunter
//
//  Created by Lei Sun on 10/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopAlertWebView;

//@protocol WBAuthorizeWebViewDelegate <NSObject>
//
//- (void)authorizeWebView:(WBAuthorizeWebView *)webView didReceiveAuthorizeCode:(NSString *)code;
//
//@end

@interface PopAlertWebView : UIView <UIWebViewDelegate> 
{
    UIView *panelView;
    UIView *containerView;
    UIActivityIndicatorView *indicatorView;
	UIWebView *webView;
    
    UIInterfaceOrientation previousOrientation;
    
    //id<WBAuthorizeWebViewDelegate> delegate;
}

//@property (nonatomic, assign) id<WBAuthorizeWebViewDelegate> delegate;

- (void)loadRequestWithURL:(NSURL *)url;
//- (void)loadHTMLString:(NSString *)string;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;



@end
