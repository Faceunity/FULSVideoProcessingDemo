//
//  NTESRecordVC.m
//  ShortVideoProcess_Demo
//
//  Created by Netease on 17/3/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESRecordVC.h"
#import "NTESRecordControlBar.h"
#import "NTESRecordDataCenter.h"
#import "SVDTranscodePreviewVC.h"

#import "GPUImageGrayscaleFilter.h"
#import "GPUImageHueFilter.h"

/*  FU */
#import <FUAPIDemoBar/FUAPIDemoBar.h>
#import "FUManager.h"

typedef void(^RecordCompleteBlock)(NSError *error, NSArray *paths);
typedef void(^RecordStartBlock)(NSError *error);

@interface NTESRecordVC ()<NTESRecordControlBarProtocol,FUAPIDemoBarDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NTESRecordControlBar *controlBar;
@property (nonatomic, strong) LSMediaRecording *mediaCapture;
@property (nonatomic, assign) LSMediaRecordingParaCtx *pStreamParaCtx;

@property (nonatomic, strong) RecordStartBlock recordStart;
@property (nonatomic, strong) RecordCompleteBlock recordComplete;

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isSkip;

@property (nonatomic, assign) BOOL isNeedResumeFaceU;

@property (nonatomic, copy) void (^externalVideoFrameCallback)(CMSampleBufferRef pixelBuf);

@property (nonatomic, copy) NSString *audioPath;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) FUAPIDemoBar *demoBar ;

@end

@implementation NTESRecordVC


- (void)dealloc
{
    [NTESRecordDataCenter clear];
    [LSMediaRecording cleanGPUCache];
    
    [[FUManager shareManager] destoryItems];
}

//注意：进来之前记得申请一下权限
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _audioPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_audioPath] error:nil];
    //初始化子视图
    [self doInitSubViews];
    
    //初始化sdk
    [self doInitRecordSdk];
    
    //开启预览
    [self doStartPreview];
    
    /* faceU */
    [[FUManager shareManager] loadItems];
    [self.view addSubview:self.demoBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!CGRectEqualToRect(self.view.bounds, _controlBar.frame)) {
        _controlBar.frame = self.view.bounds;
        _containerView.center = CGPointMake(self.view.width/2, self.view.height/2);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBarHidden = YES;
    
    _controlBar.configEntity = [NTESRecordDataCenter shareInstance].config;
    [NTESSandboxHelper deleteFiles:[NTESRecordDataCenter shareInstance].recordFilePaths];
    [[NTESRecordDataCenter shareInstance].recordFilePaths removeAllObjects];
    _controlBar.completeRecordSections = [NTESRecordDataCenter shareInstance].recordFilePaths.count;

#warning 进入的时候恢复
    //进入的时候恢复
    [_mediaCapture resumeVideoPreview];

    if (_isNeedResumeFaceU)
    {
        //恢复第三方前处理回调
        _mediaCapture.externalVideoFrameCallback = _externalVideoFrameCallback;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
#warning 离开的时候务必要停掉
    //离开的时候务必要停掉
    [_mediaCapture pauseVideoPreview];
    
    //停掉第三方前处理回调
    if (_mediaCapture.externalVideoFrameCallback != nil)
    {
        _mediaCapture.externalVideoFrameCallback = nil;
        _isNeedResumeFaceU = YES;
    }
}

- (void)doInitSubViews
{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.controlBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

#pragma mark - Function
//录制sdk初始化
- (void)doInitRecordSdk
{
    NSLog(@"[录制测试Demo] SDK Version: [%@]", [LSMediaRecording SDKVersion]);
    
    NSError *error = nil;
    _mediaCapture = [[LSMediaRecording alloc] initLiveStreamWithLivestreamParaCtx:self.pStreamParaCtx appKey:NTES_TEST_APP_KEY error:&error];
    if (error)
    {
        NSString *msg = error.userInfo[LS_Recording_Init_Error_Key];
        UIView *showView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        [showView makeToast:msg duration:2 position:CSToastPositionCenter];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [_mediaCapture setSmoothFilterIntensity:[NTESRecordDataCenter shareInstance].config.beautyValue];
        NSInteger filterIndex = [NTESRecordDataCenter shareInstance].config.curFilterIndex;
        [_mediaCapture setFilterType:(LSRecordGPUImageFilterType)filterIndex];
        [_mediaCapture setExposureValue:[NTESRecordDataCenter shareInstance].config.exposureValue];
#warning 视频采集数据回调
        __weak typeof(self) weakSelf = self;
        _externalVideoFrameCallback = ^(CMSampleBufferRef pixelBuf) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(pixelBuf) ;
            
            /*** ------ 加入 FaceUnity 效果 ------ **/
            [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
            [strongSelf.mediaCapture externalInputVideoFrame:pixelBuf];
        };
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onStartLiveStream:)
                                                     name:LS_Recording_Started
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onFinishedLiveStream:)
                                                     name:LS_Recording_Finished
                                                   object:nil];
    }
}

//开启预览
- (void)doStartPreview
{
    if (self.pStreamParaCtx.eOutStreamType != LS_RECORD_AUDIO) {
        //打开摄像头预览
        [_mediaCapture startVideoPreview:self.containerView];
    }
}

//开始录制
- (void)doStartRecord:(RecordStartBlock)complete
{
    _recordStart = complete;
    _mediaCapture.recordFileSavedRootPath = [NTESSandboxHelper videoRecordPath];
    NSError *error = [_mediaCapture startLiveStream];
    if (error && complete) {
        complete(error);
    }
    
    
}

//结束录制
- (void)doStopRecord:(RecordCompleteBlock)complete
{
    _recordComplete = complete;
    NSError *error = [_mediaCapture stopLiveStream];
    if (error && complete) {
        complete(error, nil);
    }
}

#pragma mark - Notication
//收到此消息，说明 录制真的开始了
- (void)onStartLiveStream:(NSNotification *)note
{
    _isRecording = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_recordStart) {
            _recordStart(nil);
        }
    });
}

// 录制结束的通知消息
- (void)onFinishedLiveStream:(NSNotification *)note
{
    NSLog(@"录制结束，路径是 -- [%@]", _mediaCapture.recordFilePath);
    
    NSLog(@"伴音播放到 %zi", [_mediaCapture curMusicFrameIndex]);
    
    _isRecording = NO;
    
    NSError *error = [NSError errorWithDomain:@"ntes.record.complete" code:1001 userInfo:@{NTES_ERROR_MSG_KEY: @"文件路径为空"}];

    if (_mediaCapture.recordFilePath) {
        error = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_recordComplete) {
            _recordComplete(error, @[_mediaCapture.recordFilePath]);
        }
    });
}

//进入后台通知
- (void)appDidEnterBackground:(NSNotification *)note
{
    if (_isRecording) //停止
    {
        [_controlBar sendCancelRecordAction];
    }
}

#pragma mark - <NTESRecordControlBarProtocol>
//退出事件
- (void)ControlBarQuit:(NTESRecordControlBar *)bar {
    [self.navigationController popViewControllerAnimated:YES];
}

//完成录制事件
- (void)ControlBarRecordDidCompleted:(NTESRecordControlBar *)bar isSkip:(BOOL)isSkip {
    NSLog(@"[录制Demo事件] 点击了完成");
    _isSkip = isSkip;
    SVDTranscodePreviewVC *result = [[SVDTranscodePreviewVC alloc] initWithFilePaths:[NTESRecordDataCenter shareInstance].recordFilePaths];
    [self.navigationController pushViewController:result animated:YES];
}

//摄像头事件
- (void)ControlBarCameraSwitch:(NTESRecordControlBar *)bar {
    NSLog(@"[录制Demo事件] 点击了切换摄像头");
    [_mediaCapture switchCamera];
}

//美颜开关
- (void)ControlBar:(NTESRecordControlBar *)bar beauty:(BOOL)isBeauty {
    NSLog(@"[录制Demo事件] 点击了美颜开关，[%@]", isBeauty ? @"YES" : @"NO");
    _mediaCapture.isBeautyFilterOn = isBeauty;
}

//faceU处理开关
- (void)ControlBar:(NTESRecordControlBar *)bar faceUOpen:(BOOL)isOpen {
    NSLog(@"[录制Demo事件] 点击了美颜开关，[%@]", isOpen ? @"YES" : @"NO");
    _demoBar.hidden = !isOpen;
    _mediaCapture.externalVideoFrameCallback = (isOpen ? _externalVideoFrameCallback : nil);
}

//水印事件
- (void)ControlBar:(NTESRecordControlBar *)bar waterType:(NSInteger)waterType waterLoc:(NSInteger)waterLoc
{
    NSLog(@"[录制Demo事件] 点击了水印，waterType:[%zi]，waterLoc:[%zi]", waterType, waterLoc);
    
    [_mediaCapture cleanWaterMark];
    
    if (waterType == 1) //静态水印
    {
        CGRect rect = CGRectMake(50, 50, 60, 34);
        [_mediaCapture addWaterMark:[UIImage imageNamed:@"logo.png"] rect:rect location:waterLoc];
    }
    else if (waterType == 2)
    {
        CGRect rect = CGRectMake(50, 50, 300, 125);
        NSMutableArray *imgs = [NSMutableArray array];
        for (NSInteger i = 0; i < 23; i++) {
            NSString *name = [NSString stringWithFormat:@"water%zi.png", i];
            NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
        
            UIImage *img = [UIImage imageWithContentsOfFile:path];
            [imgs addObject:img];
        }
        [_mediaCapture addDynamicWaterMarks:imgs fpsCount:2 loop:YES rect:rect location:waterLoc];
    }
}

//美白滤镜强度
- (void)ControlBar:(NTESRecordControlBar *)bar whitening:(CGFloat)whitening {
    NSLog(@"[录制Demo事件] 设置美白滤镜强度 : %f", whitening);
    [_mediaCapture setWhiteningFilterIntensity:whitening];
}

//磨皮滤镜强度
- (void)ControlBar:(NTESRecordControlBar *)bar smooth:(CGFloat)smooth {
    NSLog(@"[录制Demo事件] 设置磨皮滤镜强度 : %f", smooth);
    [_mediaCapture setSmoothFilterIntensity:smooth];
}

//滤镜事件
- (void)ControlBar:(NTESRecordControlBar *)bar filter:(NSInteger)index
{
    NSLog(@"[录制Demo事件] 设置滤镜类型 : %zi", index);
#warning 先设置滤镜，再设置类型
    if(index ==5)
    {
        GPUImageGrayscaleFilter* customFilter1 = [GPUImageGrayscaleFilter new];
        [_mediaCapture setCustomFilter:customFilter1];
    }
    else if(index == 6)
    {
        GPUImageHueFilter *customFilter2 = [GPUImageHueFilter new];
        [_mediaCapture setCustomFilter:customFilter2];
    }
    [_mediaCapture setFilterType:(LSRecordGPUImageFilterType)index];
}

//曝光率事件
- (void)ControlBar:(NTESRecordControlBar *)bar exposure:(CGFloat)exposure {
    NSLog(@"[录制Demo事件]，设置曝光值 : %f", exposure);
    [_mediaCapture setExposureValue:exposure];
}

//分辨率事件
- (void)ControlBar:(NTESRecordControlBar *)bar resolution:(NSInteger)resolution {
    NSLog(@"[录制Demo事件]，设置分辨率 : %zi", resolution);
    [_mediaCapture setVideoQuality:(LSRecordVideoStreamingQuality)resolution];
}

//画幅事件
- (void)ControlBar:(NTESRecordControlBar *)bar frame:(CGRect)frame mode:(NSInteger)mode
{
    NSLog(@"[录制Demo事件]，设置画幅 : %zi", mode);
    
    //调整container
    self.containerView.clipsToBounds = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.containerView.frame = frame;
        self.containerView.centerX = self.view.width/2;
        [self.containerView.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = self.containerView.bounds;
        }];
    }];
    
    //设置下去
    [_mediaCapture setVideoScaleMode:mode];
}

//手动聚焦事件
- (void)ControlBar:(NTESRecordControlBar *)bar focusPoint:(CGPoint)point
{
    NSLog(@"[录制Demo事件]，设置手动聚焦点 : %@", NSStringFromCGPoint(point));
    CGPoint dstPoint = [_controlBar convertPoint:point toView:_containerView];
#warning 这里需要传入(0-1)范围内的值，需要做一下比例转换
    CGPoint focusPoint = CGPointMake(dstPoint.x/_containerView.width, dstPoint.y/_containerView.height);
    [_mediaCapture setFocusPoint:focusPoint];
}

//变焦事件
- (void)ContorlBar:(NTESRecordControlBar *)bar zoom:(CGFloat)zoom {
    NSLog(@"[录制Demo事件]，设置变焦倍数 : %f", zoom);
    [_mediaCapture setZoomScale:zoom];
}

//开始录制事件
- (void)ControlBarRecordDidStart:(NTESRecordControlBar *)bar
{
    NSLog(@"[录制Demo事件]，开始录制。");
    __weak typeof(self) weakSelf = self;
    [self doStartRecord:^(NSError *error) {
        if (error) {
            NSString *msg = [NSString stringWithFormat:@"开始录制失败:[%@]", error];
            [weakSelf.view makeToast:msg duration:2 position:CSToastPositionCenter];
        }
        else
        {
            [weakSelf.controlBar startRecordAnimation];
        }
    }];
}

//取消录制事件
- (void)ControlBarRecordDidCancelled:(NTESRecordControlBar *)bar
{
    NSLog(@"[录制Demo事件]，取消录制。");
    __weak typeof(self) weakSelf = self;
    [self doStopRecord:^(NSError *error, NSArray *paths) {
        if (error) {
            NSString *msg = [NSString stringWithFormat:@"结束录制失败:[%@]", error];
            [weakSelf.view makeToast:msg duration:2 position:CSToastPositionCenter];
        }
        else
        {
            NSString *path = [paths lastObject];
            [NTESSandboxHelper deleteFiles:[NSArray arrayWithObject:path]]; //删除录制的文件
            [weakSelf.controlBar stopRecordAnimation]; //停止动画
        }
    }];
}

//删除录制事件(上一个)
- (void)ControlBarRecordDidDeleted:(NTESRecordControlBar *)bar
{
    NSLog(@"[录制Demo事件]，删除上一个视频。");
    NSString *path = [[NTESRecordDataCenter shareInstance].recordFilePaths lastObject];
    if (path) {
        [NTESSandboxHelper deleteFiles:@[path]]; //删除文件
    }
    [[NTESRecordDataCenter shareInstance].recordFilePaths removeLastObject]; //删除路径
    self.controlBar.completeRecordSections--; //更新UI
}

//录制动画结束
- (void)ControlBarRecordAnimationDidStop:(NTESRecordControlBar *)bar  isCancel:(BOOL)isCancel
{
    NSLog(@"[录制Demo事件]，[%@]录制视频。", isCancel ? @"取消" : @"停止");
    
    //主动取消，不用处理
    if (isCancel)
    {
        return;
    }
    
    //录制时间到，需要停止录制
    __weak typeof(self) weakSelf = self;
    [self doStopRecord:^(NSError *error, NSArray *paths) {
        if (error) {
            NSString *msg = [NSString stringWithFormat:@"结束录制失败:[%@]", error];
            [weakSelf.view makeToast:msg duration:2 position:CSToastPositionCenter];
        }
        else //录制完成
        {
            //录制小段完成了
            ++weakSelf.controlBar.completeRecordSections; //显示录制的时间段
            [[NTESRecordDataCenter shareInstance].recordFilePaths addObject:paths.lastObject]; //存储路径
        }
    }];
}

//播放伴音事件
- (void)ControlBarStartPlay:(NTESRecordControlBar *)bar path:(NSString *)path {
    NSLog(@"开始播放伴音：[%@]", path);
    [_mediaCapture startPlayMusic:path withEnableSignleFileLooped:YES];
}

//停止播放伴音事件
- (void)ControlBarStopPlay:(NTESRecordControlBar *)bar {
    NSLog(@"停止播放伴音");
    [_mediaCapture stopPlayMusic];
}

//麦克风采集音量设置
- (void)ControlBarSetMacrophoneVolume:(NTESRecordControlBar *)bar  volume:(CGFloat)volume {
    NSLog(@"设置麦克风采集音量:%f", volume);
    _mediaCapture.microphoneVolume = volume;
}

//伴音音量
- (void)ControlBarSetAudioVolume:(NTESRecordControlBar *)bar  volume:(CGFloat)volume {
    NSLog(@"设置伴音音量:%f", volume);
    _mediaCapture.musicVolume = volume;
}
#pragma  mark ----  FUAPIDemoBarDelegate  -----

// 切换贴纸
- (void)demoBarDidSelectedItem:(NSString *)itemName {
    
    [[FUManager shareManager] loadItem:itemName];
}


// 更新美颜参数
- (void)demoBarBeautyParamChanged {
    
    [FUManager shareManager].skinDetectEnable = _demoBar.skinDetectEnable;
    [FUManager shareManager].blurShape = _demoBar.blurShape;
    [FUManager shareManager].blurLevel = _demoBar.blurLevel ;
    [FUManager shareManager].whiteLevel = _demoBar.whiteLevel;
    [FUManager shareManager].redLevel = _demoBar.redLevel;
    [FUManager shareManager].eyelightingLevel = _demoBar.eyelightingLevel;
    [FUManager shareManager].beautyToothLevel = _demoBar.beautyToothLevel;
    [FUManager shareManager].faceShape = _demoBar.faceShape;
    [FUManager shareManager].enlargingLevel = _demoBar.enlargingLevel;
    [FUManager shareManager].thinningLevel = _demoBar.thinningLevel;
    [FUManager shareManager].enlargingLevel_new = _demoBar.enlargingLevel_new;
    [FUManager shareManager].thinningLevel_new = _demoBar.thinningLevel_new;
    [FUManager shareManager].jewLevel = _demoBar.jewLevel;
    [FUManager shareManager].foreheadLevel = _demoBar.foreheadLevel;
    [FUManager shareManager].noseLevel = _demoBar.noseLevel;
    [FUManager shareManager].mouthLevel = _demoBar.mouthLevel;
    
    [FUManager shareManager].selectedFilter = _demoBar.selectedFilter ;
    [FUManager shareManager].selectedFilterLevel = _demoBar.selectedFilterLevel;
}

#pragma mark - Getter
- (UIView *)containerView
{
    if (!_containerView)
    {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor lightGrayColor];
        
        NSInteger scale = [NTESRecordDataCenter shareInstance].config.curScaleModeIndex;
        _containerView.frame = [self.controlBar videoRectWithScreenScale:scale];
    }
    return _containerView;
}

- (NTESRecordControlBar *)controlBar
{
    if (!_controlBar) {
        _controlBar = [[NTESRecordControlBar alloc] init];
        _controlBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0.0];
        _controlBar.configEntity = [NTESRecordDataCenter shareInstance].config;
        _controlBar.completeRecordSections = [NTESRecordDataCenter shareInstance].recordFilePaths.count;
        _controlBar.delegate = self;
    }
    return _controlBar;
}

// demobar 初始化
-(FUAPIDemoBar *)demoBar {
    if (!_demoBar) {
        _demoBar = [[FUAPIDemoBar alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 164)];
        
        _demoBar.itemsDataSource = [FUManager shareManager].itemsDataSource;
        _demoBar.selectedItem = [FUManager shareManager].selectedItem ;
        
        _demoBar.filtersDataSource = [FUManager shareManager].filtersDataSource ;
        _demoBar.beautyFiltersDataSource = [FUManager shareManager].beautyFiltersDataSource ;
        _demoBar.filtersCHName = [FUManager shareManager].filtersCHName ;
        _demoBar.selectedFilter = [FUManager shareManager].selectedFilter ;
        [_demoBar setFilterLevel:[FUManager shareManager].selectedFilterLevel forFilter:[FUManager shareManager].selectedFilter] ;
        
        _demoBar.skinDetectEnable = [FUManager shareManager].skinDetectEnable;
        _demoBar.blurShape = [FUManager shareManager].blurShape ;
        _demoBar.blurLevel = [FUManager shareManager].blurLevel ;
        _demoBar.whiteLevel = [FUManager shareManager].whiteLevel ;
        _demoBar.redLevel = [FUManager shareManager].redLevel;
        _demoBar.eyelightingLevel = [FUManager shareManager].eyelightingLevel ;
        _demoBar.beautyToothLevel = [FUManager shareManager].beautyToothLevel ;
        _demoBar.faceShape = [FUManager shareManager].faceShape ;
        
        _demoBar.enlargingLevel = [FUManager shareManager].enlargingLevel ;
        _demoBar.thinningLevel = [FUManager shareManager].thinningLevel ;
        _demoBar.enlargingLevel_new = [FUManager shareManager].enlargingLevel_new ;
        _demoBar.thinningLevel_new = [FUManager shareManager].thinningLevel_new ;
        _demoBar.jewLevel = [FUManager shareManager].jewLevel ;
        _demoBar.foreheadLevel = [FUManager shareManager].foreheadLevel ;
        _demoBar.noseLevel = [FUManager shareManager].noseLevel ;
        _demoBar.mouthLevel = [FUManager shareManager].mouthLevel ;
        _demoBar.hidden = YES;
        _demoBar.delegate = self;
    }
    return _demoBar ;
}

- (LSMediaRecordingParaCtx *)pStreamParaCtx
{
    return [NTESRecordDataCenter shareInstance].pRecordPara;
}
@end
