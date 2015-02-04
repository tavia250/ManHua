//
//  XiaotuCustom.m
//  ManHua
//
//  Created by jason on 14-6-25.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import "XiaotuCustom.h"

@implementation XiaotuCustom

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _xiaotuImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _xiaotuImage.backgroundColor = [UIColor whiteColor];
        [self addSubview:_xiaotuImage];
        _newestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _newestBtn.frame = CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
        _newestBtn.backgroundColor = [UIColor clearColor];
        NSMutableArray *colorArray = [@[[UIColor blackColor],[UIColor clearColor]] mutableCopy];
        UIImage *backImage = [Fileprocessing buttonImageFromColors:colorArray frame:_newestBtn.bounds];
        [_newestBtn setBackgroundImage:backImage forState:UIControlStateNormal];
        _newestBtn.font = [UIFont fontWithName:@"Arial" size:10.f];
        [_newestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_newestBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
       // [_newestBtn addTarget:self action:@selector(newestContent) forControlEvents:UIControlEventTouchUpInside];
        _newestBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _newestBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        [self addSubview:_newestBtn];

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
