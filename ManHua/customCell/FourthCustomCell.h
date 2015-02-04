//
//  FourthCustomCell.h
//  ManHua
//
//  Created by jason on 14-6-30.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourthCustomCell : UITableViewCell<UIScrollViewDelegate>
@property (nonatomic, strong)UIImageView *contentImage;
@property (nonatomic, strong)UIScrollView *scrollView;
- (void)setContentImageFrame:(CGRect)frame;
@end
