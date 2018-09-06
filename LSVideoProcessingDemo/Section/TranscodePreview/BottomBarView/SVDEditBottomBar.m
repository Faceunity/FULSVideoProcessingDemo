//
//  SVDEditBottomBar.m
//  ShortVideo_Demo
//
//  Created by Netease on 17/2/20.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDEditBottomBar.h"

@interface SVDEditBottomBar ()

@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation SVDEditBottomBar

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
    [self addSubview:self.backBtn];
    [self addSubview:self.sureBtn];
    [self addSubview:self.saveBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.sureBtn.frame = CGRectMake(0, 0, 60, 60);
    self.sureBtn.center = CGPointMake(self.width/2, self.height/2);
    self.sureBtn.layer.cornerRadius = _sureBtn.width/2;
    self.backBtn.frame = CGRectMake(_sureBtn.left - 60 - 60,
                                    _sureBtn.top,
                                    _sureBtn.width,
                                    _sureBtn.height);
    self.saveBtn.frame = CGRectMake(_sureBtn.right + 60,
                                    _sureBtn.top,
                                    _sureBtn.width,
                                    _sureBtn.height);
}

- (void)setEnableSave:(BOOL)enableSave
{
    _enableSave = enableSave;
    _saveBtn.enabled = enableSave;
}

#pragma mark - Action
- (void)btnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 10: //确定
        {
            if (_delegate && [_delegate respondsToSelector:@selector(SVDEditBottomBarSureAction:)]) {
                [_delegate SVDEditBottomBarSureAction:self];
            }
            break;
        }
        case 11: //返回
        {
            if (_delegate && [_delegate respondsToSelector:@selector(SVDEditBottomBarBackAction:)]) {
                [_delegate SVDEditBottomBarBackAction:self];
            }
            break;
        }
        case 12: //保存
        {
            if (_delegate && [_delegate respondsToSelector:@selector(SVDEditBottomBarSaveAction:)]) {
                [_delegate SVDEditBottomBarSaveAction:self];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Setter/Getter
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = [UIColor redColor];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _sureBtn.tag = 10;
        [_sureBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        _backBtn.tag = 11;
        [_backBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.tag = 12;
        _saveBtn.enabled = NO;
        [_saveBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

@end
