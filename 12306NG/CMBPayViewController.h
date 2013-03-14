//
//  CMBPayViewController.h
//  12306NG
//
//  Created by Lei Sun on 1/28/13.
//  Copyright (c) 2013 12306NG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface CMBPayViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView* webView;
    
    MBProgressHUD* HUD;
}

@end
