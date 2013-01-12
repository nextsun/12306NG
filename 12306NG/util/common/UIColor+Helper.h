//
//  UIColor+Helper.h
//  TicketsHunter
//
//  Created by Lei Sun on 10/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helpers)
+(UIColor*)colorWithHexString:(NSString*)hexString;
+(NSString*)colorToHexString:(UIColor*)color;
-(NSString*)colorToHexString;
@end
