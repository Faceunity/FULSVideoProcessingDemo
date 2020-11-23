//
//  SVDTranscodePreviewVC.m
//  ShortVideo_Demo
//
//  Created by Netease on 17/2/20.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDTranscodePreviewVC.h"
#import "SVDEditTopBar.h"
#import "SVDEditBottomBar.h"

#import "NTESMenuView.h"
#import "NTESImageBar.h"
#import "NTESFilterBar.h"
#import "SVProgressHUD.h"
#import "NTESRecordDataCenter.h"

#import "GPUImageGrayscaleFilter.h"
#import "GPUImageHueFilter.h"

#import "FUManager.h"
#import "FUAPIDemoBar.h"

typedef void(^TranscodingCompleteBlock)(NSError *error, NSString *outPath);

@interface SVDTranscodePreviewVC () <SVDEditBottomBarProtocol, SVDEditTopBarProtocol, NTESMenuViewProtocol, FUAPIDemoBarDelegate>

@property (nonatomic, strong) SVDEditTopBar *topBar;
@property (nonatomic, strong) SVDEditBottomBar *bottomBar;
@property (nonatomic, strong) UIView *playerContainerView;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIButton *displayBtn;
@property (nonatomic, strong) NTESMenuView *audioBar;
@property (nonatomic, strong) NTESMenuView *adjustBar;
@property (nonatomic, strong) NTESImageBar *imageBar;
@property (nonatomic, strong) NTESMenuView *filterBar;

@property (nonatomic, assign) BOOL isAddWaterMark;
@property (nonatomic, strong) LSWaMarkRectInfo *pWaterMarkRectInfo;

//自定义滤镜
@property (nonatomic, strong) GPUImageGrayscaleFilter* customFilter1;
@property (nonatomic, strong) GPUImageHueFilter *customFilter2;

//转码sdk
@property (nonatomic, strong) LSMediaTranscoding *mediaTransc;
@property (strong,nonatomic)dispatch_queue_t transcodingQueue;
@property (nonatomic, strong) TranscodingCompleteBlock transcodingComplete;

//FaceUSdk
@property (nonatomic,copy) void (^externalVideoFrameCallback)(CMSampleBufferRef pixelBuf);

//音频播放器
@property (nonatomic, strong) NSMutableArray *playerItems;
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSString *audioPath;
@property (nonatomic,strong) NSArray *audioPaths;

@property (nonatomic, strong) NSArray *videoPaths;


@property (nonatomic, strong) FUAPIDemoBar *demoBar ;
@end

@implementation SVDTranscodePreviewVC



#pragma mark - FaceUnity

-(FUAPIDemoBar *)demoBar {
    if (!_demoBar) {
        
        _demoBar = [[FUAPIDemoBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 164 - 231, self.view.frame.size.width, 231)];
        
        _demoBar.mDelegate = self;
    }
    return _demoBar ;
}


#pragma -FUAPIDemoBarDelegate
-(void)filterValueChange:(FUBeautyParam *)param{
    [[FUManager shareManager] filterValueChange:param];
}

-(void)switchRenderState:(BOOL)state{
    [FUManager shareManager].isRender = state;
}

-(void)bottomDidChange:(int)index{
    if (index < 3) {
        [[FUManager shareManager] setRenderType:FUDataTypeBeautify];
    }
    if (index == 3) {
        [[FUManager shareManager] setRenderType:FUDataTypeStrick];
    }
    
    if (index == 4) {
        [[FUManager shareManager] setRenderType:FUDataTypeMakeup];
    }
    if (index == 5) {
        [[FUManager shareManager] setRenderType:FUDataTypebody];
    }
}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"[转码测试Demo] [SVDTranscodePreviewVC 释放]");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self doInitSubviews];
    
    [self doInitTranscode];
    
    // 美颜工具条
    [self.view addSubview:self.demoBar];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak typeof(self)weakSelf = self ;
    _mediaTransc.externalVideoFrameCallback = ^(CMSampleBufferRef sampleBuffer) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
        [strongSelf.mediaTransc externalInputVideoFrame:sampleBuffer];
    };
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.topBar.width != self.view.width) {
        self.topBar.frame = CGRectMake(0, 0, self.view.width, MANavBarHeight);
        self.displayBtn.frame = CGRectMake(8.0, _topBar.bottom + 8.0, 80, 40);
        self.bottomBar.frame = CGRectMake(0,
                                          self.view.height - 140,
                                          self.view.width,
                                          140);
        _playerContainerView.frame = CGRectMake(0,
                                       _topBar.bottom,
                                       self.view.width,
                                       _bottomBar.top - _topBar.bottom);
        
        self.tipLab.frame = CGRectMake(0, 0, self.bottomBar.width, 22);
        self.tipLab.centerY = self.view.height - self.bottomBar.height/2;
        
        self.imageBar.frame = _playerContainerView.frame;
    }
}

- (instancetype)initWithFilePaths:(NSArray *)filePaths {
    if (self = [super init]) {
        _videoPaths = filePaths;
        _audioPaths = [[NSBundle mainBundle] pathsForResourcesOfType:@".mp3" inDirectory:@""];
        _pWaterMarkRectInfo = [[LSWaMarkRectInfo alloc] init];
        _customFilter1 = [[GPUImageGrayscaleFilter alloc] init];
        _customFilter2 = [[GPUImageHueFilter alloc] init];
        _assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

- (void)doInitSubviews {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.bottomBar];
    [self.view addSubview:self.tipLab];
    [self.view addSubview:self.playerContainerView];
    [self.view addSubview:self.imageBar];
    [self.view addSubview:self.displayBtn];
}

#pragma mark - Private - SDK接口
//初始化
- (void)doInitTranscode {
    
    NSError *error = nil;
    _mediaTransc = [[LSMediaTranscoding alloc] initWithAppKey:NTES_TEST_APP_KEY
                                                        error:&error];
    if (error) {
        NSString *msg = error.userInfo[LS_Transcoding_Init_Error_Key];
        [self.view makeToast:msg duration:2 position:CSToastPositionCenter];
    }
    _transcodingQueue = dispatch_queue_create("LSTranscoding", NULL);

    //开始预览
    _mediaTransc.inputMainFileNameArray = _videoPaths;
    
    [_mediaTransc startVideoPreview:self.playerContainerView];
}

- (void)doDeallocTranscode {
    [_mediaTransc interruptTranscoding];
    [_mediaTransc stopVideoPreview];
    _mediaTransc = nil;
}

- (void)doConfigTranscode {
    
    _mediaTransc.inputMainFileNameArray = _videoPaths;
    _mediaTransc.inputSecondaryFileName = _audioPath;
    _mediaTransc.videoQuality = LS_TRANSCODING_VideoQuality_INTERMEDIUM;
    _mediaTransc.outputFileName = [[NTESSandboxHelper videoOutputPath] stringByAppendingPathComponent:[NSString outputFileName]];
    
    //水印
    if (_isAddWaterMark) {
        _mediaTransc.waterMarkInfos = @[_pWaterMarkRectInfo];
    }
}

//视频转码
- (void)doStartTranscode:(TranscodingCompleteBlock)complete {
    
    //保存变量
    TranscodingCompleteBlock transcodingComplete = [complete copy];
    
    //配置
    [self doConfigTranscode];
    
    //进度回调
    __weak typeof(self) weakSelf = self;
    _mediaTransc.LSMediaTransProgress = ^(float progress) {
        float process = progress;
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:process];
            NSLog(@"[转码测试Demo] 转码进度：%f", process);
        });
    };
 
    //执行转码
    dispatch_async(_transcodingQueue, ^{
        [weakSelf.mediaTransc doTranscoding:^(NSError *error, NSString *output) {
            if (transcodingComplete) {
                transcodingComplete(error, output);
            }
        }];
    });
}

- (void)doStopTranscode {
    NSLog(@"[转码测试Demo] 停止转码");
    [_mediaTransc interruptTranscoding];
}

#pragma mark - <SVDEditTopBarProtocol>
- (void)SVDEditTopBarAudioAction:(SVDEditTopBar *)bar {
    NSLog(@"[转码测试Demo] 显示音频选择框");
    [self.audioBar show];
}

- (void)SVDEditTopBarAdjustAction:(SVDEditTopBar *)bar {
    NSLog(@"[转码测试Demo] 显示滤镜调节框");
    [self.adjustBar show];
}

- (void)SVDEditTopBarImageAction:(SVDEditTopBar *)bar {
    NSLog(@"[转码测试Demo] 显示贴图控制");
    self.imageBar.hidden = NO;
}

- (void)SVDEditTopBarFilterAction:(SVDEditTopBar *)bar {
    NSLog(@"[转码测试Demo] 显示滤镜选择");
    [self.filterBar show];
}

- (void)SVDEditTopBarFaceUAction:(SVDEditTopBar *)bar isOn:(BOOL)isOn {
//    __weak typeof(self)weakSelf = self ;
//    _mediaTransc.externalVideoFrameCallback = ^(CMSampleBufferRef sampleBuffer) {
//
//        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//        [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
//        NSLog(@"----------------- woriniama ~");
//        [weakSelf.mediaTransc externalInputVideoFrame:sampleBuffer];
//    };
    
    _demoBar.hidden = !isOn;
    
}

#pragma mark - <SVDEditBottomBarProtocol>
- (void)SVDEditBottomBarBackAction:(SVDEditBottomBar *)bar {

    //销毁转码
    [self doDeallocTranscode];
    
    //销毁音频播放器
    [_audioPlayer stop];
    _audioPlayer = nil;
    
    //退出页面
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

//保存相册
- (void)SVDEditBottomBarSaveAction:(SVDEditBottomBar *)bar {
    
    //保存到相册
    NSURL *url = [NSURL fileURLWithPath:_videoPaths[0]];
    __weak typeof(self) weakSelf = self;
    [_assetLibrary saveVideo:url toAlbum:@"网易短视频" completion:^(NSURL *assetURL, NSError *error) {
        [weakSelf.view makeToast:@"视频保存相册成功" duration:2 position:CSToastPositionCenter];
        weakSelf.bottomBar.enableSave = NO;
    } failure:^(NSError *error) {
        [weakSelf.view makeToast:@"视频保存相册失败" duration:2 position:CSToastPositionCenter];
    }];
    
}

- (void)SVDEditBottomBarSureAction:(SVDEditBottomBar *)bar {
    
    //暂停播放器
    [_audioPlayer pause];
    
    //开始合并
    __weak typeof(self) weakSelf = self;
    [self doStartTranscode:^(NSError *error, NSString *outPath) {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [SVProgressHUD dismiss];
             if (error) //出错了
             {
                 [weakSelf.mediaTransc startVideoPreview:weakSelf.playerContainerView];
                 [weakSelf.audioPlayer play];
                 [weakSelf.view makeToast:@"转码出错" duration:2 position:CSToastPositionCenter];
             }
             else //正常的
             {
                 if (outPath) //播放合成成功的视频
                 {
                     [weakSelf.view makeToast:@"转码成功" duration:2 position:CSToastPositionCenter];
                     
                     weakSelf.videoPaths = @[outPath];
                     
                     //销毁音频播放器
                     [weakSelf.audioPlayer stop];
                     weakSelf.audioPlayer = nil;
                     
                     //恢复滤镜默认值
                     [weakSelf.adjustBar defaultValue];
                     
                     //设置预览文件
                     weakSelf.mediaTransc.inputMainFileNameArray = weakSelf.videoPaths;
                     
                     //开启预览
                     [weakSelf.mediaTransc startVideoPreview:self.playerContainerView];
                     
                     //可以保存到相册
                     weakSelf.bottomBar.enableSave = YES;
                 }
                 else
                 {
                     [weakSelf.view makeToast:@"转码取消" duration:2 position:CSToastPositionCenter];
                     
                     //开始播放
                     [weakSelf.audioPlayer play];
                     
                     //设置预览文件
                     weakSelf.mediaTransc.inputMainFileNameArray = weakSelf.videoPaths;
                     
                     //开启预览
                     [weakSelf.mediaTransc startVideoPreview:self.playerContainerView];
                     
                 }
             }
         });
    }];
}

#pragma mark - <NTESMenuViewProtocol>
- (void)menuView:(NTESMenuView *)menu startPlayAudio:(NSString *)path {

    //保存数据
    NSLog(@"[编辑测试Demo] 播放音频 %@", path);
    _audioPath = path;
    
    //停止
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    
    //播放
    if (_audioPath) {
        [_mediaTransc startPlayMusic:path withEnableSignleFileLooped:YES];
    }
}

- (void)menuViewStopPlayAudio:(NTESMenuView *)menu {
    [_mediaTransc stopPlayMusic];
}

- (void)menuView:(NTESMenuView *)menu mainAudioVolume:(CGFloat)volume {
    NSLog(@"[编辑测试Demo] 设置主音量:%f", volume);
    _mediaTransc.intensityOfMainAudioVolume = volume;
}

- (void)menuView:(NTESMenuView *)menu secAudioVolume:(CGFloat)volume {
    NSLog(@"[编辑测试Demo] 设置伴音音量:%f", volume);
    _mediaTransc.intensityOfSecondAudioVolume = volume;
}

- (void)menuView:(NTESMenuView *)menu brightness:(CGFloat)brightness {
    NSLog(@"[编辑测试Demo] 设置亮度: %f", brightness);
    _mediaTransc.brightness = brightness;
}

- (void)menuView:(NTESMenuView *)menu contrast:(CGFloat)contrast {
    NSLog(@"[编辑测试Demo] 设置对比度: %f", contrast);
    _mediaTransc.contrast = contrast;
}

- (void)menuView:(NTESMenuView *)menu saturation:(CGFloat)saturation {
    NSLog(@"[编辑测试Demo] 设置饱和度: %f", saturation);
    _mediaTransc.saturation = saturation;
}

- (void)menuView:(NTESMenuView *)menu sharpness:(CGFloat)sharpness {
    NSLog(@"[编辑测试Demo] 设置锐度: %f", sharpness);
    _mediaTransc.sharpness = sharpness;
}

- (void)menuView:(NTESMenuView *)menu hue:(CGFloat)hue {
    NSLog(@"[编辑测试Demo] 设置色温: %f", hue);
    _mediaTransc.hue = hue;
}

- (void)menuView:(NTESMenuView *)menu filter:(NSInteger)type {
    NSLog(@"[编辑测试Demo] 选择滤镜: %zi", type);
    if(type ==5)
    {
        [_mediaTransc setCustomFilter:_customFilter1];
    }
    else if(type == 6)
    {
        [_mediaTransc setCustomFilter:_customFilter2];
    }
    else
    {
        [_mediaTransc setCustomFilter:nil];
    }
    [_mediaTransc setFilterType:(LSRecordGPUImageFilterType)type];
}

- (void)menuView:(NTESMenuView *)menu whitening:(CGFloat)whitening {
    NSLog(@"[编辑测试Demo] 美白强度：%f", whitening);
    _mediaTransc.whiteningFilterIntensity = whitening;
}

- (void)menuView:(NTESMenuView *)menu smooth:(CGFloat)smooth {
    NSLog(@"[编辑测试Demo] 磨皮强度：%f", smooth);
    _mediaTransc.smoothFilterIntensity = smooth;
}

- (void)menuView:(NTESMenuView *)menu beauty:(BOOL)beauty {
    NSLog(@"[编辑测试Demo] 美颜开关：%@", (beauty ? @"开": @"关"));
    _mediaTransc.isBeautyFilterOn = beauty;
}

#pragma mark - Action
- (void)displayAction:(UIButton *)btn
{
    if (_mediaTransc.scaleVideoMode == LS_TRANSCODING_SCALE_VIDEO_MODE_FULL) {
        _mediaTransc.scaleVideoMode = LS_TRANSCODING_SCALE_VIDEO_MODE_FULL_BLACK;
    }
    else if (_mediaTransc.scaleVideoMode == LS_TRANSCODING_SCALE_VIDEO_MODE_FULL_BLACK) {
        _mediaTransc.scaleVideoMode = LS_TRANSCODING_SCALE_VIDEO_MODE_FULL;
    }
}

#pragma mark - Getter
- (SVDEditTopBar *)topBar {
    if (!_topBar) {
        _topBar = [SVDEditTopBar new];
        _topBar.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        _topBar.delegate = self;
    }
    return _topBar;
}

- (SVDEditBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [SVDEditBottomBar new];
        _bottomBar.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
}

- (UIView *)playerContainerView {
    if (!_playerContainerView) {
        _playerContainerView = [[UIView alloc] init];
        _playerContainerView.backgroundColor = [UIColor blackColor];
    }
    return _playerContainerView;
}

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.textColor = [UIColor lightGrayColor];
        _tipLab.font = [UIFont systemFontOfSize:13.0];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.hidden = YES;
        _tipLab.text = @"正在保存视频，请不要退出";
    }
    return _tipLab;
}

- (NTESMenuView *)audioBar {
    if (!_audioBar) {
        _audioBar = [[NTESMenuView alloc] initWithType:NTESMenuTypeAudio];
        _audioBar.selectedIndex = 0;
        NSString *audio1Path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
        NSString *audio2Path = [[NSBundle mainBundle] pathForResource:@"test2" ofType:@"mp3"];
        _audioBar.audioPaths = @[@"无", audio1Path, audio2Path];
        _audioBar.delegate = self;
    }
    return _audioBar;
}

- (NTESMenuView *)adjustBar {
    if (!_adjustBar) {
        _adjustBar = [[NTESMenuView alloc] initWithType:NTESMenuTypeAdjust];
        _adjustBar.delegate = self;
    }
    return _adjustBar;
}

- (NTESImageBar *)imageBar {
    if (!_imageBar) {
        _imageBar = [[NTESImageBar alloc] init];
        _imageBar.hidden = YES;
        _imageBar.image = [UIImage imageNamed:@"1"];
        
        __weak typeof(self) weakSelf = self;
        _imageBar.imageBlock = ^(CGRect rect) {
            if (!CGRectEqualToRect(rect, CGRectZero))
            {
                NSLog(@"[编辑测试Demo] 添加了贴图");
                weakSelf.isAddWaterMark = YES;
                weakSelf.pWaterMarkRectInfo.location = LS_TRANSCODING_WMARK_Rect;
                
#warning 务必做下视频坐标转换
                CGRect waterRect = [weakSelf rectInVideoWithContainerFrame:weakSelf.imageBar.frame imageFrame:rect];
                weakSelf.pWaterMarkRectInfo.uiX = waterRect.origin.x;
                weakSelf.pWaterMarkRectInfo.uiY = waterRect.origin.y;
                weakSelf.pWaterMarkRectInfo.uiWidth = waterRect.size.width;
                weakSelf.pWaterMarkRectInfo.uiHeight = waterRect.size.height;
                weakSelf.pWaterMarkRectInfo.uiBeginTimeInSec = 0;
                weakSelf.pWaterMarkRectInfo.uiDurationInSec = 0;
                weakSelf.pWaterMarkRectInfo.waterMarkImage = weakSelf.imageBar.image;
            }
            else
            {
                weakSelf.isAddWaterMark = NO;
            }
        };
    }
    return _imageBar;
}

- (NTESMenuView *)filterBar {
    if (!_filterBar) {
        _filterBar = [[NTESMenuView alloc] initWithType:NTESMenuTypeFilter];
        _filterBar.filterTypes = [NTESRecordDataCenter shareInstance].config.filterDatas;
        _filterBar.delegate = self;
    }
    return _filterBar;
}

- (UIButton *)displayBtn {
    if (!_displayBtn) {
        _displayBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_displayBtn setTitle:@"显示模式" forState:UIControlStateNormal];
        [_displayBtn addTarget:self action:@selector(displayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _displayBtn;
}

#pragma mark - 视频坐标转换
- (CGRect)rectInVideoWithContainerFrame:(CGRect)constainerFrame imageFrame:(CGRect)imageFrame
{
    CGRect imageInVideoRect = CGRectZero; //图片在视频中的位置
    CGRect validRect = CGRectZero; //有效范围
    unsigned int videoWidth = _mediaTransc.videoEncodedWidth;
    unsigned int videoHeight = _mediaTransc.videoEncodedHeight;
    
    //Step1: 计算有效水印叠加的有效范围。
    if (videoWidth < videoHeight) //竖的视频
    {
        validRect.size.height = constainerFrame.size.height;
        validRect.size.width = validRect.size.height * videoWidth / videoHeight;
        validRect.origin.x = (constainerFrame.size.width - validRect.size.width)/2;
        validRect.origin.y = 0;
    }
    else //横的视频
    {
        validRect.size.width = constainerFrame.size.width;
        validRect.size.height = validRect.size.width * videoHeight / videoWidth;
        validRect.origin.x = 0;
        validRect.origin.y = (constainerFrame.size.height - validRect.size.height)/2;
    }
    
    //Step2: 将有效范围(validRect)中的水印位置映射到视频坐标系中(0,0,videoWidth,videoHeight);
    imageInVideoRect.origin.x = (imageFrame.origin.x - validRect.origin.x) * videoWidth / validRect.size.width;
    imageInVideoRect.origin.y = (imageFrame.origin.y - validRect.origin.y) * videoHeight / validRect.size.height;
    imageInVideoRect.size.width = imageFrame.size.width * videoWidth / validRect.size.width;
    imageInVideoRect.size.height = imageFrame.size.height * videoHeight / validRect.size.height;
    
    return imageInVideoRect;
}

@end
