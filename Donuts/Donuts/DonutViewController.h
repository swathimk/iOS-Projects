//
//  DonutViewController.h
//  Donuts
//
//  Created by Swathi Bhattiprolu on 04/15/18.
//  Copyright © 2018 Swathi Bhattiprolu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircularMeterView.h"

@interface DonutViewController : UIViewController

@property (nonatomic,strong) IBOutlet CircularMeterView *janChart;
@property (nonatomic,strong) IBOutlet UILabel *janSales;
@property (nonatomic,strong) IBOutlet UILabel *janQuota;
@property (nonatomic,strong) IBOutlet UILabel *janPercentage;

@property (nonatomic,strong) IBOutlet CircularMeterView *febChart;
@property (nonatomic,strong) IBOutlet UILabel *febSales;
@property (nonatomic,strong) IBOutlet UILabel *febQuota;
@property (nonatomic,strong) IBOutlet UILabel *febPercentage;

@property (nonatomic,strong) IBOutlet CircularMeterView *marchChart;
@property (nonatomic,strong) IBOutlet UILabel *marchSales;
@property (nonatomic,strong) IBOutlet UILabel *marchQuota;
@property (nonatomic,strong) IBOutlet UILabel *marchPercentage;


@end

