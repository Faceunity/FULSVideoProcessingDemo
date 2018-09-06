//
//  SVDOutputFileConfigVC.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/29.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDOutputFileConfigVC.h"
#import "SVDOutputConfigView.h"

@interface SVDOutputFileConfigVC ()

@property (nonatomic, strong) UIScrollView *container;
@property (nonatomic, strong) SVDOutputConfigView *config;

@end

@implementation SVDOutputFileConfigVC
@synthesize configData = _configData;

- (void)dealloc {
    NSLog(@"[转码测试Demo] SVDOutputFileConfigVC 释放!");
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _container = [[UIScrollView alloc] init];
    _container.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _container.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_container];
    _config = [SVDOutputConfigView instance];
    [_container addSubview:_config];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _container.frame = self.view.bounds;
    _config.frame = CGRectMake(0, 8, _container.width, [SVDOutputConfigView cellHeight]);
    _container.contentSize = CGSizeMake(_container.width, _config.height + 16.0);
}

- (void)setConfigData:(SVDOutputFileConfigModel *)configData
{
    _config.configData = configData;
}

- (SVDOutputFileConfigModel *)configData
{
    return _config.configData;
}
@end

@implementation SVDOutputFileConfigModel

- (instancetype)init
{
    if (self = [super init])
    {
        _videoWidth = 0;
        _videoHeight = 0;
        _videoQuality = 0;
        _videoScaleMode = 1;
        
        _videoFadeDurationS = 0;
        _videoFadeOpacity = 0.0;
        _audioFadeDurationS = 0;
        
        _mainVolumeIntensity = 1.0;
        _audioVolumeIntensity = 1.0;
        _isMixedMainAudio = YES;
        _isMute = YES;
        
        _begineTimeS = 0;
        _durationS = 0;
        
        _cropW = 0;
        _cropY = 0;
        _cropW = 0;
        _cropW = 0;
        
        _filterType = 0;
        _whiting = 0.0;
        _smooth = 0.0;
        _brightness = 0.0;
        _contrast = 1.0;
        _saturation = 1.0;
        _sharpness = 0.0;
        _hue = 0.0;
        
        _location = 0;
        _uiX = 0;
        _uiY = 0;
        _uiWidth = 0;
        _uiHeight = 0;
        _uiBeginTime = 0;
        _uiDuration = 0;
    }
    return self;
}

- (BOOL)isNeedCut
{
    return (_begineTimeS != 0 || _durationS!= 0);
}

- (BOOL)isNeedCrop
{
    return (_cropX != 0 || _cropY != 0 || _cropW != 0 || _cropH != 0);
}

- (BOOL)isNeedWaterMark
{
    return (_location != 0 ||_uiX != 0 || _uiY != 0 || _uiWidth != 0 || _uiHeight != 0 || _uiBeginTime != 0 || _uiDuration != 0);
}
@end
