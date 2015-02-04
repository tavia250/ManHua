//
//  LoadprogressView.h
//  ManHua
//
//  Created by jason on 14-7-8.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadprogressView : UIView
@property (nonatomic, strong)UIProgressView *progressView;
- (void)startgif;
- (void)stopgif;
@end
