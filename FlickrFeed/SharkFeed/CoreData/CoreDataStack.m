//
//  CoreDataStack.m
//  SharkFeed
//
//  Created by Swathi Bhattiprolu on 1/4/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack ()

@end

@implementation CoreDataStack

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupManagedObjectContext
{
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self getManagedObjectModel];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: self.managedObjectModel];
    NSError* error;
    self.storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Data.sqlite"];
    [self.managedObjectContext.persistentStoreCoordinator
     addPersistentStoreWithType:NSSQLiteStoreType
     configuration:nil
     URL:self.storeURL
     options:nil
     error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void) getManagedObjectModel
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SharkFeed" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}


// Save
- (void) saveImageWithURL : (NSString *) imageURL andData : (NSData *) imageData atIndex : (NSNumber *) index withPageNumber : (NSNumber *) pageNumber highQualityImageURL : (NSString *) imageURLHQ originalImageURL : (NSString *) imageURLOriginal andID : (NSString *) photoID{
    
    __block NSError *error = nil;
    [self.managedObjectContext performBlockAndWait:^{
        NSManagedObject *sharkData = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:self.managedObjectContext];
        [sharkData setValue:imageURL forKey:@"imageURL"];
        [sharkData setValue:imageData forKey:@"imageData"];
        [sharkData setValue:index forKey:@"index"];
        [sharkData setValue:pageNumber forKey:@"pagenumber"];
        [sharkData setValue:imageURLHQ forKey:@"imageURLHQ"];
        [sharkData setValue:photoID forKey:@"photoID"];
        [sharkData setValue:imageURLOriginal forKey:@"imageURLOriginal"];
        
        [self.managedObjectContext save:&error];
    
    }];
    
    if (error) {
        NSLog(@"error is %@", error.localizedDescription);
    }
}

- (void) saveImageToCoreData : (NSData *) imageData atIndex:(NSUInteger)index {
    
    [self.managedObjectContext performBlockAndWait:^{
        NSArray *fetchedObjects = [self fetchResults];
        if (fetchedObjects.count > 0) {
            NSManagedObject *sharkObject = [fetchedObjects objectAtIndex:index];
            [sharkObject setValue:imageData forKey:@"imageData"];
        }
        NSError *error = nil;
        [self.managedObjectContext save:&error];
    }];
}


//Fetch
- (NSArray *) fetchResults
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    [request setReturnsObjectsAsFaults:NO];
    NSArray* objects = [self.managedObjectContext executeFetchRequest:request error:NULL];
    return objects;
}

- (int) getPageNumber {
    NSArray *fetchedObjects = [self fetchResults];
    NSManagedObject *last = [fetchedObjects lastObject];
    
    NSNumber *pgnum = [last valueForKey:@"pagenumber"];
    return [pgnum intValue];
}

- (NSArray *) getPhotoIDAtIndex : (NSUInteger) index {
    NSArray *fetchedObjects = [self fetchResults];
    NSManagedObject *object = [fetchedObjects objectAtIndex:index];
    
    NSString *imageURLHQ = [object valueForKey:@"imageURLHQ"] ? [object valueForKey:@"imageURLHQ"] : @"";
    NSString *imageURLOriginal = [object valueForKey:@"imageURLOriginal"] ? [object valueForKey:@"imageURLOriginal"] : @"";
    NSString *photoID = [object valueForKey:@"photoID"];
    NSData *imageData = [object valueForKey:@"imageData"] ? [object valueForKey:@"imageData"] : @"";
    self.isSavedImage = NO;
    if([object valueForKey:@"imageData"]){
        self.isSavedImage = YES;
    }
    NSArray *selectedPhoto = [[NSArray alloc] initWithObjects:imageURLHQ,imageURLOriginal,photoID,imageData, nil];
    return selectedPhoto;
}

//Delete or remove

- (void) removeAllObjects
{
    [self.managedObjectContext performBlockAndWait:^{
        NSArray *fetchedObjects = [self fetchResults];
        for (NSManagedObject *object in fetchedObjects)
        {
            [self.managedObjectContext deleteObject:object];
        }
        NSError *error = nil;
        [self.managedObjectContext save:&error];
    }];
}

@end
