//
//  Fileprocessing.h
//  ManHua
//
//  Created by jason on 14-5-20.
//  Copyright (c) 2014年 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fileprocessing : NSObject
+ (BOOL)isExistenceNetwork;

+ (NSURL *)getUrlLocal:(NSString *)name;

+ (void)saveHtmlLocal:(NSData *)htmlDataUTF8 fileUrl:(NSURL *)localUrl;

+ (NSData *)getHtmlLocal:(NSURL *)localUrl;

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (UIImage *)buttonImageFromColors:(NSArray *)colors frame:(CGRect)frame;

+ (NSOperationQueue *)sharedOperationQueue;
@end
