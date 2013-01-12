//
//  WebViewController.h
//  TicketsHunter
//
//  Created by Lei Sun on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
{
    NSString* htmlString;
    NSURL* baseUrl;
}
@property(nonatomic,retain)NSString* htmlString;
@property(nonatomic,retain)NSURL* baseUrl;

@end
