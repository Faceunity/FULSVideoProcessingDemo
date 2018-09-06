//
//  LSMediaTranscodingParaCtx.h
//  LSMediaRecoderAndProcessor
//
//  Created by Netease on 17/7/11.
//  Copyright © 2017年 朱玲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LSMediaTranscodingDefs.h"

/**
 转码参数类
 */
@interface LSMediaTranscodingParaCtx : NSObject
@end

#pragma mark - 文件信息
/**
 文件信息类
 */
@interface LSInputFile : NSObject
/**
 文件路径
 */
@property (nonatomic, copy) NSString *filePath;
/**
 加速速率。（0.5 - 5.0，默认：1.0）
 */
@property (nonatomic, assign) Float64 speedRate;
/**
 加速开始时间。-1为全部加速。
 */
@property (nonatomic, assign) Float64 speedStartTimeS;
/**
 加速持续时间。-1为全部加速。
 */
@property (nonatomic, assign) Float64 speedDurationTimeS;
@end

#pragma mark - 水印信息
/**
 水印信息类
 */
@interface LSWaMarkRectInfo : NSObject
/**
 水印图片
 */
@property (nonatomic, strong) UIImage *waterMarkImage;
/**
 水印位置
 */
@property (nonatomic, assign) LSMediaTrascoidngWaterMarkLocation location;
/**
 当location为非rect模式时，uix，uiY为边距，距离边的距离，当rect模式，为水印的顶点
 */
@property (nonatomic, assign) unsigned int uiX;
/**
 距离边的距离
 */
@property (nonatomic, assign) unsigned int uiY;
/**
 宽度
 */
@property (nonatomic, assign) unsigned int uiWidth;
/**
 高度
 */
@property (nonatomic, assign) unsigned int uiHeight;
/**
 开始时间。
 */
@property (nonatomic, assign) unsigned int uiBeginTimeInSec;
/**
 持续时间。
 */
@property (nonatomic, assign) unsigned int uiDurationInSec;

@end

#pragma mark - 裁剪信息
/**
 裁剪信息类
 */
@interface LSVideoCropInfo : NSObject
/**
 x坐标
 */
@property (nonatomic, assign) unsigned int uiX;
/**
 y坐标
 */
@property (nonatomic, assign) unsigned int uiY;
/**
 宽度
 */
@property (nonatomic, assign) unsigned int uiWidth;
/**
 高度
 */
@property (nonatomic, assign) unsigned int uiHeight;

@end

#pragma mark - 文件信息
/**
 文件信息类
 */
@interface LSMediaFileInfo : NSObject
/**
 是否有视频轨道
 */
@property (nonatomic, assign) BOOL iHaveVideo;
/**
 视频时长
 */
@property (nonatomic, assign) int64_t iDurationMS;
/**
 文件码率
 */
@property (nonatomic, assign) int64_t iBitrateKb;
/**
 视频宽度
 */
@property (nonatomic, assign) int64_t iVideoWidth;
/**
 视频高度
 */
@property (nonatomic, assign) int64_t iVideoHeight;
/**
 视频帧率
 */
@property (nonatomic, assign) int64_t iVideoFrameRate;
/**
 视频码率
 */
@property (nonatomic, assign) int64_t iVideoBitrateKb;
/**
 视频旋转角度
 */
@property (nonatomic, assign) int64_t iVideoDegress;
/**
 视频的编码方式
 */
@property (nonatomic, assign) LSMediaCodecId videoCodecID;

/**
 是否有音频轨道
 */
@property (nonatomic, assign) BOOL iHaveAudio;
/**
 音频码率
 */
@property (nonatomic, assign) int64_t iAudioBitrateKb;
/**
 音频通道数
 */
@property (nonatomic, assign) int64_t iAudioNumOfChannels;
/**
 音频采样率
 */
@property (nonatomic, assign) int64_t iAudioSamplerate;
/**
 音频编码方式
 */
@property (nonatomic, assign) LSMediaCodecId audioCodecID;
/**
 是否可以用于合成
 */
@property (nonatomic, assign) BOOL isComposable;

@end
