//
//  NSMutableArray+Helper.h
//  TranscodingDemo
//
//  Created by Netease on 16/12/20.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Helper)

- (void)addStringNoDuplicates:(NSString *)str;

+ (NSArray *)filePathsInDirectory:(NSString *)directory;

@end
