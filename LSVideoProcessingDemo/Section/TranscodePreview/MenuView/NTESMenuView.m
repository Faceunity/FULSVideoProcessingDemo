//
//  NTESMenuView.m
//  NEUIDemo
//
//  Created by Netease on 17/1/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESMenuView.h"
#import "NTESAudioMenuBar.h"
#import "NTESAdjustBar.h"
#import "NTESFilterBar.h"

@interface NTESMenuView ()
@property (nonatomic, assign) NTESMenuType type;
@property (nonatomic, strong) NTESAudioMenuBar *audioBar;
@property (nonatomic, strong) NTESAdjustBar *adjustBar;
@property (nonatomic, strong) NTESMenuBaseBar *bar;
@property (nonatomic, strong) NTESFilterBar *filterBar;
@end

@implementation NTESMenuView

- (instancetype)initWithType:(NTESMenuType)type
{
    if (self = [super init])
    {
        _type = type;
        
        self.frame = [UIScreen mainScreen].bounds;
        
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:self.bar];
    }
    return self;
}


- (void)onTapBackground:(id)sender
{
    [self dismiss];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bar.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom = self.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)defaultValue
{
    [_adjustBar defaultValue];
}

#pragma mark - Getter/Setter
- (UIView *)bar
{
    switch (_type)
    {
        case NTESMenuTypeAudio:
        {
            return self.audioBar;
        }
        case NTESMenuTypeAdjust:
        {
            return self.adjustBar;
        }
        case NTESMenuTypeFilter:
        {
            return self.filterBar;
        }
        default:
        {
            return [[UIView alloc] initWithFrame:CGRectZero];
        }
    }
}

- (NTESAudioMenuBar *)audioBar
{
    if (!_audioBar)
    {
        _audioBar = [[NTESAudioMenuBar alloc] init];
        _audioBar.frame = CGRectMake(0, self.height, self.width, _audioBar.barHeight);
        
        __weak typeof(self) weakSelf = self;
        _audioBar.selectBlock = ^(NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            //选择回调
            if (index == 0)
            {
                if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuViewStopPlayAudio:)]) {
                    [strongSelf.delegate menuViewStopPlayAudio:strongSelf];
                }
            }
            else
            {
                if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:startPlayAudio:)]) {
                    [strongSelf.delegate menuView:strongSelf startPlayAudio:strongSelf.audioPaths[index]];
                }
            }
        };
        
        _audioBar.volumeBlock = ^(CGFloat value){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:mainAudioVolume:)]) {
                [strongSelf.delegate menuView:strongSelf mainAudioVolume:value];
            }
        };
        
        _audioBar.audioVolumeBlock = ^(CGFloat value) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:secAudioVolume:)]) {
                [strongSelf.delegate menuView:strongSelf secAudioVolume:value];
            }
        };
    }
    return _audioBar;
}

- (NTESAdjustBar *)adjustBar
{
    if (!_adjustBar)
    {
        _adjustBar = [[NTESAdjustBar alloc] init];
        _adjustBar.frame = CGRectMake(0, 0, self.width, 196);
        
        __weak typeof(self) weakSelf = self;
        _adjustBar.brightnessBlock = ^(CGFloat value){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:brightness:)]) {
                [strongSelf.delegate menuView:strongSelf brightness:value];
            }
        };
        
        _adjustBar.contrastBlock = ^(CGFloat value){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:contrast:)]) {
                [strongSelf.delegate menuView:strongSelf contrast:value];
            }
        };
        
        _adjustBar.saturationBlock = ^(CGFloat value){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:saturation:)]) {
                [strongSelf.delegate menuView:strongSelf saturation:value];
            }
        };
        
        _adjustBar.sharpnessBlock = ^(CGFloat value){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:sharpness:)]) {
                [strongSelf.delegate menuView:strongSelf sharpness:value];
            }
        };
        
        _adjustBar.hueBlock = ^(CGFloat value){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:hue:)]) {
                [strongSelf.delegate menuView:strongSelf hue:value];
            }
        };
    }
    return _adjustBar;
}

- (NTESFilterBar *)filterBar
{
    if (!_filterBar) {
        _filterBar = [[NTESFilterBar alloc] init];
        __weak typeof(self) weakSelf = self;
        _filterBar.frame = CGRectMake(0, 0, self.width, 168);
        _filterBar.selectBlock = ^(NSInteger index){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:filter:)]) {
                [strongSelf.delegate menuView:strongSelf filter:index];
            }
        };
        
        _filterBar.whiteningBlock = ^(CGFloat value){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:whitening:)]) {
                [strongSelf.delegate menuView:strongSelf whitening:value];
            }
        };
        
        _filterBar.smoothBlock = ^(CGFloat value){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:smooth:)]) {
                [strongSelf.delegate menuView:strongSelf smooth:value];
            }
        };
        
        _filterBar.beautyBlock = ^(BOOL isOn){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:beauty:)]) {
                [strongSelf.delegate menuView:strongSelf beauty:isOn];
            }
        };
    }
    return _filterBar;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    self.bar.selectedIndex = selectedIndex;
    _selectedIndex = selectedIndex;
}

- (void)setAudioPaths:(NSArray *)audioPaths
{
    _audioPaths = audioPaths;
    _audioBar.audioPaths = audioPaths;
}

- (void)setFilterTypes:(NSArray *)filterTypes
{
    _filterTypes = filterTypes;
    
    _filterBar.datas = filterTypes;
}

@end

