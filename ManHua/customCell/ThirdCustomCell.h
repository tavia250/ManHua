//
//  ThirdCustomCell.h
//  ManHua
//
//  Created by jason on 14-6-27.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroductionViewController.h"
@interface ThirdCustomCell : UITableViewCell
@property (nonatomic, strong)UIButton *btn1;
@property (nonatomic, strong)UIButton *btn2;
@property (nonatomic, strong)UIButton *btn3;
@property (nonatomic, strong)UIButton *btn4;
@property (nonatomic, assign)IntroductionViewController *firstViewController;
@property (nonatomic, strong)NSDictionary *btn1Dic;
@property (nonatomic, strong)NSDictionary *btn2Dic;
@property (nonatomic, strong)NSDictionary *btn3Dic;
@property (nonatomic, strong)NSDictionary *btn4Dic;
@end
