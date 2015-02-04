//
//  IntroductionViewController.h
//  ManHua
//
//  Created by jason on 14-6-24.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XiaotuCustom.h"
@interface IntroductionViewController : UIViewController
@property (nonatomic, strong)NSDictionary *content;
@property (nonatomic, strong)XiaotuCustom *xiaotuCustom;
@property (nonatomic, strong)NSDictionary *xiaotuContent;
@property (nonatomic, strong)NSMutableDictionary *explainContent;
@property (nonatomic, strong)NSMutableArray *directorArray;
@property (nonatomic, strong)UITableView *tableView;
@end
