//
//  CircularMeterView.m
//  Donuts
//
//  Created by Swathi Bhattiprolu on 04/15/18.
//  Copyright © 2018 Swathi Bhattiprolu. All rights reserved.
//

#import "CircularMeterView.h"

const CFTimeInterval CircleAnimationDefaultDuration = 0.65;

@interface CircularMeterView()
@property BOOL needsAnimation;
@property double lastPercentage;
@end

IB_DESIGNABLE
@implementation CircularMeterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setup {
    if (!self.ringColor) {
        self.ringColor = [UIColor redColor];
    }
    if (!self.backgroundRingColour) {
        self.backgroundRingColour = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    if (!self.ringThickness) {
        self.ringThickness = 30;
    }
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setPercentage:(double)percentage {
    self.lastPercentage = self.percentage;
    _percentage = percentage;
}

- (void)setPercentage:(double)percentage animated:(BOOL)animated {
    self.percentage = percentage;
    self.needsAnimation = animated;
    [self setNeedsDisplay];
}

- (UIBezierPath *)bezierPathForCirclePercentage:(double)percentage {
    percentage = MAX(0.0001, percentage);
    UIBezierPath *bezierPath =
    [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds),
                                                      CGRectGetMidY(self.bounds))
                                   radius:(MIN(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds)) - self.ringThickness)/2
                               startAngle:M_PI_2
                                 endAngle:M_PI*2*percentage + M_PI_2
                                clockwise:YES];
    return bezierPath;
}

-(CABasicAnimation *)circleAnimationForKeyPath:(NSString *)keyPath {
    return nil;
}

- (void)drawRect:(CGRect)rect {
    for (CALayer *layer in [self.layer.sublayers copy]) {
        [layer removeFromSuperlayer];
    }
    
    UIBezierPath *fullCirclePath = [self bezierPathForCirclePercentage:1];
    
    CAShapeLayer *backgroundCircleShape = [[CAShapeLayer alloc] init];
    
    backgroundCircleShape.path          = fullCirclePath.CGPath;
    backgroundCircleShape.strokeColor   = self.backgroundRingColour.CGColor;
    backgroundCircleShape.fillColor     = [UIColor clearColor].CGColor;
    backgroundCircleShape.lineWidth     = self.ringThickness;
    backgroundCircleShape.strokeStart   = 0.0;
    backgroundCircleShape.strokeEnd     = 1.0;
    [self.layer addSublayer:backgroundCircleShape];
    
    
    CAShapeLayer *arcShape = [[CAShapeLayer alloc] init];
    
    arcShape.path          = [self bezierPathForCirclePercentage:1].CGPath;
    arcShape.strokeColor   = self.ringColor.CGColor;
    arcShape.fillColor     = [UIColor clearColor].CGColor;
    arcShape.lineWidth     = self.ringThickness;
    arcShape.lineCap       = kCALineCapRound;
    arcShape.strokeStart   = 0.0;
    arcShape.strokeEnd     = self.percentage;
    [self.layer addSublayer:arcShape];
    
    if (self.needsAnimation) {
        self.needsAnimation = NO;
        
        CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animateStrokeEnd.duration  = CircleAnimationDefaultDuration;
        animateStrokeEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animateStrokeEnd.fromValue = [NSNumber numberWithFloat:self.lastPercentage];
        animateStrokeEnd.toValue   = [NSNumber numberWithFloat:self.percentage];
        [arcShape addAnimation:animateStrokeEnd forKey:@"strokeEndAnimation"];
    }
}

- (void)prepareForInterfaceBuilder {
    if (self.percentage == 0) {
        self.percentage = 0.78;
    }
    [self setup];
}


@end



