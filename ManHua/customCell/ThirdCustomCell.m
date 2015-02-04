//
//  ThirdCustomCell.m
//  ManHua
//
//  Created by jason on 14-6-27.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import "ThirdCustomCell.h"
#import "ContentViewController.h"
@implementation ThirdCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn1.frame = CGRectMake(8, 10, 70, 30);
        [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btn1.font = [UIFont fontWithName:@"Arial-BoldMT" size:11];
        [_btn1 addTarget:self action:@selector(showContentView:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_btn1];
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2.frame = CGRectMake(86, 10, 70, 30);
        [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        _btn2.font = [UIFont fontWithName:@"Arial-BoldMT" size:11];
        [_btn2 addTarget:self action:@selector(showContentView:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:_btn2];
        _btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn3.frame = CGRectMake(164, 10, 70, 30);
        [_btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        _btn3.font = [UIFont fontWithName:@"Arial-BoldMT" size:11];
        [_btn3 addTarget:self action:@selector(showContentView:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:_btn3];
        _btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn4.frame = CGRectMake(242, 10, 70, 30);
        [_btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        _btn4.font = [UIFont fontWithName:@"Arial-BoldMT" size:11];
        [_btn4 addTarget:self action:@selector(showContentView:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:_btn4];
        
        // Initialization code
    }
    return self;
}

- (void)showContentView:(UIButton *)sender
{
    
    ContentViewController *contentView = [[ContentViewController alloc] init];
    _firstViewController.hidesBottomBarWhenPushed = YES;
    if ([sender.currentTitle isEqualToString:[_btn1Dic objectForKey:@"title"]]) {
        contentView.contentDic = _btn1Dic;
    }
    else
        
    if ([sender.currentTitle isEqualToString:[_btn2Dic objectForKey:@"title"]]) {
        contentView.contentDic = _btn2Dic;
    }
    else
        
    if ([sender.currentTitle isEqualToString:[_btn3Dic objectForKey:@"title"]]) {
        contentView.contentDic = _btn3Dic;
    }
    else
        
    if ([sender.currentTitle isEqualToString:[_btn4Dic objectForKey:@"title"]]) {
        contentView.contentDic = _btn4Dic;
    }
    contentView.allcontentArray = _firstViewController.directorArray;
    [_firstViewController.navigationController pushViewController:contentView animated:YES];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
