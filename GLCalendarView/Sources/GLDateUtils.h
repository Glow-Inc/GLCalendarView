//
//  GLDateUtils.h
//  GLPeriodCalendar
//
//  Created by ltebean on 15-4-21.
//  Copyright (c) 2015年 glow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLDateUtils : UIView
+ (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2;
+ (NSDate *)dateByAddingDays:(NSInteger )days toDate:(NSDate *)date;
+ (NSDate *)dateByAddingMonths:(NSInteger )months toDate:(NSDate *)date;
+ (NSInteger)daysBetween:(NSDate *)beginDate and:(NSDate *)endDate;
+ (NSDate *)cutDate:(NSDate *)date;
+ (NSString *)descriptionForDate:(NSDate *)date;
+ (NSDate *)weekFirstDate:(NSDate *)date;
+ (NSDate *)weekLastDate:(NSDate *)date;
+ (NSDate *)monthFirstDate:(NSDate *)date;
+ (NSCalendar *)calendar;
+ (NSDate *)maxForDate:(NSDate *)date1 andDate:(NSDate *)date2;
+ (NSDate *)minForDate:(NSDate *)date1 andDate:(NSDate *)date2;
+ (NSString *)monthText:(NSInteger)month;
@end
