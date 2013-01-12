//
//  CookieHelper.h
//  TicketsHunter
//
//  Created by Lei Sun on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookiesHelper : NSObject
{
    NSArray* cookies;
    NSString* ictHiddenName;
    NSString* ictHiddenValue;
}
@property(nonatomic,retain)NSArray* cookies;
@property(nonatomic,retain)NSString* ictHiddenName;
@property(nonatomic,retain)NSString* ictHiddenValue;
+(CookiesHelper*)sharedCookiesHelper;
@end
