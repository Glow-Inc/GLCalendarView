//
//  GLCalendarMonthCoverView.m
//  GLPeriodCalendar
//
//  Created by ltebean on 15-4-17.
//  Copyright (c) 2015 glow. All rights reserved.
//

#import "GLCalendarMonthCoverView.h"
#import "GLDateUtils.h"

@interface GLCalendarMonthCoverView()
@property (nonatomic, copy) NSDate *firstDate;
@property (nonatomic, copy) NSDate *lastDate;
@end

@implementation GLCalendarMonthCoverView

- (void)updateWithFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate calendar:(NSCalendar *)calendar rowHeight:(CGFloat)rowHeight
{
    if ([GLDateUtils date:firstDate isSameDayAsDate:self.firstDate] && [GLDateUtils date:lastDate isSameDayAsDate:self.lastDate]) {
        return;
    }
    self.firstDate = firstDate;
    self.lastDate = lastDate;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    monthFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    monthFormatter.dateFormat = @"YYYY\nMMMM";

    NSDateComponents *today = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    for (NSDate *date = [GLDateUtils monthFirstDate:firstDate]; [date compare:lastDate] < 0; date = [GLDateUtils dateByAddingMonths:1 toDate:date]) {
        NSInteger dayDiff = [GLDateUtils daysBetween:firstDate and:date];
        if (dayDiff < 0) {
            continue;
        }
        
        NSDateComponents *components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];

        UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), rowHeight * 3)];
        monthLabel.backgroundColor = [UIColor clearColor];
        monthLabel.lineBreakMode = NSLineBreakByWordWrapping;
        monthLabel.numberOfLines = 0;
        monthLabel.textAlignment = NSTextAlignmentCenter;
        NSString *labelText = [monthFormatter stringFromDate:date];
        if (today.year == components.year) {
            labelText = [labelText substringFromIndex:5];
        }
        
        monthLabel.attributedText = [[NSAttributedString alloc] initWithString:labelText attributes:self.textAttributes];;
        monthLabel.center = CGPointMake(CGRectGetMidX(self.bounds), ceilf(rowHeight * (dayDiff / 7 + 2)));
        monthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        [self addSubview:monthLabel];
    }
}

@end
