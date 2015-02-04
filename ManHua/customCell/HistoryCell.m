//
//  HistoryCell.m
//  ManHua
//
//  Created by jason on 14-8-12.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        _xiaotuCustom = [[XiaotuCustom alloc] initWithFrame:CGRectMake(0, 0, 80, 100)];
        [self.contentView addSubview:_xiaotuCustom];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 80, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:11.f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];

        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
