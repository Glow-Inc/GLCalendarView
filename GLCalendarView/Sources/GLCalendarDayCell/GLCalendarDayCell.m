//
//  GLCalendarDateCell.m
//  GLPeriodCalendar
//
//  Created by ltebean on 15-4-16.
//  Copyright (c) 2015 glow. All rights reserved.
//

#import "GLCalendarDayCell.h"
#import "GLCalendarDayCellBackgroundCover.h"
#import "GLCalendarDateRange.h"
#import "GLDateUtils.h"
#import "GLCalendarView.h"
#import "GLCalendarDayCell.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface GLCalendarDayCell()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet GLCalendarDayCellBackgroundCover *backgroundCover;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundCoverLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundCoverRight;

@property (nonatomic) CELL_POSITION position;
@property (nonatomic) ENLARGE_POINT enlargePoint;
@property (nonatomic) BOOL inEdit;
@property (nonatomic) CGFloat containerPadding;
@end

@implementation GLCalendarDayCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self reloadAppearance];
}

- (void)reloadAppearance
{
    GLCalendarDayCell *appearance = [[self class] appearance];
    self.evenMonthBackgroundColor = appearance.evenMonthBackgroundColor ?: [UIColor whiteColor];
    self.oddMonthBackgroundColor = appearance.oddMonthBackgroundColor ?: [UIColor whiteColor];
    self.dayLabelAttributes = appearance.dayLabelAttributes ?: @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.dragDayLabelAttributes = appearance.dragDayLabelAttributes ?: @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]};
    self.futureDayLabelAttributes = appearance.futureDayLabelAttributes ?: self.dayLabelAttributes;
    self.monthLabelAttributes = appearance.monthLabelAttributes ?: @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.todayLabelAttributes = appearance.todayLabelAttributes ?: @{NSFontAttributeName:[UIFont boldSystemFontOfSize:22]};
    
    self.backgroundCover.paddingTop = appearance.editCoverPadding ?: 2;
    self.backgroundCover.borderWidth = appearance.editCoverBorderWidth ?: 2;
    self.backgroundCover.strokeColor = appearance.editCoverBorderColor ?: [UIColor darkGrayColor];
    
    self.backgroundCover.pointSize = appearance.editCoverPointSize ?: 14;
    self.backgroundCover.pointScale = appearance.editCoverPointScale ?: 1.3;
    
    RANGE_DISPLAY_MODE mode = appearance.rangeDisplayMode ?: RANGE_DISPLAY_MODE_SINGLE;
    self.backgroundCover.continuousRangeDisplay = mode == RANGE_DISPLAY_MODE_CONTINUOUS ? YES : NO;

    self.todayBackgroundColor = appearance.todayBackgroundColor ?: self.backgroundCover.strokeColor;
    self.orangeColor = appearance.orangeColor ?: UIColorFromRGB(0xFF671B);
    self.containerPadding = [GLCalendarView appearance].padding;
}

- (void)setDate:(NSDate *)date range:(GLCalendarDateRange *)range cellPosition:(CELL_POSITION)cellPosition enlargePoint:(ENLARGE_POINT)enlargePoint
{
    _date = [date copy];
    _range = range;
    if (range) {
        self.inEdit = range.inEdit;
    } else {
        self.inEdit = NO;
    }
    self.position = cellPosition;
    self.enlargePoint = enlargePoint;
    [self updateUI];
}

- (void)updateUI
{
//    NSLog(@"update ui: %@ %d", [GLDateUtils descriptionForDate:self.date], _enlargePoint);

    NSDateComponents *components = [[GLDateUtils calendar] components:NSCalendarUnitDay|NSCalendarUnitMonth fromDate:self.date];
    
    NSInteger day = components.day;
    NSInteger month = components.month;
    BOOL enlarge = self.enlargePoint != ENLARGE_NONE;

    // month background color
    if (month % 2 == 0) {
        self.backgroundCover.backgroundColor = self.evenMonthBackgroundColor;
    } else {
        self.backgroundCover.backgroundColor = self.oddMonthBackgroundColor;
    }
    
    // adjust background position
    self.backgroundCover.position = self.position;
    if (self.position == POSITION_LEFT_EDGE) {
        self.backgroundCoverRight.constant = 0;
        self.backgroundCoverLeft.constant = -self.containerPadding;
        self.backgroundCover.paddingLeft = self.containerPadding;
        self.backgroundCover.paddingRight = 0;
    } else if (self.position == POSITION_RIGHT_EDGE){
        self.backgroundCoverRight.constant = -self.containerPadding;
        self.backgroundCoverLeft.constant = 0;
        self.backgroundCover.paddingLeft = 0;
        self.backgroundCover.paddingRight = self.containerPadding;
    } else {
        self.backgroundCoverRight.constant = 0;
        self.backgroundCoverLeft.constant = 0;
        self.backgroundCover.paddingLeft = 0;
        self.backgroundCover.paddingRight = 0;
    }
        
    // day label and month label
    if ([self isToday]) {
//        self.monthLabel.textColor = [UIColor whiteColor];
        NSDateFormatter *todayFormatter = [[NSDateFormatter alloc] init];
        todayFormatter.dateStyle = NSDateFormatterMediumStyle;
        todayFormatter.timeStyle = NSDateFormatterNoStyle;
        todayFormatter.doesRelativeDateFormatting = YES;
        [self setMonthLabelText:@""];
//        [self setMonthLabelText:[todayFormatter stringFromDate:[NSDate date]]];
        self.dayLabel.textColor = [UIColor whiteColor];
        self.backgroundCover.isToday = YES;
        self.backgroundCover.fillColor = self.todayBackgroundColor;
        self.backgroundCover.orangeColor = self.orangeColor;
    } else if (day == 1) {
        self.monthLabel.textColor = [UIColor redColor];
        [self setMonthLabelText:[self monthText:month]];
        self.dayLabel.textColor = [UIColor redColor];
        self.backgroundCover.isToday = NO;
    } else {
        self.monthLabel.textColor = [UIColor blackColor];
        [self setMonthLabelText:@""];
        self.dayLabel.textColor = [UIColor blackColor];
        self.backgroundCover.isToday = NO;
    }

    if (enlarge) {
        [self setDragDayLabelText:[NSString stringWithFormat:@"%ld", (long)day]];
//        self.dayLabel.font = [UIFont boldSystemFontOfSize:14];
    } else {
        [self setDayLabelText:[NSString stringWithFormat:@"%ld", (long)day]];
//        self.dayLabel.font = [UIFont systemFontOfSize:14];
    }

    if ([self isFuture]) {
        [self setFutureDayLabelText:[NSString stringWithFormat:@"%ld", (long)day]];
    }

    if (([_date compare:[NSDate date]] == NSOrderedAscending) && ![self isToday]) {
        self.dayLabel.textColor = [UIColor colorWithWhite:0.75 alpha:1.0];
    }
    
    // background cover
    if (self.range) {
        // configure look when in range
        self.backgroundCover.fillColor = self.range.backgroundColor ?: [UIColor clearColor];
        self.backgroundCover.backgroundImage = self.range.backgroundImage ?: nil;
        UIColor *textColor = self.range.textColor ?: [UIColor whiteColor];
//        self.monthLabel.textColor = textColor;
        if (self.range.beginDate == self.range.endDate) {
            self.dayLabel.textColor = [UIColor whiteColor];
        }

        // check position in range
        BOOL isBeginDate = [GLDateUtils date:self.date isSameDayAsDate:self.range.beginDate];
        BOOL isEndDate = [GLDateUtils date:self.date isSameDayAsDate:self.range.endDate];

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:self.date];
        if ([comps day] == 1) {
            if ([comps weekday] == 7) {
                self.backgroundCover.position = POSITION_BOTH_EDGES;
            } else {
                self.backgroundCover.position = POSITION_LEFT_EDGE;
            }
        } else {
            [comps setMonth:[comps month] + 1];
            [comps setDay:0];
            NSDate *lastDayOfMonth = [calendar dateFromComponents:comps];
            if ([lastDayOfMonth compare:self.date] == NSOrderedSame) {
                if ([comps weekday] == 1) {
                    self.backgroundCover.position = POSITION_BOTH_EDGES;
                } else {
                    self.backgroundCover.position = POSITION_RIGHT_EDGE;
                }
            }
        }
        
        if (isBeginDate && isEndDate) {
            [self.backgroundCover setRangePosition:RANGE_POSITION_SINGLE enlarge:enlarge];
            [self.superview bringSubviewToFront:self];
        } else if (isBeginDate) {
            self.dayLabel.textColor = [UIColor whiteColor];
            [self.backgroundCover setRangePosition:RANGE_POSITION_BEGIN enlarge:enlarge];
            [self.superview bringSubviewToFront:self];
        } else if (isEndDate) {
            self.dayLabel.textColor = [UIColor whiteColor];
            [self.backgroundCover setRangePosition:RANGE_POSITION_END enlarge:enlarge];
            [self.superview bringSubviewToFront:self];
        } else {
            self.backgroundCover.rangePosition = RANGE_POSITION_MIDDLE;
        }
    } else {
        self.backgroundCover.rangePosition = RANGE_POSITION_NONE;
        [self.superview sendSubviewToBack:self];
    }
    
    self.backgroundCover.inEdit = self.inEdit;
    
//    if (self.enlargePoint == ENLARGE_BEGIN_POINT) {
//        [self.backgroundCover enlargeBeginPoint:YES];
//        [self.backgroundCover enlargeEndPoint:NO];
//    } else if (self.enlargePoint == ENLARGE_END_POINT) {
//        [self.backgroundCover enlargeBeginPoint:NO];
//        [self.backgroundCover enlargeEndPoint:YES];
//    } else {
//        [self.backgroundCover enlargeBeginPoint:NO];
//        [self.backgroundCover enlargeEndPoint:NO];
//    }
}

- (void)setDayLabelText:(NSString *)text
{
    self.dayLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.dayLabelAttributes];
}

- (void)setDragDayLabelText:(NSString *)text
{
    self.dayLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.dayLabelAttributes];
}

- (void)setFutureDayLabelText:(NSString *)text
{
    self.dayLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.futureDayLabelAttributes];
}


- (void)setTodayLabelText:(NSString *)text
{
    self.dayLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.todayLabelAttributes];
}

- (void)setMonthLabelText:(NSString *)text
{
    self.monthLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.monthLabelAttributes];
}


- (BOOL)isToday
{
    return [GLDateUtils date:self.date isSameDayAsDate:[NSDate date]];
}

- (BOOL)isFuture
{
    return [self.date compare:[NSDate date]] == NSOrderedDescending;
}

static NSArray *months;
- (NSString *)monthText:(NSInteger)month {
    if (!months) {
        months = [[[[NSDateFormatter alloc] init] shortStandaloneMonthSymbols] valueForKeyPath:@"capitalizedString"];
    }
    return [months objectAtIndex:(month - 1)];
}

@end
