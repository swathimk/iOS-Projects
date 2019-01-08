//
//  FlickrNetwork.h
//  SharkFeed
//
//  Created by Swathi Bhattiprolu on 1/3/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrNetwork : NSObject

@property int pageNumber;

- (void) getFlickrImages: (int)pagenum withCompletionBlock:(void (^)(NSDictionary *response)) success;
- (void) getImageDetails: (NSString *)photoID withCompletionBlock:(void (^)(NSDictionary *response)) success;

@end
