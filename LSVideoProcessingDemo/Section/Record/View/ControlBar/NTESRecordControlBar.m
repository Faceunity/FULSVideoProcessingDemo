//
//  NTESRecordControlBar.m
//  ShortVideoProcess_Demo
//
//  Created by Netease on 17/3/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESRecordControlBar.h"
#import "NTESRecordTopBar.h"
#import "NTESConfigTipBtn.h"
#import "NTESSegmentView.h"
#import "NTESProcessBtn.h"

#import "NTESBeautyConfigView.h"
#import "NTESFilterConfigView.h"
#import "NTESSettingView.h"
#import "NTESVideoMaskBar.h"
#import "NTESMenuView.h"

static NSInteger gTopBarHeight = 120.0;
static NSInteger gBottomBarHeihgt = 120.0;

@interface NTESRecordControlBar ()<NTESRecordTopBarProtocol, NTESProcessBtnProtocol, NTESSettingViewProtocol, UIGestureRecognizerDelegate, NTESVideoMaskBarDelegate, NTESMenuViewProtocol>

@property (nonatomic, assign) BOOL isCancelRecord; //取消录制动画

@property (nonatomic, strong) UIView *maskView; //浮层遮罩

@property (nonatomic, strong) NTESRecordTopBar *topBar;     //顶部工具栏
@property (nonatomic, strong) NTESVideoMaskBar *videoMaskBar; //视频浮层控制栏

@property (nonatomic, strong) NTESProcessBtn *recordBtn;    //开始录像按钮
@property (nonatomic, strong) NTESSegmentView *segmentLine; //分段数分割线（虚线）
@property (nonatomic, strong) NTESConfigTipBtn *configTipBtn;  //配置信息按钮

@property (nonatomic, strong) NTESMenuView *audioBar; //伴音配置信息
@property (nonatomic, strong) NTESBeautyConfigView *beautyConfig; //美颜配置信息
@property (nonatomic, strong) NTESFilterConfigView *filterConfig; //滤镜配置信息
@property (nonatomic, strong) NTESSettingView *settingView; //录制配置信息

@property (nonatomic, strong) UIButton *cancelRecordBtn;   //取消录制
@property (nonatomic, strong) UIButton *deleteRecordBtn; //删除录制
@property (nonatomic, strong) UIButton *completeRecordBtn; //完成录制


@end

@implementation NTESRecordControlBar

- (void)doInit
{
    [self addSubview:self.topBar];
    [self addSubview:self.videoMaskBar];
    [self addSubview:self.configTipBtn];
    [self addSubview:self.segmentLine];
    [self addSubview:self.recordBtn];
    [self addSubview:self.cancelRecordBtn];
    [self addSubview:self.deleteRecordBtn];
    [self addSubview:self.completeRecordBtn];
    
    self.completeRecordSections = 0;
    [self switchToNormalUI];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _maskView.frame = self.bounds;
    
    //顶部工具栏
    _topBar.frame = CGRectMake(0, 0, self.width, gTopBarHeight);
    
    //控制条
    _videoMaskBar.centerX = self.width/2;
    
    //美颜选项
    self.beautyConfig.frame = CGRectMake(0,
                                         44.0,
                                         self.width,
                                         80);
    
    //滤镜选项
    self.filterConfig.frame = self.beautyConfig.frame;
    
    //分隔线
    _segmentLine.frame = CGRectMake(0,
                                    self.bottom - gBottomBarHeihgt,
                                    self.width,
                                    10.0);
    //选择按钮
    _configTipBtn.origin = CGPointMake(self.width - _configTipBtn.width - 12.0,
                                       _segmentLine.top - 15 - _configTipBtn.height);
    
    //配置选项
    self.settingView.frame = CGRectMake(0,
                                        _configTipBtn.top - 13.0 - [_settingView settingHeight],
                                        self.width,
                                        [_settingView settingHeight]);
    
    //开始录制按钮
    _recordBtn.center = CGPointMake(self.width/2, (self.height - _segmentLine.bottom)/2 + _segmentLine.bottom);
    _recordBtn.layer.cornerRadius = _recordBtn.width/2;
    
    //取消录制按钮
    _cancelRecordBtn.center = CGPointMake(_recordBtn.left/2, _recordBtn.centerY);
    
    //删除录制按钮
    _deleteRecordBtn.frame = _cancelRecordBtn.frame;
    
    //完成录制按钮
    _completeRecordBtn.center = CGPointMake((self.width - _recordBtn.right)/2 + _recordBtn.right, _recordBtn.centerY);
}

#pragma mark - Public
- (void)startRecordAnimation
{
    _isCancelRecord = NO;
    
    [self.recordBtn startProgressAnimation];
}

- (void)stopRecordAnimation
{
    _isCancelRecord = YES;
    
    [self.recordBtn stopProgressAnimation];
}

- (void)sendCancelRecordAction
{
    [self.cancelRecordBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)sendDeleteRecordAction
{
    [self.deleteRecordBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (CGRect)videoMaskRectWithScreenScale:(NSInteger)scale
{
    CGRect fullScale = [UIScreen mainScreen].bounds;
    CGFloat width = MIN(fullScale.size.width, fullScale.size.height);
    CGFloat height = MAX(fullScale.size.width, fullScale.size.height);
    CGRect videoRect = [self videoRectWithScreenScale:scale];
    CGRect maxRect = CGRectMake(0, gBottomBarHeihgt, width, height - 44.0 - gBottomBarHeihgt);
    if (videoRect.origin.y < maxRect.origin.y) {
        videoRect.origin.y = maxRect.origin.y;
    }
    
    if (videoRect.size.height > maxRect.size.height) {
        videoRect.size.height = maxRect.size.height;
    }

    return videoRect;
}

- (CGRect)videoRectWithScreenScale: (NSInteger)scale
{
    CGRect fullScale = [UIScreen mainScreen].bounds;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = MIN(fullScale.size.width, fullScale.size.height);
    CGFloat height = MAX(fullScale.size.width, fullScale.size.height);
    
    switch (scale) {
        case 1: //16:9
        {
            CGFloat dstHeight = width * 16 / 9;
            if (dstHeight > height) //底边超了, 以高为主
            {
                width = height * 9/16;
            }
            else
            {
                height = dstHeight;
            }
            break;
        }
        case 2: //4:3
        {
            CGFloat dstHeight = width * 4/3;
            if (dstHeight > height)
            {
                width = height * 3/4;
                y = 44.0;
            }
            else if (dstHeight == height)
            {
                height = dstHeight;
            }
            else
            {
                y = 44.0;
                height = dstHeight;
            }
            break;
        }
        case 3: //1:1
        {
            CGFloat maxHeight = height - gBottomBarHeihgt - 44.0;
            y = (maxHeight - width)/2 + 44.0;
            height = width;
            break;
        }
        default:
            break;
    }
    return CGRectMake(x, y, width, height);
}

#pragma mark - UI Switch
//录制的UI
- (void)switchToRecordUI
{
    /*----- 只显示录制进度和取消 -----*/
    _recordBtn.hidden = NO;
    [_recordBtn showBtn:NO];
    _cancelRecordBtn.hidden = NO;
    
    _topBar.hidden = YES;
    _videoMaskBar.hidden = YES;
    _configTipBtn.hidden = YES;
    _segmentLine.hidden = YES;
    _deleteRecordBtn.hidden = YES;
    _completeRecordBtn.hidden = YES;
}

//正常的UI
- (void)switchToNormalUI
{
    /*----- 不显示取消 -----*/
    _cancelRecordBtn.hidden = YES;
    
    _recordBtn.hidden = NO;
    [_recordBtn showBtn:YES];
    _topBar.hidden = NO;
    _videoMaskBar.hidden = NO;
    _configTipBtn.hidden = NO;
    _segmentLine.hidden = NO;
    _deleteRecordBtn.hidden = (_completeRecordSections == 0);
    _completeRecordBtn.hidden = (_completeRecordSections == 0);
}

#pragma mark - Action
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    __weak typeof(self) weakSelf = self;

    UIView *showView = [_maskView.subviews lastObject];
    
    if (showView == _beautyConfig) {
        [_beautyConfig dismissComplete:^{
            [weakSelf.maskView removeFromSuperview];
        }];
    }
    else if (showView == _filterConfig) {
        [_filterConfig dismissComplete:^{
            [weakSelf.maskView removeFromSuperview];
        }];
    }
    else if (showView == _settingView) {
        [_settingView dismissComplete:^{
            [weakSelf.maskView removeFromSuperview];
        }];
    }
}

- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 10) //点击取消录制
    {
        if (_delegate && [_delegate respondsToSelector:@selector(ControlBarRecordDidCancelled:)]) {
            [_delegate ControlBarRecordDidCancelled:self];
        }
    }
    else if (btn.tag == 11) //点击删除录制
    {
        if (_delegate && [_delegate respondsToSelector:@selector(ControlBarRecordDidDeleted:)]) {
            [_delegate ControlBarRecordDidDeleted:self];
        }
    }
    else if (btn.tag == 12) //点击完成录制
    {
        if (_delegate && [_delegate respondsToSelector:@selector(ControlBarRecordDidCompleted:isSkip:)]) {
            
            NSInteger sections = [_configEntity.sectionDatas[_configEntity.curSectionsIndex] integerValue];
            BOOL isSkip = (_completeRecordSections != sections);
            [_delegate ControlBarRecordDidCompleted:self isSkip:isSkip];
        }
    }
    else if (btn.tag == 13) //点击配置信息
    {
        [self addSubview:self.maskView];
        [self.settingView showInView:self.maskView complete:nil];
    }
}

- (void)sliderAction:(UISlider *)slider
{
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBar:exposure:)]) {
        [_delegate ControlBar:self exposure:slider.value];
    }
}

#pragma mark - 顶部工具栏 - <NTESRecordTopBarProtocol>
- (void)TopBarQuitAction:(NTESRecordTopBar *)bar
{
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBarQuit:)]) {
        [_delegate ControlBarQuit:self];
    }
}

- (void)TopBarFilterConfigAction:(NTESRecordTopBar *)bar
{
    [self addSubview:self.maskView];
    [self.beautyConfig showInView:self.maskView complete:nil];
}

- (void)TopBarFilterAction:(NTESRecordTopBar *)bar
{
    [self addSubview:self.maskView];
    [self.filterConfig showInView:self.maskView complete:nil];
}

- (void)TopBarCameraAction:(NTESRecordTopBar *)bar
{
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBarCameraSwitch:)]) {
        [_delegate ControlBarCameraSwitch:self];
    }
}

- (void)TopBarAudioAction:(NTESRecordTopBar *)bar
{
    [self.audioBar show];
}

- (void)TopBarBeautyAction:(NTESRecordTopBar *)bar on:(BOOL)isOn
{
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBar:beauty:)]) {
        [_delegate ControlBar:self beauty:isOn];
    }
}

- (void)TopBarFaceUSdkAction:(NTESRecordTopBar *)bar on:(BOOL)isOn
{
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBar:faceUOpen:)]) {
        [_delegate ControlBar:self faceUOpen:isOn];
    }
}

- (void)TopBarWaterAction:(NTESRecordTopBar *)bar type:(NSInteger)type loc:(NSInteger)loc
{
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBar:waterType:waterLoc:)]) {
        [_delegate ControlBar:self waterType:type waterLoc:loc];
    }
}

#pragma mark - 视频浮层工具栏 - <NTESVideoMaskBarDelegate>
- (void)MaskBar:(NTESVideoMaskBar *)slider exposureValueChanged:(CGFloat)exposure
{
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBar:exposure:)]) {
        [_delegate ControlBar:self exposure:exposure];
    }
}

- (void)MaskBar:(NTESVideoMaskBar *)slider focusInPoint:(CGPoint)point
{
    CGPoint dstPoint = [slider convertPoint:point toView:self];
    
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBar:focusPoint:)]) {
        [_delegate ControlBar:self focusPoint:dstPoint];
    }
}

- (void)MaskBar:(NTESVideoMaskBar *)slider zoomChanged:(CGFloat)zoom
{
    if (_delegate && [_delegate respondsToSelector:@selector(ContorlBar:zoom:)]) {
        [_delegate ContorlBar:self zoom:zoom];
    }
}

#pragma mark - 视频设置页面 - <NTESSettingViewProtocol>
- (void)NTESSettingView:(NTESSettingView *)view selectSection:(NSInteger)section
{
    _segmentLine.numbers = section;
    _configTipBtn.section = section;
    NSInteger duration = [_configEntity.durationDatas[_configEntity.curDurationIndex] integerValue];
    _recordBtn.duration = (CGFloat)duration/section;
}

- (void)NTESSettingView:(NTESSettingView *)view selectDuration:(NSInteger)duration
{
    _configTipBtn.duration = duration;
    NSInteger section = [_configEntity.sectionDatas[_configEntity.curSectionsIndex] integerValue];
    _recordBtn.duration = (CGFloat)duration/section;
}

- (void)NTESSettingView:(NTESSettingView *)view selectResolution:(NSInteger)resolution
{
    _configTipBtn.resolution = resolution;
    
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBar:resolution:)]) {
        [_delegate ControlBar:self resolution:resolution];
    }
}

- (void)NTESSettingView:(NTESSettingView *)view selectScreen:(NSInteger)screen
{
    _configTipBtn.scaleMode = screen;
    
    self.videoMaskBar.frame = [self videoMaskRectWithScreenScale:screen];
    self.videoMaskBar.centerX = self.width/2;
    CGRect videoRect = [self videoRectWithScreenScale:screen];
    
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBar:frame:mode:)]) {
        [_delegate ControlBar:self frame:videoRect mode:screen];
    }
}

#pragma mark - 录制按钮 - <NTESProcessBtnProtocol>
//录制动画已经开始了
- (void)NTESProcessBtnDidStart:(NTESProcessBtn *)processBtn
{
    [self switchToRecordUI];
    
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBarRecordDidStart:)]) {
        [_delegate ControlBarRecordDidStart:self];
    }
}

//录制动画已经结束了
- (void)NTESProcessBtnDidStop:(NTESProcessBtn *)processBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBarRecordAnimationDidStop:isCancel:)]) {
        [_delegate ControlBarRecordAnimationDidStop:self isCancel:_isCancelRecord];
    }
    
    [self switchToNormalUI];
}

#pragma mark - 手势 - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self.maskView);
}

#pragma mark - 音频 - <NTESMenuViewProtocol>
- (void)menuView:(NTESMenuView *)menu startPlayAudio:(NSString *)path {
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBarStartPlay:path:)]) {
        [_delegate ControlBarStartPlay:self path:path];
    }
}

- (void)menuViewStopPlayAudio:(NTESMenuView *)menu {
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBarStopPlay:)]) {
        [_delegate ControlBarStopPlay:self];
    }
}

- (void)menuView:(NTESMenuView *)menu mainAudioVolume:(CGFloat)volume {
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBarSetMacrophoneVolume:volume:)]) {
        [_delegate ControlBarSetMacrophoneVolume:self volume:volume];
    }
}

- (void)menuView:(NTESMenuView *)menu secAudioVolume:(CGFloat)volume {
    if (_delegate && [_delegate respondsToSelector:@selector(ControlBarSetAudioVolume:volume:)]) {
        [_delegate ControlBarSetAudioVolume:self volume:volume];
    }
}

#pragma mark - Setter
- (void)setConfigEntity:(NTESRecordConfigEntity *)configEntity
{
    _configEntity = configEntity;
    
    self.videoMaskBar.exposureValue = configEntity.exposureValue;
    
    self.beautyConfig.curValue = configEntity.beautyValue;
    self.filterConfig.datas = configEntity.filterDatas;
    self.filterConfig.selectIndex = configEntity.curFilterIndex;
    
    if (self.filterConfig.selectIndex > 4) //自定义滤镜
    {
        self.topBar.hiddenBeauty = NO;
        self.topBar.hiddenFilterConfig = YES;
    }
    else if (self.filterConfig.selectIndex < 2) //无和黑白滤镜
    {
        self.topBar.hiddenBeauty = YES;
        self.topBar.hiddenFilterConfig = YES;
    }
    else //其他滤镜支持强度设置
    {
        self.topBar.hiddenBeauty = YES;
        self.topBar.hiddenFilterConfig = NO;
    }
    self.topBar.isBeauty = configEntity.beauty;
    
    NSInteger section = [_configEntity.sectionDatas[_configEntity.curSectionsIndex] integerValue];
    NSInteger duration = [_configEntity.durationDatas[_configEntity.curDurationIndex] integerValue];
    
    self.recordBtn.duration = (CGFloat)duration/section;
    self.segmentLine.numbers = section;
    
    self.configTipBtn.section = section;
    self.configTipBtn.duration = duration;
    self.configTipBtn.scaleMode = configEntity.curScaleModeIndex;
    self.configTipBtn.resolution = configEntity.curResolutionIndex;
    
    CGRect frame = [self videoMaskRectWithScreenScale:configEntity.curScaleModeIndex];
    self.videoMaskBar.frame = frame;
    
    [self.settingView configWithEntity:configEntity];
}

- (void)setCompleteRecordSections:(NSInteger)completeRecordSections
{
    NSInteger section = [_configEntity.sectionDatas[_configEntity.curSectionsIndex] integerValue];
    
    if (completeRecordSections < 0)
    {
        completeRecordSections = 0;
    }
    else if (completeRecordSections > section)
    {
        completeRecordSections = section;
    }
    
    _completeRecordSections = completeRecordSections;
    
    self.segmentLine.selectCount = completeRecordSections;
    
    if (completeRecordSections == 0)
    {
        self.completeRecordBtn.hidden = YES;
        self.deleteRecordBtn.hidden = YES;
        self.recordBtn.titleStr = @"开始\n录制";
        self.recordBtn.userInteractionEnabled = YES;
        self.configTipBtn.hidden = NO;
    }
    else if (completeRecordSections == section)
    {
        self.completeRecordBtn.hidden = NO;
        self.deleteRecordBtn.hidden = NO;
        self.recordBtn.titleStr = @"完成\n录制";
        self.recordBtn.userInteractionEnabled = NO;
        self.configTipBtn.hidden = YES;
    }
    else
    {
        self.completeRecordBtn.hidden = NO;
        self.deleteRecordBtn.hidden = NO;
        self.recordBtn.titleStr = @"继续\n录制";
        self.recordBtn.userInteractionEnabled = YES;
        self.configTipBtn.hidden = YES;
    }
}

#pragma mark - Getter
- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.delegate = self;
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (NTESRecordTopBar *)topBar
{
    if (!_topBar) {
        _topBar = [[NTESRecordTopBar alloc] init];
        _topBar.delegate = self;
        _topBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _topBar;
}

- (NTESVideoMaskBar *)videoMaskBar
{
    if (!_videoMaskBar) {
        _videoMaskBar  = [[NTESVideoMaskBar alloc] init];
        _videoMaskBar.delegate = self;
    }
    return _videoMaskBar;
}

- (NTESProcessBtn *)recordBtn
{
    if (!_recordBtn) {
        _recordBtn = [[NTESProcessBtn alloc] init];
        _recordBtn.size = CGSizeMake(70, 70);
        _recordBtn.delegate = self;
    }
    return _recordBtn;
}

- (UIButton *)cancelRecordBtn
{
    if (!_cancelRecordBtn) {
        _cancelRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelRecordBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelRecordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelRecordBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_cancelRecordBtn setBackgroundImage:[UIImage imageNamed:@"white_btn"] forState:UIControlStateNormal];
        [_cancelRecordBtn setBackgroundImage:[UIImage imageNamed:@"white_btn_high"] forState:UIControlStateHighlighted];
        _cancelRecordBtn.tag = 10;
        [_cancelRecordBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelRecordBtn.size = CGSizeMake(62.0, 30.0);
    }
    return _cancelRecordBtn;
}

- (UIButton *)deleteRecordBtn
{
    if (!_deleteRecordBtn) {
        _deleteRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteRecordBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteRecordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteRecordBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_deleteRecordBtn setBackgroundImage:[UIImage imageNamed:@"white_btn"] forState:UIControlStateNormal];
        [_deleteRecordBtn setBackgroundImage:[UIImage imageNamed:@"white_btn_high"] forState:UIControlStateHighlighted];
        _deleteRecordBtn.tag = 11;
        [_deleteRecordBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteRecordBtn.size = CGSizeMake(62.0, 30.0);
    }
    return _deleteRecordBtn;
}

- (UIButton *)completeRecordBtn
{
    if (!_completeRecordBtn) {
        _completeRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeRecordBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_completeRecordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _completeRecordBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _completeRecordBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_completeRecordBtn setBackgroundImage:[UIImage imageNamed:@"white_btn"] forState:UIControlStateNormal];
        [_completeRecordBtn setBackgroundImage:[UIImage imageNamed:@"white_btn_high"] forState:UIControlStateHighlighted];
        _completeRecordBtn.tag = 12;
        [_completeRecordBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _completeRecordBtn.size = CGSizeMake(62.0, 30.0);
    }
    return _completeRecordBtn;
}

- (NTESSegmentView *)segmentLine
{
    if (!_segmentLine) {
        _segmentLine = [NTESSegmentView new];
        _segmentLine.backgroundColor = [UIColor clearColor];
    }
    
    return _segmentLine;
}

- (NTESConfigTipBtn *)configTipBtn
{
    if (!_configTipBtn) {
        _configTipBtn = [[NTESConfigTipBtn alloc] init];
        _configTipBtn.size = [_configTipBtn tipRect];
        _configTipBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _configTipBtn.layer.borderColor = UIColorFromRGB(0x5F5F5F).CGColor;
        _configTipBtn.layer.borderWidth = 0.5;
        _configTipBtn.tag = 13;
        [_configTipBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _configTipBtn;
}

- (NTESBeautyConfigView *)beautyConfig
{
    if (!_beautyConfig) {
        _beautyConfig = [[NTESBeautyConfigView alloc] init];
        _beautyConfig.maxValue = 40;
        _beautyConfig.minValue = 0;
        _beautyConfig.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _beautyConfig.secMinValue = 0;
        _beautyConfig.secMaxValue = 1;
        _beautyConfig.curValue = 0;
        
        __weak typeof(self) weakSelf = self;
        _beautyConfig.valueChangedBlock = ^(CGFloat value) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(ControlBar:smooth:)]) {
                [strongSelf.delegate ControlBar:strongSelf smooth:value];
            }
        };
        
        _beautyConfig.secValueChangedBlock = ^(CGFloat value) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(ControlBar:whitening:)]) {
                [strongSelf.delegate ControlBar:strongSelf whitening:value];
            }
        };
    }
    return _beautyConfig;
}

- (NTESFilterConfigView *)filterConfig
{
    if (!_filterConfig) {
        _filterConfig = [[NTESFilterConfigView alloc] init];
        _filterConfig.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        __weak typeof(self) weakSelf = self;
        _filterConfig.selectBlock = ^(NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(ControlBar:filter:)]) {
                [strongSelf.delegate ControlBar:strongSelf filter:index];
            }
            
            if (index > 4) //自定义滤镜
            {
                strongSelf.topBar.hiddenBeauty = NO;
                strongSelf.topBar.hiddenFilterConfig = YES;
            }
            else if (index < 2) //无和黑白滤镜
            {
                strongSelf.topBar.hiddenBeauty = YES;
                strongSelf.topBar.hiddenFilterConfig = YES;
            }
            else //其他滤镜支持强度设置
            {
                strongSelf.topBar.hiddenBeauty = YES;
                strongSelf.topBar.hiddenFilterConfig = NO;
            }
        };
    }
    return _filterConfig;
}

- (NTESSettingView *)settingView
{
    if (!_settingView) {
        _settingView = [[NTESSettingView alloc] init];
        _settingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _settingView.delegate = self;
    }
    return _settingView;
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

@end
