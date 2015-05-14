//
//  GLDateUtils.m
//  GLPeriodCalendar
//
//  Created by ltebean on 15-4-21.
//  Copyright (c) 2015年 glow. All rights reserved.
//

#import "GLDateUtils.h"

#define CALENDAR_COMPONENTS NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay


@implementation GLDateUtils

+ (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2 {
    if (date1 == nil || date2 == nil) {
        return NO;
    }
    
    NSCalendar *calendar = [GLDateUtils calendar];
    
    NSDateComponents *day1 = [calendar components:CALENDAR_COMPONENTS fromDate:date1];
    NSDateComponents *day2 = [calendar components:CALENDAR_COMPONENTS fromDate:date2];
    return ([day2 day] == [day1 day] &&
            [day2 month] == [day1 month] &&
            [day2 year] == [day1 year]);
}

+ (NSCalendar *)calendar {
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSCalendar *cal = [threadDictionary objectForKey:@"GLCalendar"];
    if (!cal) {
        cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        cal.locale = [NSLocale currentLocale];
        [threadDictionary setObject:cal forKey:@"GLCalendar"];
    }
    return cal;
}

+ (NSDate *)weekFirstDate:(NSDate *)date
{
    NSCalendar *calendar = [GLDateUtils calendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = components.weekday;//1 for Sunday
    if (weekday == 1) {
        return date;
    } else {
        return [GLDateUtils dateByAddingDays:(1 - weekday) toDate:date];
    }
}

+ (NSDate *)weekLastDate:(NSDate *)date
{
    NSCalendar *calendar = [GLDateUtils calendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = components.weekday;//1 for Sunday
    if (weekday == 7) {//7 for Saturday
        return date;
    } else {
        return [GLDateUtils dateByAddingDays:(7 - weekday) toDate:date];
    }
}

+ (NSDate *)monthFirstDate:(NSDate *)date
{
    NSCalendar *calendar = [GLDateUtils calendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSDateComponents *result = [[NSDateComponents alloc] init];
    [result setDay:1];
    [result setMonth:[components month]];
    [result setYear:[components year]];
    [result setHour:12];
    [result setMinute:0];
    [result setSecond:0];
    
    return [calendar dateFromComponents:result];
}

+ (NSDate *)dateByAddingDays:(NSInteger )days toDate:(NSDate *)date {
    NSCalendar *calendar = [GLDateUtils calendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:days];
    return [calendar dateByAddingComponents:comps toDate:date options:0];
}

+ (NSDate *)dateByAddingMonths:(NSInteger )months toDate:(NSDate *)date
{
    NSCalendar *calendar = [GLDateUtils calendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:months];
    return [calendar dateByAddingComponents:comps toDate:date options:0];
}

+ (NSDate *)cutDate:(NSDate *)date
{
    NSCalendar *calendar = [GLDateUtils calendar];
    NSDateComponents *components = [calendar components:CALENDAR_COMPONENTS fromDate:date];
    return [calendar dateFromComponents:components];
}

+ (NSInteger)daysBetween:(NSDate *)beginDate and:(NSDate *)endDate
{
    NSDateComponents *components = [[GLDateUtils calendar] components:NSCalendarUnitDay fromDate:beginDate toDate:endDate options:0];
    return components.day;
}

+ (NSDate *)maxForDate:(NSDate *)date1 andDate:(NSDate *)date2
{
    if ([date1 compare:date2] == NSOrderedAscending) {
        return date2;
    } else {
        return date1;
    }
}

+ (NSDate *)minForDate:(NSDate *)date1 andDate:(NSDate *)date2
{
    if ([date1 compare:date2] == NSOrderedAscending) {
        return date1;
    } else {
        return date2;
    }
}

+ (NSString *)descriptionForDate:(NSDate *)date
{
    NSCalendar *calendar = [GLDateUtils calendar];
    NSDateComponents *components = [calendar components:CALENDAR_COMPONENTS fromDate:date];
    return [NSString stringWithFormat:@"%ld/%ld/%ld", (long)components.year, (long)components.month, (long)components.day];
}

static NSArray *months;
+ (NSString *)monthText:(NSInteger)month {
    if (!months) {
        months = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    }
    return [months objectAtIndex:(month - 1)];
}

@end
