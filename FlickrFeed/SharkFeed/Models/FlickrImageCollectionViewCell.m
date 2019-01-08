//
//  FlickrImageCollectionViewCell.m
//  SharkFeed
//
//  Created by Swathi Bhattiprolu on 1/4/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

#import "FlickrImageCollectionViewCell.h"

@implementation FlickrImageCollectionViewCell


- (void) initWithPhoto : (UIImage *) image {
    
    self.sharkImageView.image = image;
    [self.activityIndicator stopAnimating];
}

- (void) downloadImage: (NSString *)imageURL atIndex:(NSUInteger)index andStack : (CoreDataStack *) stack withCompletionBlock:(void (^)(NSData *response)) success {
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:imageURL]];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        [self saveImageToCoreData:data atIndex:index andStack:stack];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
        });
        success(data);
    }];
    [dataTask resume];
    
}

- (void) saveImageToCoreData : (NSData *) imageData atIndex:(NSUInteger)index andStack: (CoreDataStack *) stack {
//    CoreDataStack *stack = [[CoreDataStack alloc] init];
//    [stack setupManagedObjectContext];
    [stack.managedObjectContext performBlock:^{
        NSArray *fetchedObjects = [stack fetchResults];
        if (fetchedObjects.count > 0) {
            NSManagedObject *sharkObject = [fetchedObjects objectAtIndex:index];
            [sharkObject setValue:imageData forKey:@"imageData"];
        }
        NSError *error = nil;
        [stack.managedObjectContext save:&error];
    }];
    
}

@end
