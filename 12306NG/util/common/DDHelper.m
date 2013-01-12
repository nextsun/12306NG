//  DDHelper.m
//  TicketsHunter
//
//  Created by Lei Sun on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DDHelper.h"

@implementation DDHelper
+(NSMutableArray*)allStations
{
    
    return [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle ]pathForResource:@"Station_Names" ofType:@"plist"]];
    
}
+(NSMutableArray*)seguestStationItemsByString:(NSString*)inputString
{
    NSMutableArray* allStations=[self allStations];
    
    
    [allStations filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSMutableDictionary* item=(NSMutableDictionary*)evaluatedObject;
        
        
        if ([[item objectForKey:@"pinyin"] hasPrefix:inputString])  {
            return YES;
        }else {
            if ([[item objectForKey:@"name"] hasPrefix:inputString])  {
                return YES;
            }
        }
        return NO;
    }]];
    
    return allStations;
}



//暂时这么做

+(NSString*)nameForCode:(NSString*)code withKey:(NSString*)key
{
    
    if ([key isEqualToString:@"userType"]) {
        
        if ([code isEqualToString:@"1"]) {
            return @"成人";
        }
        if ([code isEqualToString:@"2"]) {
            return @"儿童";
        }
        if ([code isEqualToString:@"3"]) {
            return @"学生";
        }
        if ([code isEqualToString:@"4"]) {
            return @"伤残军人";
        }
        
        
    }else if ([key isEqualToString:@"idType"])
    {
        
        if ([code isEqualToString:@"1"]) {
            return @"二代身份证";
        }
        if ([code isEqualToString:@"2"]) {
            return @"一代身份证";
        }
        if ([code isEqualToString:@"C"]) {
            return @"港澳通行证";
        }
        if ([code isEqualToString:@"G"]) {
            return @"台湾通行证";
        }
        if ([code isEqualToString:@"B"]) {
            return @"护照";
        }
        
    }
    return @"";
    
}
+(NSString*)codeForName:(NSString*)name withKey:(NSString*)key
{
    
    if ([key isEqualToString:@"userType"]) {
        
        if ([name isEqualToString:@"成人"]) {
            return @"1";
        }
        if ([name isEqualToString:@"儿童"]) {
            return @"2";
        }
        if ([name isEqualToString:@"儿童人"]) {
            return @"3";
        }
        if ([name isEqualToString:@"伤残军人"]) {
            return @"4";
        }
        
        
    }else if ([key isEqualToString:@"idType"])
    {        
        if ([name isEqualToString:@"二代身份证"]) {
            return @"1";
        }
        if ([name isEqualToString:@"一代身份证"]) {
            return @"2";
        }
        if ([name isEqualToString:@"港澳通行证"]) {
            return @"C";
        }
        if ([name isEqualToString:@"台湾通行证"]) {
            return @"G";
        }
        if ([name isEqualToString:@"护照"]) {
            return @"B";
        }        
    }
    return @"";
    
}
@end
