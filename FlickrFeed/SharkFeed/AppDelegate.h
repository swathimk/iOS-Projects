//
//  AppDelegate.h
//  SharkFeed
//
//  Created by Swathi Bhattiprolu on 1/3/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

