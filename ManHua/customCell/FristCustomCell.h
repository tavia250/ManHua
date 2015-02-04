//
//  FristCustomCell.h
//  ManHua
//
//  Created by jason on 14-5-21.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FristCustomCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UILabel *titleLable;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *parameterArray;
@property (nonatomic, assign)UIViewController *firstViewController;
@end
