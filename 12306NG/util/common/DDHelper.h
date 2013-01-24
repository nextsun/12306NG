//
//  DDHelper.h
//  TicketsHunter
//
//  Created by Lei Sun on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDHelper : NSObject
+(NSMutableArray*)allStations;
+(NSMutableArray*)seguestStationItemsByString:(NSString*)inputString;
+(NSString*)nameForCode:(NSString*)code withKey:(NSString*)key;
+(NSString*)codeForName:(NSString*)name withKey:(NSString*)key;


+(NSString*)codeForSeatTypeName:(NSString*)name;
+(NSString*)nameForSeatTypeCode:(NSString*)code;
+(NSString*)codeForSeatTypePrefixName:(NSString*)name;
@end
