//
//  DonutViewController.m
//  Donuts
//
//  Created by Swathi Bhattiprolu on 04/15/18.
//  Copyright © 2018 Swathi Bhattiprolu. All rights reserved.
//

#import "DonutViewController.h"

@interface DonutViewController ()

@property NSArray *data;

@end

@implementation DonutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.data = [[NSArray alloc] initWithObjects:@(331.9),@(653.3),@(498.2),@(556.7),@(829.2),@(722.8), nil];
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadData {
    self.janSales.text = [NSString stringWithFormat:@"$%@",[self.data objectAtIndex:0]];
    self.janQuota.text = [NSString stringWithFormat:@"$%@",[self.data objectAtIndex:1]];
    double jpercentage = ([[self.data objectAtIndex:0] floatValue]/[[self.data objectAtIndex:1] floatValue]) * 100;
    NSString* jformattedNumber = [NSString stringWithFormat:@"%.02f", jpercentage];
    self.janPercentage.text = [jformattedNumber stringByAppendingString:@"%"];
    [self.janChart setPercentage:jpercentage/100 animated:YES];
    
    
    self.febSales.text = [NSString stringWithFormat:@"$%@",[self.data objectAtIndex:2]];
    self.febQuota.text = [NSString stringWithFormat:@"$%@",[self.data objectAtIndex:3]];
    double fpercentage = ([[self.data objectAtIndex:2] floatValue]/[[self.data objectAtIndex:3] floatValue]) * 100;
    NSString* fformattedNumber = [NSString stringWithFormat:@"%.02f", fpercentage];
    self.febPercentage.text = [fformattedNumber stringByAppendingString:@"%"];
    [self.febChart setPercentage:fpercentage/100 animated:YES];
    
    
    self.marchSales.text = [NSString stringWithFormat:@"$%@",[self.data objectAtIndex:4]];
    self.marchQuota.text = [NSString stringWithFormat:@"$%@",[self.data objectAtIndex:5]];
    double mpercentage = ([[self.data objectAtIndex:4] floatValue]/[[self.data objectAtIndex:5] floatValue]) * 100;
    NSString* mformattedNumber = [NSString stringWithFormat:@"%.02f", mpercentage];
    self.marchPercentage.text = [mformattedNumber stringByAppendingString:@"%"];
    [self.marchChart setPercentage:mpercentage/100 animated:YES];
    
}


@end
