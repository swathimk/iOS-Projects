//
//  DetailViewController.h
//  SharkFeed
//
//  Created by Swathi Bhattiprolu on 1/5/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic,strong) IBOutlet UIScrollView *sharkImageScrollView;
@property (nonatomic,strong) IBOutlet UIImageView *sharkImageView;
@property (nonatomic,strong) IBOutlet UITextView *story;

@property (nonatomic,strong) IBOutlet UIButton *download;
@property (nonatomic,strong) IBOutlet UIButton *openInApp;

@property (nonatomic,strong) NSArray *selectedPhoto;

@property BOOL isSavedImage;

@end
