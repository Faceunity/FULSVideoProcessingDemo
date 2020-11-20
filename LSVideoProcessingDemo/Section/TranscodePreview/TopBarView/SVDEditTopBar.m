//
//  SVDEditTopBar.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 17/2/22.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDEditTopBar.h"

@interface SVDEditTopBar ()

@property (nonatomic, strong) UIButton *audioBtn;

@property (nonatomic, strong) UIButton *adjustBtn;

@property (nonatomic, strong) UIButton *imgBtn;

@property (nonatomic, strong) UIButton *filterBtn;

@property (nonatomic, strong) UISwitch *faceUSwitch;

@property (nonatomic, strong) UILabel *faceULabel;

@end

@implementation SVDEditTopBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    [self addSubview:self.audioBtn];
    [self addSubview:self.adjustBtn];
    [self addSubview:self.imgBtn];
    [self addSubview:self.filterBtn];
    [self addSubview:self.faceUSwitch];
    [self addSubview:self.faceULabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.filterBtn.frame = CGRectMake(0, (MAStatusBarHeight) - 20, self.width/5, self.height);
    self.adjustBtn.frame = CGRectMake(self.filterBtn.right, 0, self.width/5, self.height);
    self.audioBtn.frame = CGRectMake(self.adjustBtn.right, 0, self.width/5, self.height);
    self.imgBtn.frame = CGRectMake(self.audioBtn.right, 0, self.width/5, self.height);
    self.faceUSwitch.frame = CGRectMake(self.imgBtn.right, 16.0, self.width/5, self.faceUSwitch.height);
    self.faceULabel.top = self.faceUSwitch.bottom + 4.0;
    self.faceULabel.centerX = self.faceUSwitch.centerX;
}

- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 10)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(SVDEditTopBarAudioAction:)]) {
            [_delegate SVDEditTopBarAudioAction:self];
        }
    }
    else if (btn.tag == 11)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(SVDEditTopBarAdjustAction:)]) {
            [_delegate SVDEditTopBarAdjustAction:self];
        }
    }
    else if (btn.tag == 12)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(SVDEditTopBarImageAction:)]) {
            [_delegate SVDEditTopBarImageAction:self];
        }
    }
    else if (btn.tag == 13)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(SVDEditTopBarFilterAction:)]) {
            [_delegate SVDEditTopBarFilterAction:self];
        }
    }
    else if (btn.tag == 14)
    {
        btn.selected = !btn.isSelected;
        if (_delegate && [_delegate respondsToSelector:@selector(SVDEditTopBarFaceUAction:isOn:)]) {
            [_delegate SVDEditTopBarFaceUAction:self isOn:btn.isSelected];
        }
    }
}

- (void)switchAction:(UISwitch *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(SVDEditTopBarFaceUAction:isOn:)]) {
        [_delegate SVDEditTopBarFaceUAction:self isOn:sender.isOn];
    }
}

#pragma mark - Getter
- (UIButton *)audioBtn
{
    if (!_audioBtn) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _audioBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_audioBtn setTitle:@"音乐" forState:UIControlStateNormal];
        _audioBtn.tag = 10;
        [_audioBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioBtn;
}

- (UIButton *)adjustBtn
{
    if (!_adjustBtn)
    {
        _adjustBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _adjustBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_adjustBtn setTitle:@"调整" forState:UIControlStateNormal];
        _adjustBtn.tag = 11;
        [_adjustBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _adjustBtn;
}

- (UIButton *)imgBtn
{
    if (!_imgBtn)
    {
        _imgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _imgBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_imgBtn setTitle:@"贴图" forState:UIControlStateNormal];
        _imgBtn.tag = 12;
        [_imgBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgBtn;
}

- (UIButton *)filterBtn
{
    if (!_filterBtn) {
        _filterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _filterBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_filterBtn setTitle:@"滤镜" forState:UIControlStateNormal];
        _filterBtn.tag = 13;
        [_filterBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterBtn;
}

- (UISwitch *)faceUSwitch
{
    if (!_faceUSwitch) {
        _faceUSwitch = [[UISwitch alloc] init];
        _faceUSwitch.on = YES;
        [_faceUSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _faceUSwitch;
}

- (UILabel *)faceULabel
{
    if (!_faceULabel) {
        _faceULabel = [[UILabel alloc] init];
        _faceULabel.text = @"faceU开关";
        _faceULabel.font = [UIFont systemFontOfSize:11.0];
        _faceULabel.textColor = [UIColor blueColor];
        [_faceULabel sizeToFit];
    }
    return _faceULabel;
}

@end
