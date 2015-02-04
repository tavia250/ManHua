//
//  Fileprocessing.m
//  ManHua
//
//  Created by jason on 14-5-20.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import "Fileprocessing.h"
#import "Reachability.h"
@implementation Fileprocessing

//判断当前网络是否可用
+ (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    switch (r.currentReachabilityStatus) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        default:
            break;
    }
    
    return YES;
}

+ (NSURL *)getUrlLocal:(NSString *)name
{
    NSFileManager *fileManager = [NSFileManager new];
    
    NSURL *pathURL = [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return  [pathURL URLByAppendingPathComponent:name];

}

+ (void)saveHtmlLocal:(NSData *)htmlDataUTF8 fileUrl:(NSURL *)localUrl
{
    [htmlDataUTF8 writeToURL:localUrl atomically:YES];
}

+ (NSData *)getHtmlLocal:(NSURL *)localUrl
{
    
    return [NSData dataWithContentsOfFile:localUrl.path];
    
}
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)buttonImageFromColors:(NSArray *)colors frame:(CGRect)frame
{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    start = CGPointMake(frame.size.width, 0.0);
    end = CGPointMake(0.0, 0.0);
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return image;
    
}

+ (NSOperationQueue *)sharedOperationQueue {
    static NSOperationQueue *_operationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });
    
    return _operationQueue;
}

@end
