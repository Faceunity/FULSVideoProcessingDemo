//
//  NTESRecordDataCenter.m
//  ShortVideoProcess_Demo
//
//  Created by Netease on 17/3/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESRecordDataCenter.h"

@implementation NTESRecordDataCenter
@synthesize recordFilePaths = _recordFilePaths;
- (instancetype)init
{
    if (self = [super init]) {
        [self defaultRecordParaCtx];
        [self defaultRecordConfig];
    }
    return self;
}

+ (instancetype)shareInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESRecordDataCenter alloc] init];
    });
    return instance;
}

+ (void)clear
{
    [NTESSandboxHelper deleteFiles:[NTESRecordDataCenter shareInstance].recordFilePaths];
    [NTESRecordDataCenter shareInstance].recordFilePaths = nil;
    [[NTESRecordDataCenter shareInstance] defaultRecordConfig];
}

- (void)defaultRecordConfig
{
    _config = [[NTESRecordConfigEntity alloc] init];
    _config.exposureValue = 0.0;
    _config.beautyValue = 0.0;
    _config.beauty = YES;
    
    _config.filterDatas = @[@"无", @"黑白", @"自然", @"粉嫩", @"怀旧", @"自1", @"自2"];
    _config.curFilterIndex = _pRecordPara.sLSRecordVideoParaCtx.filterType;
    _config.sectionDatas = @[@(1), @(2), @(3)];
    _config.curSectionsIndex = 2; //3段
    _config.durationDatas = @[@(6), @(10), @(30)];
    _config.curDurationIndex = 1; //10s
    _config.resolutionDatas = @[@"标清", @"高清", @"超清", @"超高清"];
    _config.curResolutionIndex = 2; //超高清
    _config.scaleModeDatas = @[@"无", @"16:9", @"4:3", @"1:1"];
    _config.curScaleModeIndex = 1; //16:9
}

- (void)defaultRecordParaCtx
{
    _pRecordPara = [[LSMediaRecordingParaCtx alloc] init];
    
    _pRecordPara.eOutStreamType = LS_RECORD_AV; //这里可以设置音视频流／音频流／视频流
    
    //视频
    _pRecordPara.sLSRecordVideoParaCtx.fps = 30; //fps ,就是帧率，建议在10~24之间
    _pRecordPara.sLSRecordVideoParaCtx.bitrate = 10000000;
    _pRecordPara.sLSRecordVideoParaCtx.codec = LS_RECORD_VIDEO_CODEC_H264;
    _pRecordPara.sLSRecordVideoParaCtx.videoStreamingQuality = LS_RECORD_VIDEO_QUALITY_SUPER;
    _pRecordPara.sLSRecordVideoParaCtx.cameraPosition = LS_RECORD_CAMERA_POSITION_FRONT;
    _pRecordPara.sLSRecordVideoParaCtx.interfaceOrientation = LS_RECORD_CAMERA_ORIENTATION_PORTRAIT;
    _pRecordPara.sLSRecordVideoParaCtx.videoRenderMode = LS_RECORD_VIDEO_RENDER_MODE_SCALE_16_9;
    _pRecordPara.sLSRecordVideoParaCtx.filterType = LS_RECORD_GPUIMAGE_NORMAL;
    _pRecordPara.sLSRecordVideoParaCtx.isFrontCameraMirrored = YES;
    
    //音频
    _pRecordPara.sLSRecordAudioParaCtx.bitrate = 64000;
    _pRecordPara.sLSRecordAudioParaCtx.codec = LS_RECORD_AUDIO_CODEC_AAC;
    _pRecordPara.sLSRecordAudioParaCtx.frameSize = 2048;
    _pRecordPara.sLSRecordAudioParaCtx.numOfChannels = 1;
    _pRecordPara.sLSRecordAudioParaCtx.samplerate = 44100;
}

- (NSMutableArray<NSString *> *)recordFilePaths
{
    if (!_recordFilePaths) {
        _recordFilePaths = [NSMutableArray array];
    }
    return _recordFilePaths;
}

- (void)setRecordFilePaths:(NSMutableArray<NSString *> *)recordFilePaths
{
    _recordFilePaths = recordFilePaths;
    
    if (recordFilePaths == nil) {
        [NTESSandboxHelper clearRecordVideoPath];
    }
}
@end

@implementation NTESRecordConfigEntity
@end
