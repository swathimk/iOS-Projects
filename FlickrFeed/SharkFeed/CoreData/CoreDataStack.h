//
//  CoreDataStack.h
//  SharkFeed
//
//  Created by Swathi Bhattiprolu on 1/4/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : UIViewController

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong) NSURL *storeURL;
@property (nonatomic,strong) NSArray *sharkArray;
@property BOOL isSavedImage;

- (void)setupManagedObjectContext;
- (NSArray *) fetchResults;
- (void) saveImageWithURL : (NSString *) imageURL andData : (NSData *) imageData atIndex : (NSNumber *) index withPageNumber : (NSNumber *) pageNumber highQualityImageURL : (NSString *) imageURLHQ originalImageURL : (NSString *) imageURLOriginal andID : (NSString *) photoID;
- (void) removeAllObjects;
- (int) getPageNumber;
- (NSArray *) getPhotoIDAtIndex : (NSUInteger) index;
- (void) saveImageToCoreData : (NSData *) imageData atIndex:(NSUInteger)index;

@end
