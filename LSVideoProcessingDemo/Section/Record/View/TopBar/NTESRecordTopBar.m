//
//  NTESRecordTopBar.m
//  ShortVideoProcess_Demo
//
//  Created by Netease on 17/3/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESRecordTopBar.h"

@interface NTESRecordTopBar ()

@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) UIButton *beautyBtn;
@property (nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *audioBtn;

@property (nonatomic, strong) UISwitch *switchBtn;
@property (nonatomic, strong) UILabel *switchLab;
@property (nonatomic, strong) UISwitch *sdkSwitchBtn;
@property (nonatomic, strong) UILabel *sdkSwitchLab;

@property (nonatomic, strong) UISegmentedControl *waterTypeSeg;
@property (nonatomic, strong) UISegmentedControl *waterLocationSeg;

@end

@implementation NTESRecordTopBar

- (void)doInit
{
    [self addSubview:self.quitBtn];
    [self addSubview:self.beautyBtn];
    [self addSubview:self.filterBtn];
    [self addSubview:self.audioBtn];
    [self addSubview:self.cameraBtn];
    [self addSubview:self.switchBtn];
    [self addSubview:self.switchLab];
    [self addSubview:self.sdkSwitchLab];
    [self addSubview:self.sdkSwitchBtn];
    [self addSubview:self.waterTypeSeg];
    [self addSubview:self.waterLocationSeg];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = 44.0;
    
    _quitBtn.frame = CGRectMake(0, (MAStatusBarHeight) - 20, width, width);
    _cameraBtn.frame = CGRectMake(self.width - width, _quitBtn.top, width, width);
    _audioBtn.frame = CGRectMake(_cameraBtn.left - 8.0 - width, _cameraBtn.top, width, width);
    _filterBtn.frame = CGRectMake(_audioBtn.left - 8.0 - width, _cameraBtn.top, width, width);
    _sdkSwitchBtn.right = _filterBtn.left - 8.0;
    _sdkSwitchBtn.centerY = _filterBtn.centerY;
    _sdkSwitchLab.top = _sdkSwitchBtn.bottom + 2.0;
    _sdkSwitchLab.centerX = _sdkSwitchBtn.centerX;
    
    _beautyBtn.frame = CGRectMake(_sdkSwitchLab.left - 8.0 - width, _filterBtn.top, width, width);
    _switchBtn.right = _sdkSwitchBtn.left - 8.0;
    _switchBtn.centerY = _sdkSwitchBtn.centerY;
    _switchLab.top = _switchBtn.bottom + 2.0;
    _switchLab.centerX = _switchBtn.centerX;
    
    _waterTypeSeg.size = CGSizeMake(180, 28);
    _waterTypeSeg.top = _sdkSwitchLab.bottom + 8.0;
    _waterTypeSeg.right = _cameraBtn.right;
    
    _waterLocationSeg.size = CGSizeMake(300, 28);
    _waterLocationSeg.top = _waterTypeSeg.bottom + 8.0;
    _waterLocationSeg.right = _cameraBtn.right;
}

#pragma mark - Action
- (void)btnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 10: //退出
        {
            if (_delegate && [_delegate respondsToSelector:@selector(TopBarQuitAction:)]) {
                [_delegate TopBarQuitAction:self];
            }
            break;
        }
        case 11: //美颜
        {
            if (_delegate && [_delegate respondsToSelector:@selector(TopBarFilterConfigAction:)]) {
                [_delegate TopBarFilterConfigAction:self];
            }
            
            break;
        }
        case 12: //滤镜
        {
            if (_delegate && [_delegate respondsToSelector:@selector(TopBarFilterAction:)]) {
                [_delegate TopBarFilterAction:self];
            }
            break;
        }
        case 13: //相机
        {
            if (_delegate && [_delegate respondsToSelector:@selector(TopBarCameraAction:)]) {
                [_delegate TopBarCameraAction:self];
            }
            break;
        }
        case 14: //伴音
        {
            if (_delegate && [_delegate respondsToSelector:@selector(TopBarAudioAction:)]) {
                [_delegate TopBarAudioAction:self];
            }
        }
        default:
            break;
    }
}

- (void)switchAction:(UISwitch *)sender
{
    if (sender.tag == 21)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(TopBarBeautyAction:on:)]) {
            [_delegate TopBarBeautyAction:self on:sender.isOn];
        }
    }
    else if (sender.tag == 22)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(TopBarFaceUSdkAction:on:)]) {
            [_delegate TopBarFaceUSdkAction:self on:sender.isOn];
        }
    }
}

- (void)segAction:(UISegmentedControl *)seg
{
    if (seg.tag == 31 || seg.tag == 32)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(TopBarWaterAction:type:loc:)]) {
            [_delegate TopBarWaterAction:self
                                    type:_waterTypeSeg.selectedSegmentIndex
                                     loc:_waterLocationSeg.selectedSegmentIndex];
        }
    }
}

#pragma mark - Getter
- (UIButton *)quitBtn
{
    if (!_quitBtn) {
        _quitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_quitBtn setTitle:@"退出" forState:UIControlStateNormal];
        _quitBtn.tag = 10;
        [_quitBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}

- (UIButton *)beautyBtn
{
    if (!_beautyBtn) {
        _beautyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_beautyBtn setTitle:@"美颜" forState:UIControlStateNormal];
        _beautyBtn.tag = 11;
        [_beautyBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautyBtn;
}

- (UIButton *)filterBtn
{
    if (!_filterBtn) {
        _filterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_filterBtn setTitle:@"滤镜" forState:UIControlStateNormal];
        _filterBtn.tag = 12;
        [_filterBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterBtn;
}

- (UIButton *)cameraBtn
{
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cameraBtn setTitle:@"相机" forState:UIControlStateNormal];
        _cameraBtn.tag = 13;
        [_cameraBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

- (UIButton *)audioBtn {
    if (!_audioBtn) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_audioBtn setTitle:@"伴音" forState:UIControlStateNormal];
        _audioBtn.tag = 14;
        [_audioBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioBtn;
}

- (UISwitch *)switchBtn
{
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc] init];
        _switchBtn.tag = 21;
        [_switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}

- (UILabel *)switchLab
{
    if (!_switchLab) {
        _switchLab = [[UILabel alloc] init];
        _switchLab.font = [UIFont systemFontOfSize:12.0];
        _switchLab.textColor = [UIColor blueColor];
        _switchLab.text = @"美颜开关";
        [_switchLab sizeToFit];
    }
    return _switchLab;
}

- (void)setHiddenBeauty:(BOOL)hiddenBeauty
{
    _hiddenBeauty = hiddenBeauty;
    
    _switchBtn.hidden = hiddenBeauty;
    _switchLab.hidden = hiddenBeauty;
}

- (void)setHiddenFilterConfig:(BOOL)hiddenFilterConfig
{
    _hiddenFilterConfig = hiddenFilterConfig;
    
    _beautyBtn.hidden = hiddenFilterConfig;
}
- (void)setIsBeauty:(BOOL)isBeauty
{
    _isBeauty = isBeauty;
    
    _switchBtn.on = isBeauty;
}


- (UISwitch *)sdkSwitchBtn
{
    if (!_sdkSwitchBtn) {
        _sdkSwitchBtn = [[UISwitch alloc] init];
        _sdkSwitchBtn.tag = 22;
        _sdkSwitchBtn.on = YES;
        [_sdkSwitchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _sdkSwitchBtn;
}

- (UILabel *)sdkSwitchLab
{
    if (!_sdkSwitchLab) {
        _sdkSwitchLab = [[UILabel alloc] init];
        _sdkSwitchLab.font = [UIFont systemFontOfSize:12.0];
        _sdkSwitchLab.textColor = [UIColor blueColor];
        _sdkSwitchLab.text = @"FaceU开关";
        [_sdkSwitchLab sizeToFit];
    }
    return _sdkSwitchLab;
}

- (UISegmentedControl *)waterTypeSeg
{
    if (!_waterTypeSeg)
    {
        _waterTypeSeg = [[UISegmentedControl alloc] initWithItems:@[@"无水印", @"静态水印", @"动态水印"]];
        _waterTypeSeg.tag = 31;
        _waterTypeSeg.selectedSegmentIndex = 0;
        [_waterTypeSeg addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _waterTypeSeg;
}

- (UISegmentedControl *)waterLocationSeg
{
    if (!_waterLocationSeg)
    {
        _waterLocationSeg = [[UISegmentedControl alloc] initWithItems:@[@"自定义", @"左上", @"左下", @"右上", @"右下", @"中心"]];
        _waterLocationSeg.selectedSegmentIndex = 0;
        _waterLocationSeg.tag = 32;
        [_waterLocationSeg addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _waterLocationSeg;
}

@end
