//
//  FirstViewController.m
//  ManHua
//
//  Created by jason on 14-3-5.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import "FirstViewController.h"
#import "XPathQuery.h"
#import "AFURLSessionManager.h" 

@interface FirstViewController ()
{
    int pointSize __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_5_0);

}
@end

@implementation FirstViewController

- (NSManagedObjectModel *)managedObjectModel
{
    if(nil != _managedObjectModel)
        return _managedObjectModel;
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (nil != _managedObjectContext)
        return _managedObjectContext;
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    return _managedObjectContext;
}
- (void)viewDidLoad
{

    [super viewDidLoad];
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"sdv");
        dispatch_sync(queue, ^{
            NSLog(@"ssdv");
        });
    });
    
	const char *text = "hello";

    void (^blk)() = ^{
      
        printf("%c\n",text[2]);
    };
    
    blk();
        
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
