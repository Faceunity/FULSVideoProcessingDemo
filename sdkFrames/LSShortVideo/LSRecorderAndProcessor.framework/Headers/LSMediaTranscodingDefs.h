//
//  LSMediaTranscodingDef.h
//  LSMediaTranscoding
//
//  Created by NetEase on 2017/4/6.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#ifndef LSMediaTranscodingDef_h
#define LSMediaTranscodingDef_h

/**
 初始化失败原因key
 */
#define LS_Transcoding_Init_Error_Key              @"LSTranscodingInitErrorKey"

/**
 转码的视频质量
 */
typedef NS_ENUM(NSInteger,LSMediaTrascoidngVideoQuality)
{
    /**
     高质量
     */
    LS_TRANSCODING_VideoQuality_HIGH = 0,
    /**
     中高质量。（会增加转码时间）
     */
    LS_TRANSCODING_VideoQuality_INTERMEDIUM,
    /**
     中质量。（会改变输出分辨率）
     */
    LS_TRANSCODING_VideoQuality_MEDIUM,
    /**
     低质量。（会改变输出分辨率）
     */
    LS_TRANSCODING_VideoQuality_LOW,
};

/**
 水印位置信息
 */
typedef NS_ENUM(NSInteger,LSMediaTrascoidngWaterMarkLocation)
{
    /**
     由Rect指定水印添加位置
     */
    LS_TRANSCODING_WMARK_Rect = 0,
    /**
     左上
     */
    LS_TRANSCODING_WMARK_LeftUP,
    /**
     左下
     */
    LS_TRANSCODING_WMARK_LeftDown,
    /**
     右上
     */
    LS_TRANSCODING_WMARK_RightUP,
    /**
     右下
     */
    LS_TRANSCODING_WMARK_RightDown,
};

/**
 视频伸缩设置信息
 */
typedef NS_ENUM(NSInteger,LSMediaTrascoidngScaleVideoMode)
{
    /**
     随意伸缩，拉伸填充
     */
    LS_TRANSCODING_SCALE_VIDEO_MODE_FULL = 0,
    /**
     等比例伸缩，不足部分填黑边
     */
    LS_TRANSCODING_SCALE_VIDEO_MODE_FULL_BLACK
};

/**
 转码支持的音视频编解码器类型
 */
typedef NS_ENUM(NSInteger, LSMediaCodecId)
{
    /**
     目前尚不支持的音视频格式
     */
    LS_MEDIA_CODEC_ID_UNKNOW  =0,
    /**
     AAC编码
     */
    LS_MEDIA_CODEC_ID_AAC =1,
    /**
     H.264编码
     */
    LS_MEDIA_CODEC_ID_H264 =2,
    /**
     Mpeg4编码
     */
    LS_MEDIA_CODEC_ID_MPEG4= 3,
    /**
     mp3编码
     */
    LS_MEDIA_CODEC_ID_MP3=4,
};

/**
 转码错误信息
 */
typedef NS_ENUM(NSInteger, LSMediaTrascodingErrCode)
{
    /**
     无错误
     */
    LSMediaTrascodingErrCode_NO = 0,
    /**
     缺失错误
     */
    LSMediaTrascodingErrCode_MissingInOrOutFile,
    /**
     解析错误
     */
    LSMediaTrascodingErrCode_InputFileParseError,
    /**
     参数错误
     */
    LSMediaTrascodingErrCode_InputFileParamError,
    /**
     文件错误
     */
    LSMediaTrascodingErrCode_InputFileMediaFileError,
    /**
     转码错误
     */
    LSMediaTrascodingErrCode_TranscodingError
};

#endif /* LSMediaTranscodingDef_h */
