//
//  NSString+NTES.m
//  ShortVideo_Demo
//
//  Created by Netease on 17/2/14.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NSString+NTES.h"
#import "NSDate+NSDateFormatter.h"

@implementation NSString (NTES)

+ (NSString *)timeStringWithSecond:(NSInteger)second
{
    NSInteger seconds = second % 60;
    NSInteger minutes = (second / 60) % 60;
    NSInteger hours = second / 3600;
    
    if (hours != 0)
    {
        return [NSString stringWithFormat:@"%02zi:%02zi:%02zi",hours, minutes, seconds];
    }
    else
    {
        return [NSString stringWithFormat:@"%02zi:%02zi",minutes, seconds];
    }
}

+ (NSString *)outputFileName
{
    NSDate *date = [NSDate date];
    NSString *dateStr = [date stringWithFormat:@"yyyyMMddHHmmss"];
    return [NSString stringWithFormat:@"%@.mp4", dateStr];
}

+ (NSString *)documentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *rootPath = [paths firstObject];
    return rootPath;
}

+ (NSString *)documentSubDirectory:(NSString *)name;
{
    NSString *docDir = [NSString documentDirectory];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", docDir, name];
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]
        || !isDirectory)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

- (CGFloat)heightWithWidth:(CGFloat)width
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    CGSize sizeToFit = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:dic
                                          context:nil].size;
    return sizeToFit.height;
}

+ (NSString *)infoStringWithLSMediaRecordStatistics:(LSMediaRecordStatistics *)pStatistic
{
    NSString* statInfo = @"";
    if (pStatistic)
    {
        NSString* filterFps = [[NSString alloc]initWithFormat:@"滤镜帧率: %d", (unsigned int)pStatistic.videoFilteredFrameRate];
        NSString* encoderFps = [[NSString alloc]initWithFormat:@"编码帧率: %d", (unsigned int)pStatistic.videoSendFrameRate];
        NSString* bitrate = [[NSString alloc]initWithFormat:@"码率: %d",(unsigned int) pStatistic.videoSendBitRate];
        NSString* videoQuality = [[NSString alloc]initWithFormat:@"分辨率: %d x %d",
                                  (unsigned int)pStatistic.videoSendWidth, (unsigned int)pStatistic.videoSendHeight];
        statInfo = [[NSString alloc] initWithFormat:@" %@\n %@\n %@\n %@",
                    videoQuality, filterFps,encoderFps,bitrate];
    }
    return statInfo;
}

@end
