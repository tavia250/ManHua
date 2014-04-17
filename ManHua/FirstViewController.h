//
//  FirstViewController.h
//  ManHua
//
//  Created by jason on 14-3-5.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface FirstViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
