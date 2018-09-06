//
//  nMediaLiveStreamingDefs.h
//  livestream
//
//  Created by NetEase on 15/8/13.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#ifndef LSMediaCaptureDefs_h
#define LSMediaCaptureDefs_h

/**
 录制已经开始的通知
 */
#define LS_Recording_Started                     @"LSMediaRecrodingStarted"

/**
 录制已经结束的通知
 */
#define LS_Recording_Finished                    @"LSMediaRecordingFinished"

/**
 当前audio文件播放结束的通知
 */
#define LS_Recording_MusicFile_Eof               @"LSMeidaRecordingMusicFileEof"

/**
 初始化失败原因key
 */
#define LS_Recording_Init_Error_Key              @"LSRecordingInitErrorKey"

/**
 滤镜的类型
 */
typedef NS_ENUM(NSInteger, LSRecordGPUImageFilterType) {
    /**
     无滤镜
     */
    LS_RECORD_GPUIMAGE_NORMAL = 0,
    /**
     黑白
     */
    LS_RECORD_GPUIMAGE_SEPIA,
    /**
     自然
     */
    LS_RECORD_GPUIMAGE_ZIRAN,
    /**
     粉嫩
     */
    LS_RECORD_GPUIMAGE_MEIYAN1,
    /**
     怀旧
     */
    LS_RECORD_GPUIMAGE_MEIYAN2,
    /**
     自定义
     */
    LS_RECORD_GPUIMAGE_CUSTOM
};

/**
 水印添加位置
 */
typedef NS_ENUM(NSInteger, LSRecordWaterMarkLocation) {
    /**
     由rect的origin定位置
     */
    LS_RECORD_WATERMARK_LOCATION_RECT = 0,
    /**
     左上
     */
    LS_RECORD_WATERMARK_LOCATION_LEFTUP,
    /**
     左下
     */
    LS_RECORD_WATERMARK_LOCATION_LEFTDOWN,
    /**
     右上
     */
    LS_RECORD_WATERMARK_LOCATION_RIGHTUP,
    /**
     右下
     */
    LS_RECORD_WATERMARK_LOCATION_RIGHTDOWN,
    /**
     中间
     */
    LS_RECORD_WATERMARK_LOCATION_CENTER,
};

/**
 录制音频编码器
 */
typedef NS_ENUM(NSInteger, LSRecordVideoCodecType) {
    /**
     H.264 编码
     */
    LS_RECORD_VIDEO_CODEC_H264 = 0,
};

/**
 录制视频编码器
 */
typedef NS_ENUM(NSInteger, LSRecordAudioCodecType) {
    /**
     AAC 编码
     */
    LS_RECORD_AUDIO_CODEC_AAC = 0,
};

/**
 录制视频的输出格式
 */
typedef NS_ENUM(NSInteger, LSRecordVideoOutputMode) {
    /**
     RGB
     */
    LS_RECORD_VIDEO_RGB = 0,
    /**
     YUV-420F
     */
    LS_RECORD_VIDEO_YUV_420F,
    /**
     YUV-420V
     */
    LS_RECORD_VIDEO_YUV_420V,
};

/**
 摄像采集方向
 */
typedef NS_ENUM(NSInteger, LSRecordCameraOrientation) {
    /**
     垂直
     */
    LS_RECORD_CAMERA_ORIENTATION_PORTRAIT = 0,
    /**
     倒立
     */
    LS_RECORD_CAMERA_ORIENTATION_UPDOWN,
    /**
     左转
     */
    LS_RECORD_CAMERA_ORIENTATION_RIGHT,
    /**
     右转
     */
    LS_RECORD_CAMERA_ORIENTATION_LEFT
};

/**
 录制的旋转角度
 */
typedef NS_ENUM(NSInteger, LSRecordRotation) {
    /**
     无旋转
     */
    LS_RECORD_ROTATION_NONE = 0,
    /**
     顺时针90度旋转
     */
    LS_RECORD_ROTATION_90,
    /**
     顺时针180度旋转
     */
    LS_RECORD_ROTATION_180,
    /**
     顺时针270度旋转
     */
    LS_RECORD_ROTATION_270
};

/**
 录制视频流质量
 */
typedef NS_ENUM(NSInteger, LSRecordVideoStreamingQuality) {
    /**
     视频分辨率：标清 (640*480).
     */
    LS_RECORD_VIDEO_QUALITY_NORMAL = 0,
    /**
     视频分辨率：高清 (960*540).
     */
    LS_RECORD_VIDEO_QUALITY_HIGH,
    /**
     视频分辨率：超清 (1280*720).
     */
    LS_RECORD_VIDEO_QUALITY_SUPER,
    /**
     视频分辨率：超高清 (1920*1080).
     */
    LS_RECORD_VIDEO_QUALITY_SUPER_HIGH,
};

/**
 摄像头方向
 */
typedef NS_ENUM(NSInteger, LSRecordCameraPosition) {
    /**
     后置摄像头.
     */
    LS_RECORD_CAMERA_POSITION_BACK = 0,
    /**
     前置摄像头.
     */
    LS_RECORD_CAMERA_POSITION_FRONT
};

/**
 视频显示模式
 */
typedef NS_ENUM(NSInteger, LSRecordVideoRenderScaleMode) {
    /**
     采集多大分辨率，则显示多大分辨率
     */
    LS_RECORD_VIDEO_RENDER_MODE_SCALE_NONE = 0,
    /**
     无论采集多大分辨率，显示比例为16:9
     */
    LS_RECORD_VIDEO_RENDER_MODE_SCALE_16_9,
    /**
     无论采集多大分辨率，显示比例为4:3
     */
    LS_RECORD_VIDEO_RENDER_MODE_SCALE_4_3,
    /**
     无论采集多大分辨率，显示比例为1:1,小边优先
     */
    LS_RECORD_VIDEO_RENDER_MODE_SCALE_1_1,
};

/**
 录制的流类型
 */
typedef NS_ENUM(NSInteger, LSRecordStreamType) {
    /**
     录制音频流
     */
    LS_RECORD_AUDIO = 0,
    /**
     录制视频流
     */
    LS_RECORD_VIDEO,
    /**
     录制音视频流
     */
    LS_RECORD_AV
};

/**
 日志等级
 */
typedef NS_ENUM(NSInteger, LSMediaRecordLogLevel) {
    /**
     log输出模式：不输出
     */
    LS_RECORD_LOG_QUIET       = 0x00,
    /**
     log输出模式：输出错误
     */
    LS_RECORD_LOG_ERROR       = 1 << 0,
    /**
     log输出模式：输出警告
     */
    LS_RECORD_LOG_WARNING     = 1 << 1,
    /**
     log输出模式：输出信息
     */
    LS_RECORD_LOG_INFO        = 1 << 2,
    /**
     log输出模式：输出调试信息
     */
    LS_RECORD_LOG_DEBUG       = 1 << 3,
    /**
     log输出模式：输出详细
     */
    LS_RECORD_LOG_DETAIL      = 1 << 4,
    /**
     log输出模式：保留
     */
    LS_RECORD_LOG_RESV        = 1 << 5,
    /**
     log输出模式：保留
     */
    LS_RECORD_LOG_LEVEL_COUNT = 6,
    /**
     log输出模式：默认输出警告
     */
    LS_RECORD_LOG_DEFAULT     = LS_RECORD_LOG_WARNING
};


#endif
