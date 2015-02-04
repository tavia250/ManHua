//
//  FourthCustomCell.m
//  ManHua
//
//  Created by jason on 14-6-30.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import "FourthCustomCell.h"

@implementation FourthCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 3.f;
        _contentImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _contentImage.backgroundColor = [UIColor whiteColor];
        _contentImage.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_contentImage];
        // contents remain same size. positioned adjusted.
        [self.contentView addSubview:_scrollView];
        // Initialization code
    }
    return self;
}

- (void)setContentImageFrame:(CGRect)frame
{
    _contentImage.frame = frame;
    _scrollView.frame = frame;
}
- (void)awakeFromNib
{
    // Initialization code
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    NSLog(@"**************viewForZoomingInScrollView");
    return _contentImage;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    self.contentImage.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
