//
//  SecondCustomCell.m
//  ManHua
//
//  Created by jason on 14-6-20.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import "SecondCustomCell.h"

@implementation SecondCustomCell
@synthesize titleLabel = _titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _xiaotuCustom = [[XiaotuCustom alloc] initWithFrame:CGRectMake(30, 0, 80, 100)];
        _xiaotuCustom.transform =  CGAffineTransformMakeRotation(M_PI/2);
        [self.contentView addSubview:_xiaotuCustom];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-30, 40, 80, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:11.f];
        _titleLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
         _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
      }
    return self;
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
