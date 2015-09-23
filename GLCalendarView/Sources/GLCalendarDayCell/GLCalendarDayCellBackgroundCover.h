//
//  GLCalendarDayCellSelectedCover.h
//  GLPeriodCalendar
//
//  Created by ltebean on 15/4/18.
//  Copyright (c) 2015 glow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RANGE_POSITION) {
    RANGE_POSITION_NONE = 0,
    RANGE_POSITION_BEGIN = 1,
    RANGE_POSITION_MIDDLE = 2,
    RANGE_POSITION_END = 3,
    RANGE_POSITION_SINGLE = 4,
};

@interface GLCalendarDayCellBackgroundCover : UIView
@property (nonatomic) RANGE_POSITION rangePosition;
@property (nonatomic) CGFloat paddingLeft;
@property (nonatomic) CGFloat paddingRight;
@property (nonatomic) CGFloat paddingTop;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) BOOL inEdit;
@property (nonatomic) BOOL isToday;
@property (nonatomic) BOOL continuousRangeDisplay;
@property (nonatomic) CGFloat pointSize;
@property (nonatomic) CGFloat pointScale;
- (void)enlargeBeginPoint:(BOOL)enlarge;
- (void)enlargeEndPoint:(BOOL)enlarge;
@end
