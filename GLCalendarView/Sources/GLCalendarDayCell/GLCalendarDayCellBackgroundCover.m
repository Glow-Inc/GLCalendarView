//
//  GLCalendarDayCellSelectedCover.m
//  GLPeriodCalendar
//
//  Created by ltebean on 15/4/18.
//  Copyright (c) 2015 glow. All rights reserved.
//

#import "GLCalendarDayCellBackgroundCover.h"
#define POINT_SCALE 1.3

@interface GLCalendarRangePoint : UIView
@property (nonatomic, strong, readonly) UIColor *strokeColor;
@property (nonatomic, readonly) CGFloat borderWidth;
- (instancetype)initWithSize:(CGFloat)size borderWidth:(CGFloat)borderWidth strokeColor:(UIColor *)strokeColor;
@end

@implementation GLCalendarRangePoint

- (instancetype)initWithSize:(CGFloat)size borderWidth:(CGFloat)borderWidth strokeColor:(UIColor *)strokeColor
{
    self = [super initWithFrame:CGRectMake(0, 0, size, size)];
    if (self) {
        self.layer.borderColor = strokeColor.CGColor;
        self.layer.borderWidth = borderWidth;
        self.layer.cornerRadius = size / 2;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
    }
    return self;
}
@end

@interface GLCalendarDayCellBackgroundCover()
@property (nonatomic, strong) GLCalendarRangePoint *beginPoint;
@property (nonatomic, strong) GLCalendarRangePoint *endPoint;
@end
@implementation GLCalendarDayCellBackgroundCover

- (void)setRangePosition:(RANGE_POSITION)rangePosition
{
    _rangePosition = rangePosition;
    self.inEdit = self.inEdit;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)setIsToday:(BOOL)isToday
{
    _isToday = isToday;
    [self setNeedsDisplay];
}

- (void)setInEdit:(BOOL)inEdit
{
    _inEdit = inEdit;
    if (inEdit) {
        if (self.rangePosition == RANGE_POSITION_BEGIN) {
            self.beginPoint.center = CGPointMake(self.borderWidth / 2 + self.paddingLeft, self.bounds.size.height / 2);
            [self addSubview:self.beginPoint];
            [_endPoint removeFromSuperview];
        } else if (self.rangePosition == RANGE_POSITION_END) {
            self.endPoint.center = CGPointMake(self.bounds.size.width - self.borderWidth / 2 - self.paddingRight, self.bounds.size.height / 2);
            [self addSubview:self.endPoint];
            [_beginPoint removeFromSuperview];
        } else if (self.rangePosition == RANGE_POSITION_SINGLE) {
            self.beginPoint.center = CGPointMake(self.borderWidth / 2 + self.paddingLeft, self.bounds.size.height / 2);
            [self addSubview:self.beginPoint];
            self.endPoint.center = CGPointMake(self.bounds.size.width - self.borderWidth / 2 - self.paddingRight, self.bounds.size.height / 2);
            [self addSubview:self.endPoint];
        } else {
            [_beginPoint removeFromSuperview];
            [_endPoint removeFromSuperview];
        }
    } else {
        [_beginPoint removeFromSuperview];
        [_endPoint removeFromSuperview];
    }
    [self setNeedsDisplay];
}

- (GLCalendarRangePoint *)beginPoint
{
    if (!_beginPoint) {
        _beginPoint = [[GLCalendarRangePoint alloc] initWithSize:self.pointSize borderWidth:self.borderWidth strokeColor:self.strokeColor];
        _beginPoint.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    }
    return _beginPoint;
}

- (GLCalendarRangePoint *)endPoint
{
    if (!_endPoint) {
        _endPoint = [[GLCalendarRangePoint alloc] initWithSize:self.pointSize borderWidth:self.borderWidth strokeColor:self.strokeColor];
        _endPoint.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    }
    return _endPoint;
}


- (void)drawRect:(CGRect)rect
{
    [self drawSelectedCover:rect];
    [self drawTodayCircle:rect];
}

- (void)drawSelectedCover:(CGRect)rect
{
    if (self.rangePosition == RANGE_POSITION_NONE) {
        return;
    }
    
    CGFloat paddingLeft = self.paddingLeft;
    CGFloat paddingRight = self.paddingRight;
    CGFloat paddingTop = self.paddingTop;
    
    CGFloat borderWidth = self.borderWidth;
    
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    CGFloat radius = (height - borderWidth * 2 - paddingTop * 2) / 2;
    
    CGFloat midY = CGRectGetMidY(rect);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (!self.inEdit && !self.continuousRangeDisplay) {
        CGRect rect = CGRectMake(borderWidth + paddingLeft, borderWidth + paddingTop, width - borderWidth * 2 - paddingLeft - paddingRight,  height - borderWidth * 2 - paddingTop * 2);
        if (self.backgroundImage) {
            [self.backgroundImage drawInRect:rect];
            return;
        }
        path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [path closePath];
        [self.fillColor setFill];
        [path fill];
        return;
    }
    
    if (self.rangePosition == RANGE_POSITION_BEGIN) {
        [path moveToPoint:CGPointMake(radius + borderWidth + paddingLeft, paddingTop + borderWidth)];
        [path addArcWithCenter:CGPointMake(radius + borderWidth + paddingLeft, midY) radius:radius startAngle: - M_PI / 2 endAngle: M_PI / 2 clockwise:NO];
        [path addLineToPoint:CGPointMake(width, height - borderWidth - paddingTop)];
        [path addLineToPoint:CGPointMake(width, borderWidth + paddingTop)];
        [path closePath];
    } else if (self.rangePosition == RANGE_POSITION_END) {
        [path moveToPoint:CGPointMake(width - borderWidth - radius - paddingRight, paddingTop + borderWidth)];
        [path addArcWithCenter:CGPointMake(width - borderWidth - radius - paddingRight, midY) radius:radius startAngle: - M_PI / 2 endAngle: M_PI / 2 clockwise:YES];
        [path addLineToPoint:CGPointMake(0, height - borderWidth - paddingTop)];
        [path addLineToPoint:CGPointMake(0, borderWidth + paddingTop)];
        [path closePath];
    }  else if (self.rangePosition == RANGE_POSITION_MIDDLE){
        [path moveToPoint:CGPointMake(0, borderWidth + paddingTop)];
        [path addLineToPoint:CGPointMake(width, borderWidth + paddingTop)];
        [path addLineToPoint:CGPointMake(width, height - borderWidth - paddingTop)];
        [path addLineToPoint:CGPointMake(0, height - borderWidth - paddingTop)];
        [path closePath];
    } else if (self.rangePosition == RANGE_POSITION_SINGLE) {
        path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(borderWidth + paddingLeft, borderWidth + paddingTop, width - borderWidth * 2 - paddingLeft - paddingRight,  height - borderWidth * 2 - paddingTop * 2)];
        [path closePath];
    }
    if (_inEdit) {
        path.lineWidth = borderWidth * 2;
        [self.strokeColor setStroke];
        [path stroke];
    }
    [self.fillColor setFill];
    [path fill];
}

- (void)drawTodayCircle:(CGRect)rect
{
    if (!self.isToday) {
        return;
    }
    CGFloat paddingLeft = self.paddingLeft;
    CGFloat paddingRight = self.paddingRight;
    CGFloat paddingTop = self.paddingTop;
    
    CGFloat borderWidth = self.borderWidth;
    
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
            
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(borderWidth + paddingLeft, borderWidth + paddingTop, width - borderWidth * 2 - paddingLeft - paddingRight,  height - borderWidth * 2 - paddingTop * 2)];
    [path closePath];
    [self.fillColor setFill];
    [path fill];
}

- (void)enlargeBeginPoint:(BOOL)enlarge
{
    if (enlarge) {
        [self setPointView:_beginPoint sizeTo:ceilf(self.pointSize * self.pointScale)];
    } else {
        [self setPointView:_beginPoint sizeTo:self.pointSize];
    }
}

- (void)enlargeEndPoint:(BOOL)enlarge
{
    if (enlarge) {
        [self setPointView:_endPoint sizeTo:ceilf(self.pointSize * self.pointScale)];
    } else {
        [self setPointView:_endPoint sizeTo:self.pointSize];
    }
}

- (void)setPointView:(UIView *)pointView sizeTo:(CGFloat)size
{
    CGPoint center = pointView.center;
    pointView.frame = CGRectMake(0, 0, size, size);
    pointView.center = center;
    pointView.layer.cornerRadius = size / 2;
}
@end
