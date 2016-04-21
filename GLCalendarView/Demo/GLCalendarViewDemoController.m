//
//  ViewController.m
//  GLPeriodCalendar
//
//  Created by ltebean on 15-4-16.
//  Copyright (c) 2015 glow. All rights reserved.
//

#import "GLCalendarViewDemoController.h"
#import "GLCalendarView.h"
#import "GLCalendarDateRange.h"
#import "GLDateUtils.h"
#import "GLCalendarDayCell.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface GLCalendarViewDemoController ()<GLCalendarViewDelegate>
@property (weak, nonatomic) IBOutlet GLCalendarView *calendarView;
@property (nonatomic, weak) GLCalendarDateRange *rangeUnderEdit;
@end

@implementation GLCalendarViewDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.calendarView.delegate = self;
    self.calendarView.showMagnifier = YES;

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSDate *today = [NSDate date];
    
    NSDate *beginDate1 = [GLDateUtils dateByAddingDays:-32 toDate:today];
    NSDate *endDate1 = [GLDateUtils dateByAddingDays:-26 toDate:today];
    GLCalendarDateRange *range1 = [GLCalendarDateRange rangeWithBeginDate:beginDate1 endDate:endDate1];
    range1.backgroundColor = UIColorFromRGB(0xEBEBEB);
    range1.textColor = UIColorFromRGB(0x4E4E4E);
    range1.editable = YES;
    
    NSDate *beginDate2 = [GLDateUtils dateByAddingDays:-6 toDate:today];
    NSDate *endDate2 = [GLDateUtils dateByAddingDays:-3 toDate:today];
    GLCalendarDateRange *range2 = [GLCalendarDateRange rangeWithBeginDate:beginDate2 endDate:endDate2];
    range2.backgroundColor = UIColorFromRGB(0xEBEBEB);
    range2.textColor = UIColorFromRGB(0x4E4E4E);
    range2.editable = YES;

    self.calendarView.ranges = [@[range1, range2] mutableCopy];
    
    [self.calendarView reload];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.calendarView scrollToDate:self.calendarView.lastDate animated:NO];
//    });
}

- (BOOL)calenderView:(GLCalendarView *)calendarView canAddRangeWithBeginDate:(NSDate *)beginDate
{
    return YES;
}

- (GLCalendarDateRange *)calenderView:(GLCalendarView *)calendarView rangeToAddWithBeginDate:(NSDate *)beginDate
{
    NSDate* endDate = [GLDateUtils dateByAddingDays:3 toDate:beginDate];
    GLCalendarDateRange *range = [GLCalendarDateRange rangeWithBeginDate:beginDate endDate:endDate];
    range.backgroundColor = UIColorFromRGB(0x80ae99);
    range.editable = YES;
    return range;
}

- (void)calenderView:(GLCalendarView *)calendarView beginToEditRange:(GLCalendarDateRange *)range
{
    NSLog(@"begin to edit range: %@", range);
    self.rangeUnderEdit = range;
}

- (void)calenderView:(GLCalendarView *)calendarView finishEditRange:(GLCalendarDateRange *)range continueEditing:(BOOL)continueEditing
{
    NSLog(@"finish edit range: %@", range);
    self.rangeUnderEdit = nil;
}

- (BOOL)calenderView:(GLCalendarView *)calendarView canUpdateRange:(GLCalendarDateRange *)range toBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    return YES;
}

- (void)calenderView:(GLCalendarView *)calendarView didUpdateRange:(GLCalendarDateRange *)range toBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    NSLog(@"did update range: %@", range);
}

- (IBAction)deleteButtonPressed:(id)sender
{
    if (self.rangeUnderEdit) {
        [self.calendarView removeRange:self.rangeUnderEdit];
    }
}

@end
