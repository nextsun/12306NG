//
//  Utility.m
//  12306NG
//
//  Created by lidong  cui on 13-1-2.
//  Copyright (c) 2013年 12306NG. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSString*) pathForResource:(NSString*)resourcepath
{
    NSBundle * mainBundle = [NSBundle mainBundle];
    NSMutableArray *directoryParts = [NSMutableArray arrayWithArray:[resourcepath componentsSeparatedByString:@"/"]];
    NSString       *filename       = [directoryParts lastObject];
    [directoryParts removeLastObject];
    
    NSString *directoryStr = @"Xml";
    NSString *path= [mainBundle pathForResource:filename
                                         ofType:@""
                                    inDirectory:directoryStr];
    
    return path;
}


+ (NSMutableArray *)getXmlWithFileName:(NSString  *)fileName XPath: (NSString *)xpath{
    NSURL *xmlUrl = [NSURL fileURLWithPath:[Utility pathForResource:fileName]];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:xmlUrl];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithXMLData:data];        
     NSArray *elements  = [xpathParser searchWithXPathQuery:@"//title"]; // get the title  
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(TFHppleElement *element in elements) {
        [array addObject:[element content]];
    }
    
    [xpathParser release];
    [data release];
    
    return [array autorelease];
}


@end
