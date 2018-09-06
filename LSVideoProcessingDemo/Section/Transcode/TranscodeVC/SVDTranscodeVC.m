//
//  SVDTranscodeVC.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDTranscodeVC.h"
#import "SVDTranscodeView.h"
#import "SVDOutputFileConfigVC.h"
#import "SVDSystemPlayer.h"
#import "SVDInputFileModel.h"

@interface SVDTranscodeVC ()<SVDTranscodeViewProtocol>

@property (nonatomic, strong) SVDTranscodeView *trancodeView;

@property (nonatomic, strong) NSArray <SVDInputFileModel *> *mainInputFiles;
@property (nonatomic, strong) NSString *secInputFile;
@property (nonatomic, strong) SVDOutputFileConfigModel *outputConfig;
@property (nonatomic, strong) NSString *outputPath;

@property (nonatomic,strong)LSMediaTranscoding* transc;
@property (strong,nonatomic)dispatch_queue_t transcodingQueue;

@property (nonatomic, copy) SVDTranscodeFileInfoBlock fileInfoBlock;
@property (nonatomic, strong) dispatch_semaphore_t infoSem;
@end

@implementation SVDTranscodeVC

- (void)dealloc {
    NSLog(@"[转码测试Demo] SVDTranscodeVC 释放!");
}

- (instancetype)init
{
    if (self = [super init]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self setupTranscode];
        });
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _trancodeView.frame = CGRectMake(0, 8.0, self.view.width, self.view.height - 8.0);
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.trancodeView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_transc interruptTranscoding];
}

#pragma mark - 转码SDK
- (void)setupTranscode {
    NSError *error = nil;
    
    //不输出sdk日志
    //[LSMediaTranscoding setLogLevel:LS_RECORD_LOG_QUIET];
    
    NSLog(@"[转码测试Demo] SDK Version : [%@]", [LSMediaTranscoding SDKVersion]);
    
    _transc = [[LSMediaTranscoding alloc] initWithAppKey:NTES_TEST_APP_KEY error:&error];
    if (error) {
        NSString *msg = error.userInfo[LS_Transcoding_Init_Error_Key];
        [UIAlertView showMessage:msg];
    }

    _transcodingQueue = dispatch_queue_create("LSTranscoding", NULL);
    _infoSem = dispatch_semaphore_create(1);
}

- (void)doConfigTranscode {
    //输入输出文件
    NSMutableArray *files = [NSMutableArray array];
    [_mainInputFiles enumerateObjectsUsingBlock:^(SVDInputFileModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSInputFile *inputFile = [[LSInputFile alloc] init];
        inputFile.filePath = obj.filePath;
        inputFile.speedRate = obj.speed;
        inputFile.speedStartTimeS = obj.speedBegin;
        inputFile.speedDurationTimeS = obj.speedDuration;
        [files addObject:inputFile];
    }];
    _transc.inputExtendMainFiles = files;
    _transc.inputSecondaryFileName = _secInputFile;
    _transc.outputFileName = _outputPath;
    
    //转码各种信息设置 用户设置
    _transc.videoEncodedWidth        = (unsigned int)_outputConfig.videoWidth;
    _transc.videoEncodedHeight       = (unsigned int)_outputConfig.videoHeight;
    _transc.scaleVideoMode = _outputConfig.videoScaleMode;
    _transc.videoQuality = _outputConfig.videoQuality;
    
    //截断
    if (_outputConfig.isNeedCut)
    {
        _transc.beginTimeS               = (unsigned int)_outputConfig.begineTimeS;
        _transc.durationTimeS            = (unsigned int)_outputConfig.durationS;
    }
    
    //裁剪
    if (_outputConfig.isNeedCrop)
    {
        LSVideoCropInfo *cropInfo = [[LSVideoCropInfo alloc] init];
        cropInfo.uiX = (unsigned int)_outputConfig.cropX;
        cropInfo.uiY = (unsigned int)_outputConfig.cropY;
        cropInfo.uiWidth = (unsigned int)_outputConfig.cropW;
        cropInfo.uiHeight = (unsigned int)_outputConfig.cropH;
        _transc.cropInfo = cropInfo;
    }
    
    //水印
    if (_outputConfig.isNeedWaterMark)
    {
        
        LSWaMarkRectInfo *waterMarkInfo = [[LSWaMarkRectInfo alloc] init];
        waterMarkInfo.location = _outputConfig.location;
        waterMarkInfo.uiHeight = (unsigned int)_outputConfig.uiHeight;
        waterMarkInfo.uiWidth =  (unsigned int)_outputConfig.uiWidth;
        waterMarkInfo.uiX = (unsigned int)_outputConfig.uiX;
        waterMarkInfo.uiY = (unsigned int)_outputConfig.uiY;
        waterMarkInfo.uiBeginTimeInSec = (unsigned int)_outputConfig.uiBeginTime;
        waterMarkInfo.uiDurationInSec = (unsigned int)_outputConfig.uiDuration;
        waterMarkInfo.waterMarkImage = [UIImage imageNamed:@"1"];
        
//        NSMutableArray *infos = [NSMutableArray array];
//        for (NSInteger i = 0; i < 1; i++)
//        {
//            if (i %2 == 0)
//            {
//                waterMarkInfo.waterMarkImage = [UIImage imageNamed:@"1"];
//            }
//            else
//            {
//                waterMarkInfo.waterMarkImage = [UIImage imageWithText:@"我是字幕" width:200];
//            }
//
//            [infos addObject:waterMarkInfo];
//        }
        _transc.waterMarkInfos = @[waterMarkInfo];
    }
    
    //音频及特效
    _transc.videoFadeInOutDurationS  = (unsigned int)_outputConfig.videoFadeDurationS;
    _transc.audioFadeInOutDurationS = (unsigned int)_outputConfig.audioFadeDurationS;
    _transc.videoFadeInOutMinOpacity = _outputConfig.videoFadeOpacity;
    _transc.intensityOfMainAudioVolume = _outputConfig.mainVolumeIntensity;
    _transc.intensityOfSecondAudioVolume = _outputConfig.audioVolumeIntensity;
    _transc.isMuted = _outputConfig.isMute;
    _transc.isMixMainFileMusic = _outputConfig.isMixedMainAudio;
    
    //滤镜
    _transc.brightness = _outputConfig.brightness;
    _transc.contrast = _outputConfig.contrast;
    _transc.saturation = _outputConfig.saturation;
    _transc.sharpness = _outputConfig.sharpness;
    _transc.hue = _outputConfig.hue;
    _transc.filterType = _outputConfig.filterType;
    _transc.whiteningFilterIntensity = _outputConfig.whiting;
    _transc.smoothFilterIntensity = _outputConfig.smooth;
}

- (void)doInvertStopTranscode {
    NSLog(@"[转码测试Demo] 停止视频逆序转码");
    [_transc interruptInvertedVideo];
}

- (void)doInvertStartTranscode {
    
    NSLog(@"[转码测试Demo] 开始视频逆序转码");
    
    _trancodeView.isInverting = YES;
    
    [self doConfigTranscode];
    
    __weak typeof(self) weakSelf = self;
    _transc.LSInvertedProgress = ^(float progress) {
        //更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.trancodeView.processValue = progress;
        });
    };
    
    _transc.invertedSpeed = _trancodeView.invertSpeedValue;
    [_transc doInvertedVideo:_outputPath complete:^(NSError *error, NSString *output) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"转码失败：%@", error);
            }
            else {
                if (output) {
                    NSLog(@"转码完成:%@", output);
                }
                else {
                    NSLog(@"转码取消");
                }
            }
            [weakSelf.trancodeView upedatePlayState];
            weakSelf.trancodeView.isInverting = NO;
        });
    }];
    
}

- (void)doStartTranscode {
    
    _trancodeView.isTranscoding = YES;
    
    NSLog(@"[转码测试Demo] 开始转码");
    
    [self doConfigTranscode];
    
    __weak typeof(self) weakSelf = self;
    _transc.LSMediaTransProgress = ^(float progress){
        
        //更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.trancodeView.processValue = progress;
        });
    };
    
    dispatch_async(_transcodingQueue, ^(void)
                   {
                       [weakSelf.transc doTranscoding:^(NSError *error, NSString *output) {
                           //更新UI状态
                           dispatch_async(dispatch_get_main_queue(), ^{
                               if (error)
                               {
                                   NSLog(@"转码失败.[%@]", error);
                                   [weakSelf.view makeToast:@"转码失败" duration:2 position:CSToastPositionCenter];
                                   weakSelf.trancodeView.processValue = 0.0;
                               }
                               [weakSelf.trancodeView upedatePlayState];
                                weakSelf.trancodeView.isTranscoding = NO;
                           });
                       }];
                   });
}

- (void)doStopTranscode {
    NSLog(@"[转码测试Demo] 停止转码");
    [_transc interruptTranscoding];
}

- (void)transcodeGetFileInfo:(NSString *)filePath Complete:(SVDTranscodeFileInfoBlock)complete {
    
    dispatch_semaphore_wait(_infoSem, DISPATCH_TIME_FOREVER);
    _fileInfoBlock = [complete copy];
    __weak typeof(self) weakSelf = self;
    [_transc getinputFileInfo:filePath infoBlock:^(NSError *error, LSMediaFileInfo *info) {
        NSString *infoStr = [weakSelf fileInfoStringWithInfo:info];
        weakSelf.fileInfoBlock(infoStr);
        dispatch_semaphore_signal(weakSelf.infoSem);
    }];
}

- (NSString *)fileInfoStringWithInfo:(LSMediaFileInfo *)info
{
    const char *iHaveVideoS =      [[NSString stringWithFormat:@"iHaveVideo:      %10s", info.iHaveVideo ? "Y" : "N"] UTF8String];
    const char *iDurationMSS =     [[NSString stringWithFormat:@"iDurationMS:  %10lld", info.iDurationMS] UTF8String];
    const char *iBitrateKbS =      [[NSString stringWithFormat:@"iBitrateKb:   %12lld", info.iBitrateKb] UTF8String];
    const char *iVideoWidthS =     [[NSString stringWithFormat:@"iVideoWidth: %10lld", info.iVideoWidth] UTF8String];
    const char *iVideoHeightS =    [[NSString stringWithFormat:@"iVideoHeight:%10lld", info.iVideoHeight] UTF8String];
    const char *iVideoFrameRateS = [[NSString stringWithFormat:@"iVideoFrameRate:%7lld", info.iVideoFrameRate] UTF8String];
    const char *iVideoDegressS =   [[NSString stringWithFormat:@"iVideoDegress:%10lld", info.iVideoDegress] UTF8String];
    
    const char *videoCodecIDS =        [[NSString stringWithFormat:@"videoCodecID : %zi", info.videoCodecID] UTF8String];
    const char *iHaveAudioS =          [[NSString stringWithFormat:@"iHaveAudio : %@", info.iHaveAudio ? @"Y" : @"N"] UTF8String];
    const char *iAudioBitrateKbS =     [[NSString stringWithFormat:@"iAudioBitrateKb : %lld", info.iAudioBitrateKb] UTF8String];
    const char *iAudioNumOfChannelsS = [[NSString stringWithFormat:@"iAudioNumOfChannels : %lld", info.iAudioNumOfChannels] UTF8String];
    const char *iAudioSamplerateS =    [[NSString stringWithFormat:@"iAudioSamplerate : %lld", info.iAudioSamplerate] UTF8String];
    const char *audioCodecIDS =        [[NSString stringWithFormat:@"audioCodecID : %zi", info.audioCodecID] UTF8String];
    const char *isComposableS =        [[NSString stringWithFormat:@"isComposable : %@", info.isComposable ? @"Y" : @"N"] UTF8String];
    
    NSString *ret = [NSString stringWithFormat:@"%s\t\t%s\n%s\t\t%s\n%s\t\t%s\n%s\t\t%s\n%s\t\t%s\n%s\t\t%s\n%s\t\t%s\n",
                     iHaveVideoS,      iHaveAudioS,
                     iDurationMSS,     iAudioBitrateKbS,
                     iBitrateKbS,      iAudioNumOfChannelsS,
                     iVideoWidthS,     iAudioSamplerateS,
                     iVideoHeightS,    audioCodecIDS,
                     iVideoFrameRateS, videoCodecIDS,
                     iVideoDegressS,   isComposableS];
    return ret;
}

#pragma mark - <SVDTranscodeViewProtocol>
- (void)TranscodeViewPlayAction:(SVDTranscodeView *)view {
    [SVDSystemPlayer playWithFilePath:view.dstFilePath];
}

- (void)TranscodeViewStartAction:(SVDTranscodeView *)view {
    //输入主文件
    if (_delegate && [_delegate respondsToSelector:@selector(TranscodeGetMainInputFiles)]) {
        _mainInputFiles = [_delegate TranscodeGetMainInputFiles];
    }
    
    //输入伴音文件
    if (_delegate && [_delegate respondsToSelector:@selector(TranscodeGetSecInputFile)]) {
        _secInputFile = [_delegate TranscodeGetSecInputFile];
    }
    
    //输出参数配置
    if (_delegate && [_delegate respondsToSelector:@selector(TranscodeGetOutputConfig)]) {
        _outputConfig = [_delegate TranscodeGetOutputConfig];
    }
    
    //输出路径
    _outputPath = view.dstFilePath;
    
    //开始转码
    [self doStartTranscode];
}

- (void)TranscodeViewStopAction:(SVDTranscodeView *)view {
    [self doStopTranscode];
}

- (void)TranscodeViewInvertStartAction:(SVDTranscodeView *)view
{
    //输入主文件
    if (_delegate && [_delegate respondsToSelector:@selector(TranscodeGetMainInputFiles)]) {
        _mainInputFiles = [_delegate TranscodeGetMainInputFiles];
    }
    
    //输入伴音文件
    if (_delegate && [_delegate respondsToSelector:@selector(TranscodeGetSecInputFile)]) {
        _secInputFile = [_delegate TranscodeGetSecInputFile];
    }
    
    //输出参数配置
    if (_delegate && [_delegate respondsToSelector:@selector(TranscodeGetOutputConfig)]) {
        _outputConfig = [_delegate TranscodeGetOutputConfig];
    }
    
    //输出路径
    _outputPath = view.dstFilePath;
    
    [self doInvertStartTranscode];
}

- (void)TranscodeViewInvertStopAction:(SVDTranscodeView *)view
{
    [self doInvertStopTranscode];
}

#pragma mark - Getter
- (SVDTranscodeView *)trancodeView {
    if (!_trancodeView) {
        _trancodeView = [[SVDTranscodeView alloc] init];
        _trancodeView.delegate = self;
    }
    return _trancodeView;
}

@end
