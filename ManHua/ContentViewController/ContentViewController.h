//
//  ContentViewController.h
//  ManHua
//
//  Created by jason on 14-6-27.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadprogressView.h"
@interface ContentViewController : UIViewController
@property (nonatomic, strong)LoadprogressView *loadprogressView;
@property (nonatomic, strong)NSDictionary *contentDic;
@property (nonatomic ,strong)NSMutableArray *contentArray;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *allcontentArray;
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, strong)NSMutableArray *heightArray;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong)UIButton *topButton;
@property (nonatomic, strong)UIButton *bottomButton;

@end
