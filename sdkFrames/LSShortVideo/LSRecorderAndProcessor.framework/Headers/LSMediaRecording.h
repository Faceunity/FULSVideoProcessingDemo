//
//  lsMediaCapture.h
//  lsMediaCapture
//
//  Created by NetEase on 15/8/12.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//  类LSMediacapture，用于录制

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LSMediaRecordingParaCtx.h"

@class GPUImageFilter;

/**
 录制核心类
 */
@interface LSMediaRecording : NSObject

/**
 统计结果回调
 */
@property (nonatomic,copy) void (^onStatisticInfoGot)(LSMediaRecordStatistics* statistics);

/**
 过程中发生错误的回调
 */
@property (nonatomic,copy) void (^onLiveStreamError)(NSError *error);

#pragma mark - 初始化相关

/**
 清除缓存，如果和转码sdk一同使用，请在最后释放的类中调用。
 */
+ (void)cleanGPUCache;

/**
 *  初始化mediacapture
 *
 *  @return LSMediaCapture
 */
- (instancetype)init NS_UNAVAILABLE;


/**
 @brief 初始化 mediacapture
 @param appKey appKey
 @param error 错误原因
 @return 实例
 */
- (instancetype)initLiveStreamWithAppKey:(NSString *)appKey error:(NSError **)error;

/**
 *  @brief 初始化mediacapture
 *  @param  videoParaCtx 录制视频参数
 *  @param  appKey appKey
 *  @param error 错误原因
 *  @return LSMediaCapture
 */
- (instancetype)initLiveStreamWithVideoParaCtx:(LSRecordVideoParaCtx*)videoParaCtx
                                        appKey:(NSString *)appKey
                                         error:(NSError **)error;

/**
 *  @brief 初始化mediacapture
 *  @param  lsParaCtx 录制参数
 *  @param  appKey appKey
 *  @param  error 错误原因
 *  @return LSMediaCapture
 */
- (instancetype)initLiveStreamWithLivestreamParaCtx:(LSMediaRecordingParaCtx*)lsParaCtx
                                             appKey:(NSString *)appKey
                                              error:(NSError **)error;

#pragma mark - 预览相关
/**
 *  @brief 打开视频预览
 *  @param  preview 预览窗口
 *  @discussion 在ipad3上，前置摄像头的分辨率不支持960*540的高分辨率,不建议在ipad上使用前置摄像头进行高清分辨率采集
 */
-(void)startVideoPreview:(UIView*)preview;

/**
 *  @brief 暂停视频预览
 *  @discussion 如果正在录制 ，则同时关闭视频预览以及视频录制
 */
-(void)pauseVideoPreview;

/**
 *  @brief 恢复视频预览
 *  @discussion 如果正在录制 ，则开始视频录制
 */
-(void)resumeVideoPreview;

/**
 *  @brief 获取视频截图
 *  @param completionBlock 获取最新一幅视频图像的回调
 */
- (void)snapShotWithCompletionBlock:(void(^)(UIImage* image))completionBlock;


/**
 *  @brief 切换前后摄像头
 *  @return 当前摄像头的位置，前或者后
 */
- (LSRecordCameraPosition)switchCamera;

#pragma mark - 水印相关
/**
 * @brief 添加静态视频水印
 * @param image 静态图像
 * @param rect 具体位置和大小
 * @param location 位置
 */
- (void)addWaterMark:(UIImage*)image
                rect:(CGRect)rect
            location:(LSRecordWaterMarkLocation)location;

/**
 * @brief 关闭本地预览静态水印
 * @param isClosed 是否关闭
 */
- (void)closePreviewWaterMark:(BOOL)isClosed;

/**
 * @brief添加动态视频水印
 * @param imageArray 动态图像数组
 * @param count 播放速度的快慢:count代表count帧一张图
 * @param looped 是否循环，不循环就显示一次
 * @param rect 具体位置和大小（x，y根据location位置，计算具体的位置信息）
 * @param location 位置
 */
- (void)addDynamicWaterMarks:(NSArray*)imageArray
                    fpsCount:(unsigned int)count
                        loop:(BOOL)looped
                        rect:(CGRect)rect
                    location:(LSRecordWaterMarkLocation)location;

/**
 * @brief 关闭本地预览动态水印
 * @param isClosed 是否关闭
 */
- (void)closePreviewDynamicWaterMark:(BOOL)isClosed;

/**
 清除水印
 */
- (void)cleanWaterMark;

#pragma mark - 分辨率、帧率、裁剪
/**
 * @brief 录制的视频分辨率、码率、帧率设置， 开始录制之前可以设置
 * @param videoResolution 分辨率
 * @param bitrate 录制码率
 * @param fps 录制帧率
 */
-(void)setVideoParameters:(LSRecordVideoStreamingQuality)videoResolution
                  bitrate:(int)bitrate
                      fps:(int)fps;

/**
 *  @brief 视频分辨率选择，开始录制之前可以设置
 */
@property(nonatomic,assign)LSRecordVideoStreamingQuality videoQuality;

/**
 *  @brief 视频比例选择，开始录制之前可以设置
 */
@property(nonatomic,assign)LSRecordVideoRenderScaleMode videoScaleMode;

#pragma mark - 摄像头相关
/**
 * @brief  手动聚焦点，开始录制之前可以设置
 */
@property(nonatomic,assign)CGPoint focusPoint;

/**
 * @brief 闪光灯。YES:开 NO:关
 */
@property (nonatomic, assign)BOOL flash;

/**
 * @brief 摄像头最大变焦倍数，只读。
 */
@property (nonatomic, assign, readonly) CGFloat maxZoomScale;

/**
 * @brief  摄像头变焦倍数。[1 ～ maxZoomScale]，default:1
 */
@property (nonatomic, assign) CGFloat zoomScale;

/**
 * @brief  摄像头曝光补偿属性：在摄像头曝光补偿最大最小范围内改变曝光度。value : [-1 ~ 1], defaule: 0
 */
@property(nonatomic,assign) float exposureValue;

#pragma mark - 滤镜相关
/**
 *  @brief 滤镜类型设置。
 *  @discussion value : 取值参见LSRecordGPUImageFilterType。default:LS_RECORD_GPUIMAGE_NORMAL
 */
@property (nonatomic, assign) LSRecordGPUImageFilterType filterType;


/**
 *  @brief 设置磨皮滤镜的强度。仅支持NMCGPUImageZiran，NMCGPUImageMeiyan1，NMCGPUImageMeiyan2
 *  @discussion 取值 value :  [0 ~ 1], default: 0
 */
@property (nonatomic, assign) float smoothFilterIntensity;

/**
 *  @brief 设置美白滤镜强度,只支持NMCGPUImageZiran NMCGPUImageMeiyan1 NMCGPUImageMeiyan2
 *  @discussion 取值 value : [0 ~ 1], default 0
 */
@property (nonatomic, assign) float whiteningFilterIntensity;

#pragma mark - 录制相关
/**
 * @brief 录制的旋转角度，顺时针方向。
 */
@property (nonatomic, assign) LSRecordRotation recordRotation;

/**
 * @brief 分镜保存的根路径(默认路径 Documents/videos)
 */
@property (nonatomic, copy) NSString *recordFileSavedRootPath;

/**
 * @brief 分镜保存的mp4地址，只读
 */
@property (nonatomic, copy, readonly) NSString *recordFilePath;

/**
 *  @brief 开始录制
 *  @discussion 收到LS_Recording_Started消息后，录制才真正开始。
 *  @return 具体错误，无错误返回nil
 */
- (NSError *)startLiveStream;

/**
 *  @brief 结束录制
 *  @discussion 收到LS_Recording_Finished消息后，录制才真正结束，才可以关闭。
 *  @return 具体错误，无错误返回nil
 */
-(NSError *)stopLiveStream;

#pragma mark - 混音相关
/**
 *   @brief 开始播放混音文件
 *   @param musicURL 音频文件地址/文件名
 *   @param enableLoop 当前音频文件是否单曲循环
 *   @return YES:成功  NO:失败
 */
- (BOOL)startPlayMusic:(NSString*)musicURL withEnableSignleFileLooped:(BOOL)enableLoop;

/**
 *   @brief 结束播放混音文件，释放播放文件
 */
- (BOOL)stopPlayMusic;

/**
 *   @brief 继续播放混音文件
 */
- (BOOL)resumePlayMusic;

/**
 *   @brief 暂停播放混音文件
 */
- (BOOL)pausePlayMusic;

/**
 @brief seek伴音文件
 @param frameIndex 目标帧序号
 */
- (void)seekMusicToFrameIndex:(SInt64)frameIndex;

/**
 @brief 当前播放伴音的帧序号
 */
@property (nonatomic, readonly) SInt64 curMusicFrameIndex;

/**
 @brief 伴音音量
 */
@property (nonatomic, assign) CGFloat musicVolume;

/**
 @brief 麦克风采集音量
 */
@property (nonatomic, assign) CGFloat microphoneVolume;

#pragma mark - 日志和版本号
/**
 *  @brief 设置日志级别
 *  @param logLevel 信息的级别
 */
+ (void)setLogLevel:(LSMediaRecordLogLevel)logLevel;

/**
 *  @brief 获取当前sdk的版本号
 *  @return 版本号
 */
+ (NSString *)SDKVersion;

#pragma mark - 扩展接口
/**
 *   @brief 添加自定义滤镜。default:nil
 */
@property (nonatomic, strong) GPUImageFilter *customFilter;

/**
 * @brief 美颜开关。指在定义滤镜上是否再叠加sdk提供的自然滤镜。default:NO
 * @discussion 1）YES:自定义滤镜（如果有）＋ 自然滤镜(LS_RECORD_GPUIMAGE_ZIRAN)。2）NO: 自定义滤镜（如果有）＋ 普通滤镜(LS_RECORD_GPUIMAGE_NORMAL)。
 */
@property(nonatomic,assign)BOOL isBeautyFilterOn;

/**
 * @brief 用户可以通过这个接口，将处理完的数据送回来，由视频云sdk录制出去
 * @param sampleBuffer 采集到的数据结构体
 */
- (void)externalInputVideoFrame:(CMSampleBufferRef)sampleBuffer;

/**
 * @brief 获取最新一帧视频截图后的回调
 * @discussion pixelBuf 采集到的数据结构体
 */
@property (nonatomic,copy) void (^externalVideoFrameCallback)(CMSampleBufferRef pixelBuf);

@end

