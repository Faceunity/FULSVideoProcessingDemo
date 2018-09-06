//
//  NTESSandboxHelper.m
//  ShortVideo_Demo
//
//  Created by Netease on 17/2/14.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESSandboxHelper.h"

#define NTES_FILE_CACHE_IDENTIFIER @"shortVideoDemo"

@implementation NTESSandboxHelper

//主路径
+ (NSString *)homePath
{
    return NSHomeDirectory();
}

//沙盒路径
+ (NSString *)documentPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//用户根路径
+ (NSString *)userRootPath
{
    NSString *docPath = [NTESSandboxHelper documentPath];
    NSString *rootPath = [NSString stringWithFormat:@"%@/%@", docPath, NTES_FILE_CACHE_IDENTIFIER];
    
    NSError *error = [NTESSandboxHelper createDirectoryWithPath:rootPath];
    return (error ? nil : rootPath);
}

//相册视频缓存路径
+ (NSString *)videoCachePath
{
    NSString *userRootPath = [NTESSandboxHelper userRootPath];
    NSError *error = nil;
    NSString *path = nil;
    if (userRootPath) {
        path = [userRootPath stringByAppendingPathComponent:@"ntes_cache_video"];
        error = [NTESSandboxHelper createDirectoryWithPath:path];
    }
    
    return (error ? nil : path);
}

//用户录制根路径
+ (NSString *)videoRecordPath
{
    NSString *userRootPath = [NTESSandboxHelper userRootPath];
    NSError *error = nil;
    NSString *path = nil;
    if (userRootPath) {
        path = [userRootPath stringByAppendingPathComponent:@"ntes_record_video"];
        error = [NTESSandboxHelper createDirectoryWithPath:path];
    }
    
    return (error ? nil : path);
}

//用户输出根路径
+ (NSString *)videoOutputPath
{
    NSString *userRootPath = [NTESSandboxHelper userRootPath];
    NSError *error = nil;
    NSString *path = nil;
    if (userRootPath) {
        path = [userRootPath stringByAppendingPathComponent:@"ntes_output_video"];
        error = [NTESSandboxHelper createDirectoryWithPath:path];
    }
    
    return (error ? nil : path);
}

//创建目录
+ (NSError *)createDirectoryWithPath:(NSString *)path
{
    BOOL isDirectory = NO;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] || isDirectory == NO)
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"[NTESSandboxHelper] 视频根路径创建失败，%zi", error.code);
        }
        return error;
    }
    return nil;
}

//删除文件
+ (void)deleteFiles:(NSArray *)filePaths
{
    for (NSString *path in filePaths)
    {
        NSError *error = nil;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
        
        if (error)
        {
            NSLog(@"[NTESSandboxHelper] 文件[%@]删除失败，%zi", path, error.code);
        }
    }
}

+ (BOOL)fileIsExist:(NSString *)filePath
{
    BOOL isDir = NO;
    BOOL isExist = NO;
    if (filePath) {
        isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
        if (isDir) {
            isExist = NO;
        }
    }
    return isExist;
}

//文件大小
+ (long long) fileSizeAtPath:(NSString *)filePath
{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && !isDir) {
        return [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//清除录制文件
+ (void)clearRecordVideoPath
{
    NSArray *files = [NTESSandboxHelper queryPath:[NTESSandboxHelper videoRecordPath]];
    
    if (files && files.count != 0) {
        [NTESSandboxHelper deleteFiles:files];
    }
}

//清除输出文件
+ (void)clearOutputVideoPath
{
    NSArray *files = [NTESSandboxHelper queryPath:[NTESSandboxHelper videoOutputPath]];
    
    if (files && files.count != 0) {
        [NTESSandboxHelper deleteFiles:files];
    }
}

//清除缓存文件
+ (void)clearCacheVideoPath
{
    NSArray *files = [NTESSandboxHelper queryPath:[NTESSandboxHelper videoCachePath]];
    
    if (files && files.count != 0) {
        [NTESSandboxHelper deleteFiles:files];
    }
}

+  (NSArray *)videoRecordFiles
{
    return [NTESSandboxHelper queryPath:[NTESSandboxHelper videoRecordPath]];
}

+ (NSArray *)videoCachesFiles
{
    return [NTESSandboxHelper queryPath:[NTESSandboxHelper videoCachePath]];
}

+ (NSArray *)videoOutputFiles
{
    return [NTESSandboxHelper queryPath:[NTESSandboxHelper videoOutputPath]];
}

//清除所有文件
+ (void)clear
{
    [NTESSandboxHelper clearRecordVideoPath];
    
    [NTESSandboxHelper clearOutputVideoPath];
    
    [NTESSandboxHelper clearCacheVideoPath];
}

+ (NSArray *)queryPath:(NSString *)dirPath
{
    NSString *path = nil;
    NSMutableArray *videoPaths = [NSMutableArray array];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *directoryEnumerator;
    
    if (dirPath) {
        directoryEnumerator=[fileManger enumeratorAtPath:dirPath];
        
        while((path = [directoryEnumerator nextObject])!=nil)
        {
            NSString *absPath = [dirPath stringByAppendingPathComponent:path];
            [videoPaths addObject:absPath];
        }
    }
    
    return videoPaths;
}

@end
