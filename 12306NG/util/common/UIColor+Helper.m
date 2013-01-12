//
//  UIColor+Helper.m
//  TicketsHunter
//
//  Created by Lei Sun on 10/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helpers)
#define DEFAULT_VOID_COLOR [UIColor clearColor]
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6) 
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"]) 
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6) 
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+(NSString*)colorToHexString:(UIColor*)color
{
    return [color colorToHexString];
}
-(NSString*)colorToHexString
{
    
    const CGFloat *cs=CGColorGetComponents(self.CGColor);
    NSString *r = [NSString stringWithFormat:@"%X",(int)(255*cs[0])];
    NSString *g = [NSString stringWithFormat:@"%X",(int)(255*cs[1])];
    NSString *b = [NSString stringWithFormat:@"%X",(int)(255*cs[2])];
    
    if (r.length<2) {
        r=[@"0" stringByAppendingString:r];
    }
    if (g.length<2) {
        g=[@"0" stringByAppendingString:g];
    }
    if (b.length<2) {
        b=[@"0" stringByAppendingString:b];
    }
    
    
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];    
}
@end
