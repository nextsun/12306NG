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

+(NSMutableDictionary*)allSeatDict
{
    
//    1  硬座
//    2  软座
//    3  硬卧
//    4  软卧
//    5
//    6  高级软卧
//    9  商务座
//    A
//    C
//    F
//    G
//    H
//    L
//    M 一等座
//    O 二等座  
//    P 特等座
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"硬座",@"1",
            @"软座",@"2",
            @"硬卧",@"3",
            @"软卧",@"4",
            
            @"高级软卧",@"6",

            @"商务座",@"9",
            @"一等座",@"O",
            @"二等座",@"M",
            @"特等座",@"P",
            nil];
    
    
    
}

+(NSString*)codeForSeatTypeName:(NSString*)name 
{
    
   
    NSMutableDictionary* d=[self allSeatDict];
    
    for ( NSString* key in [d allKeys]) {
        if ([[d objectForKey:key] isEqualToString:name] ) {
            return key;
        }
    }

    return @"未知";    
}
+(NSString*)codeForSeatTypePrefixName:(NSString*)name
{
    
    
    NSMutableDictionary* d=[self allSeatDict];
    
    for ( NSString* key in [d allKeys]) {
        if ([name hasPrefix: [d objectForKey:key]] ) {
            return key;
        }
    }
    
    return @"未知";
}
+(NSString*)nameForSeatTypeCode:(NSString*)code
{
    return [[self allSeatDict] objectForKey:code];
}

@end
