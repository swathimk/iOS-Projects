//
//  FlickrImageCollectionViewCell.h
//  SharkFeed
//
//  Created by Swathi Bhattiprolu on 1/4/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"

@interface FlickrImageCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) IBOutlet UIImageView *sharkImageView;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void) downloadImage: (NSString *)imageURL atIndex:(NSUInteger)index andStack : (CoreDataStack *) stack withCompletionBlock:(void (^)(NSData *response)) success;

@end
