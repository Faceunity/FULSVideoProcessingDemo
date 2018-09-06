//
//  NSMutableArray+Helper.m
//  TranscodingDemo
//
//  Created by Netease on 16/12/20.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NSMutableArray+Helper.h"

@implementation NSMutableArray (Helper)

- (void)addStringNoDuplicates:(NSString *)str
{
    //去重
    __block BOOL isExist = NO;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:str]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    
    //不存在添加
    if (!isExist)
    {
        [self addObject:str];
    }
}

+ (NSArray *)filePathsInDirectory:(NSString *)directory
{
    NSMutableArray *docUrls = [NSMutableArray array];
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:directory];
    NSString *path = nil;
    while ((path = [direnum nextObject]) != nil)
    {
        [docUrls addObject:[NSString stringWithFormat:@"%@/%@", directory, path]];
    }
    return docUrls;
}


@end
