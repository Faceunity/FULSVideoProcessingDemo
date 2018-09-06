//
//  NTESSandboxHelper.h
//  ShortVideo_Demo
//
//  Created by Netease on 17/2/14.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESSandboxHelper : NSObject

/**
 沙盒路径
 */
+ (NSString *)documentPath;

/**
 用户根路径
 */
+ (NSString *)userRootPath;

/**
 相册视频缓存路径
 */
+ (NSString *)videoCachePath;
+ (NSArray *)videoCachesFiles;
+ (void)clearCacheVideoPath;

/**
 录制视频存储路径
 */
+ (NSString *)videoRecordPath;
+ (NSArray *)videoRecordFiles;
+ (void)clearRecordVideoPath;

/**
 输出视频路径
 */
+ (NSString *)videoOutputPath;
+ (NSArray *)videoOutputFiles;
+ (void)clearOutputVideoPath;


/**
 清空所有文件
 */
+ (void)clear;

/**
 删除文件
 */
+ (void)deleteFiles:(NSArray *)filePaths;

+ (BOOL)fileIsExist:(NSString *)filePath;

/**
 创建目录
 */
+ (NSError *)createDirectoryWithPath:(NSString *)path;


/**
 查询目录
 */
+ (NSArray *)queryPath:(NSString *)dirPath;

@end
