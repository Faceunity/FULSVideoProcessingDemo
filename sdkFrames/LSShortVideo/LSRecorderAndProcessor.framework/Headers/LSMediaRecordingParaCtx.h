//
//  LSMediaRecordingParaCtx.h
//  LSMediaRecoderAndProcessor
//
//  Created by Netease on 17/7/10.
//  Copyright © 2017年 朱玲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSMediaRecordingDefs.h"

@class LSRecordVideoParaCtx;
@class LSRecordAudioParaCtx;

/**
 录制参数类
 */
@interface LSMediaRecordingParaCtx : NSObject

/**
 录制的类型。音视频，视频，音频。
 */
@property (nonatomic, assign) LSRecordStreamType eOutStreamType;

/**
 视频相关参数类
 */
@property (nonatomic, strong) LSRecordVideoParaCtx *sLSRecordVideoParaCtx;

/**
 音频相关参数类
 */
@property (nonatomic, strong) LSRecordAudioParaCtx *sLSRecordAudioParaCtx;

/**
 默认参数

 @return 参数类实例
 */
+ (instancetype)defaultPara;

@end


/**
 录制视频参数类
 */
@interface LSRecordVideoParaCtx : NSObject

/**
 帧率
 */
@property (nonatomic, assign) NSInteger fps;

/**
 码率
 */
@property (nonatomic, assign) NSInteger bitrate;

/**
 视频编码器
 */
@property (nonatomic, assign) LSRecordVideoCodecType codec;

/**
 视频分辨率
 */
@property (nonatomic, assign) LSRecordVideoStreamingQuality videoStreamingQuality;

/**
 视频采集前后摄像头
 */
@property (nonatomic, assign) LSRecordCameraPosition cameraPosition;

/**
 视频采集方向
 */
@property (nonatomic, assign) LSRecordCameraOrientation interfaceOrientation;

/**
 视频输出格式
 */
@property (nonatomic, assign) LSRecordVideoOutputMode videoOutputMode;

/**
 视频显示端比例16:9
 */
@property (nonatomic, assign) LSRecordVideoRenderScaleMode videoRenderMode;

/**
 滤镜类型
 */
@property (nonatomic, assign) LSRecordGPUImageFilterType filterType;

/**
 是否镜像前置摄像头
 */
@property (nonatomic, assign) BOOL isFrontCameraMirrored;

/**
 默认参数

 @return 参数类实例
 */
+ (instancetype)defaultPara;

@end

/**
 录制音频参数类
 */
@interface LSRecordAudioParaCtx : NSObject
/**
 音频的样本采集率.
 */
@property (nonatomic, assign) NSInteger samplerate;

/**
 音频采集的通道数：单声道，双声道.
 */
@property (nonatomic, assign) NSInteger numOfChannels;

/**
 音频采集的帧大小.
 */
@property (nonatomic, assign) NSInteger frameSize;

/**
 音频编码码率.
 */
@property (nonatomic, assign) NSInteger bitrate;

/**
 音频编码器.
 */
@property (nonatomic, assign) LSRecordAudioCodecType codec;

/**
 默认参数

 @return 参数类实例
 */
+ (instancetype)defaultPara;

@end

/**
 统计类
 */
@interface LSMediaRecordStatistics : NSObject

/**
 采集帧率
 */
@property (nonatomic, assign) NSUInteger videoCaptureFrameRate;

/**
 滤镜帧率
 */
@property (nonatomic, assign) NSUInteger videoFilteredFrameRate;

/**
 发送帧率
 */
@property (nonatomic, assign) NSUInteger videoSendFrameRate;

/**
 发送码率
 */
@property (nonatomic, assign) NSUInteger videoSendBitRate;

/**
 发送视频宽度
 */
@property (nonatomic, assign) NSUInteger videoSendWidth;

/**
 发送视频高度
 */
@property (nonatomic, assign) NSUInteger videoSendHeight;

/**
 设置的帧率
 */
@property (nonatomic, assign) NSUInteger videoSetFrameRate;

/**
 设置的码率
 */
@property (nonatomic, assign) NSUInteger videoSetBitRate;

/**
 设置的视频宽度
 */
@property (nonatomic, assign) NSUInteger videoSetWidth;

/**
 设置的视频高度
 */
@property (nonatomic, assign) NSUInteger videoSetHeight;

/**
 音频发送的帧率
 */
@property (nonatomic, assign) NSUInteger audioSendBitRate;

@end
