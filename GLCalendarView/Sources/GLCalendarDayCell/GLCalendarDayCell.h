//
//  GLCalendarDateCell.h
//  GLPeriodCalendar
//
//  Created by ltebean on 15-4-16.
//  Copyright (c) 2015 glow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLCalendarDateRange;

typedef NS_ENUM(NSInteger, CELL_POSITION) {
    POSITION_NORMAL = 0,
    POSITION_LEFT_EDGE = 1,
    POSITION_RIGHT_EDGE = 2,
};

typedef NS_ENUM(NSInteger, ENLARGE_POINT) {
    ENLARGE_NONE = 0,
    ENLARGE_BEGIN_POINT = 1,
    ENLARGE_END_POINT = 2,
};

typedef NS_ENUM(NSInteger, RANGE_DISPLAY_MODE) {
    RANGE_DISPLAY_MODE_CONTINUOUS = 1,
    RANGE_DISPLAY_MODE_SINGLE = 2,
};

@interface GLCalendarDayCell : UICollectionViewCell
@property (nonatomic, strong) UIColor *evenMonthBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *oddMonthBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *dayLabelAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *futureDayLabelAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *todayLabelAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *monthLabelAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *todayBackgroundColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) CGFloat editCoverPadding UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat editCoverBorderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *editCoverBorderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat editCoverPointSize UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat editCoverPointScale UI_APPEARANCE_SELECTOR;
@property (nonatomic) RANGE_DISPLAY_MODE rangeDisplayMode UI_APPEARANCE_SELECTOR;

@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, weak, readonly) GLCalendarDateRange *range;

- (void)setDate:(NSDate *)date range:(GLCalendarDateRange *)range cellPosition:(CELL_POSITION)cellPosition enlargePoint:(ENLARGE_POINT)enlargePoint;
@end
