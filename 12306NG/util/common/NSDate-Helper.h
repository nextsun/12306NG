//
//  NSDate-Helper.h
//  Xml

//  Created by KM-zhou on 11-7-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSDate (Helpers)

- (NSString *)getFormatYearMonthDay;
- (int )getWeekNumOfMonth;
- (int )getWeekOfYear;
- (NSDate *)dateAfterDay:(int)day;
- (NSDate *)dateafterMonth:(int)month;
- (NSUInteger)getDay;
- (NSUInteger)getMonth;
- (NSUInteger)getYear;
- (int )getHour;
- (int )getMinute;
- (int )getHour:(NSDate *)date;
- (int )getMinute:(NSDate *)date;
- (int )getSecond:(NSDate *)date;
- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfMonth;
- (NSDate *)endOfMonth;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;
+ (NSString *)dateFormatMonthDay;
+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timeHMFormatString ;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;

@end