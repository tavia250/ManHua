//
//  LoadprogressView.m
//  ManHua
//
//  Created by jason on 14-7-8.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import "LoadprogressView.h"
#import <ImageIO/ImageIO.h>
#import <QuartzCore/CoreAnimation.h>

@interface LoadprogressView ()
{
    NSMutableArray *_frames;
    NSMutableArray *_frameDelayTimes;
    
    CGFloat _totalTime;         // seconds
    CGFloat _width;
    CGFloat _height;
    UIView *gifview;

}

@end

@implementation LoadprogressView

void getFrameInfo(CFURLRef url, NSMutableArray *frames, NSMutableArray *delayTimes, CGFloat *totalTime,CGFloat *gifWidth, CGFloat *gifHeight)
{
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL(url, NULL);
    
    // get frame count
    size_t frameCount = CGImageSourceGetCount(gifSource);
    for (size_t i = 0; i < frameCount; ++i) {
        // get each frame
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        [frames addObject:(__bridge id)frame];
        CGImageRelease(frame);
        
        // get gif info with each frame
        NSDictionary *dict = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL);
//        NSLog(@"kCGImagePropertyGIFDictionary %@", [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary]);
        
        // get gif size
        if (gifWidth != NULL && gifHeight != NULL) {
            *gifWidth = [[dict valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
            *gifHeight = [[dict valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
        }
        
        // kCGImagePropertyGIFDictionary中kCGImagePropertyGIFDelayTime，kCGImagePropertyGIFUnclampedDelayTime值是一样的
        NSDictionary *gifDict = [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
        [delayTimes addObject:[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime]];
        
        if (totalTime) {
            *totalTime = *totalTime + [[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime] floatValue];
        }
        
        CFRelease(CFBridgingRetain(dict));
    }
    
    if (gifSource) {
        CFRelease(gifSource);
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        centerView.backgroundColor = [UIColor whiteColor];
        centerView.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        centerView.center =  CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        
        
        self.backgroundColor = [UIColor whiteColor];
        _frames = [[NSMutableArray alloc] init];
        _frameDelayTimes = [[NSMutableArray alloc] init];
        
        _width = 0;
        _height = 0;

        gifview = [[UIView alloc] initWithFrame:CGRectZero];
        
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"deer8" withExtension:@"gif"];

        getFrameInfo((__bridge CFURLRef)fileURL, _frames, _frameDelayTimes, &_totalTime, &_width, &_height);
        gifview.frame = CGRectMake(0,0, _width/2.f, _height/2.f);
        gifview.center = CGPointMake(CGRectGetMidX(centerView.bounds), CGRectGetMidY(centerView.bounds));

        [centerView addSubview:gifview];
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width*.7f, 10)];
        _progressView.center =  CGPointMake(CGRectGetMidX(centerView.bounds), CGRectGetMidY(centerView.bounds)+_height/4.f + 5.f)
        ;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width *.4f,30)];
        textLabel.font = [UIFont fontWithName:@"Arial" size:13];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = @"正在加载中...";
        textLabel.center =   CGPointMake(CGRectGetMidX(centerView.bounds), CGRectGetMidY(centerView.bounds)+_height/4.f + 15.f);
        [centerView addSubview:textLabel];

        [centerView addSubview:_progressView];
        
        [self addSubview:centerView];
    }
    return self;
}

- (void)startgif
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    NSMutableArray *times = [NSMutableArray arrayWithCapacity:3];
    CGFloat currentTime = 0;
    NSUInteger count = _frameDelayTimes.count;
    for (int i = 0; i < count; ++i) {
        [times addObject:[NSNumber numberWithFloat:(currentTime / _totalTime)]];
        currentTime += [[_frameDelayTimes objectAtIndex:i] floatValue];
    }
    [animation setKeyTimes:times];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < count; ++i) {
        [images addObject:[_frames objectAtIndex:i]];
    }
    
    [animation setValues:images];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = _totalTime;
    animation.delegate = self;
   animation.repeatCount = HUGE_VALF;
    
    [gifview.layer addAnimation:animation forKey:@"gifAnimation"];

}

- (void)stopgif
{
    [gifview.layer removeAllAnimations];

}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    gifview.layer.contents = nil;
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
