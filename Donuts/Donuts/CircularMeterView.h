//
//  CircularMeterView.h
//  Donuts
//
//  Created by Swathi Bhattiprolu on 04/15/18.
//  Copyright © 2018 Swathi Bhattiprolu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularMeterView : UIView

@property (nonatomic) double percentage;

@property IBInspectable UIColor *ringColor;
@property IBInspectable UIColor *backgroundRingColour;
@property IBInspectable CGFloat ringThickness;

-(void) setPercentage:(double)percentage animated:(BOOL)animated;

@end

