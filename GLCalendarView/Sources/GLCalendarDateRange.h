//
//  GLCalendarDateRange.h
//  GLPeriodCalendar
//
//  Created by ltebean on 15-4-17.
//  Copyright (c) 2015 glow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class GLCalendarDayCell;

@interface GLCalendarDateRange : NSObject
@property (nonatomic, copy) NSDate *beginDate;
@property (nonatomic, copy) NSDate *endDate;;
@property (nonatomic) BOOL inEdit;
@property (nonatomic) BOOL editable;

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, weak) id binding; // you can bind your model here
+ (instancetype)rangeWithBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;
- (BOOL)containsDate:(NSDate *)date;
@end
