//
//  Utility.h
//  12306NG
//
//  Created by lidong  cui on 13-1-2.
//  Copyright (c) 2013年 12306NG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
@interface Utility : NSObject
+ (NSString *) pathForResource:(NSString*)resourcepath;
+ (NSMutableArray *)getXmlWithFileName:(NSString  *)fileName XPath: (NSString *)xpath;
@end
