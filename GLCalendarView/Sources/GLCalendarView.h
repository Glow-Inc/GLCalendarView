//
//  GLPeriodCalendarView.h
//  GLPeriodCalendar
//
//  Created by ltebean on 15-4-16.
//  Copyright (c) 2015 glow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCalendarDateRange.h"

@class GLCalendarView;

@protocol GLCalendarViewDelegate <NSObject>
- (BOOL)calenderView:(GLCalendarView *)calendarView canAddRangeWithBeginDate:(NSDate *)beginDate;
- (GLCalendarDateRange *)calenderView:(GLCalendarView *)calendarView rangeToAddWithBeginDate:(NSDate *)beginDate;
- (void)calenderView:(GLCalendarView *)calendarView beginToEditRange:(GLCalendarDateRange *)range;
- (void)calenderView:(GLCalendarView *)calendarView finishEditRange:(GLCalendarDateRange *)range continueEditing:(BOOL)continueEditing;
- (BOOL)calenderView:(GLCalendarView *)calendarView canUpdateRange:(GLCalendarDateRange *)range toBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;
- (void)calenderView:(GLCalendarView *)calendarView didUpdateRange:(GLCalendarDateRange *)range toBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;
@end


@interface GLCalendarView : UIView
@property (nonatomic) CGFloat padding UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat rowHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *weekDayTitleAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *monthCoverAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *backToTodayButtonImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *backToTodayButtonColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *backToTodayButtonBorderColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, copy) NSDate *firstDate;
@property (nonatomic, copy) NSDate *lastDate;
@property (nonatomic, strong) NSMutableArray *ranges;
@property (nonatomic) BOOL showMaginfier;
@property (nonatomic, weak) id<GLCalendarViewDelegate> delegate;
- (void)reload;
- (void)addRange:(GLCalendarDateRange *)range;
- (void)removeRange:(GLCalendarDateRange *)range;
- (void)updateRange:(GLCalendarDateRange *)range withBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;
- (void)forceFinishEdit;
- (void)beginToEditRange:(GLCalendarDateRange *)range;
- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated;
@end
