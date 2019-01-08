//
//  ViewController.h
//  SharkFeed
//
//  Created by Swathi Bhattiprolu on 1/3/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching>

@property (nonatomic,strong) IBOutlet UICollectionView *sharkCollectionView;
@property (nonatomic,strong) NSDictionary *sharkData;
@property (nonatomic,strong) NSArray *sharkArray;

@end

