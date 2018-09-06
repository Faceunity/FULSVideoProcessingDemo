//
//  NSString+NTES.h
//  ShortVideo_Demo
//
//  Created by Netease on 17/2/14.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSMediaRecordStatistics;

@interface NSString (NTES)

+ (NSString *)timeStringWithSecond:(NSInteger)second;

+ (NSString *)outputFileName;

+ (NSString *)documentDirectory;

+ (NSString *)documentSubDirectory:(NSString *)name;

- (CGFloat)heightWithWidth:(CGFloat)width;

+ (NSString *)infoStringWithLSMediaRecordStatistics:(LSMediaRecordStatistics *)pStatistic;

@end
