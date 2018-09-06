//
//  NTESBeautyConfigView.m
//  ShortVideoProcess_Demo
//
//  Created by Netease on 17/3/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESBeautyConfigView.h"
#import "NTESSlider.h"

@interface NTESBeautyConfigView ()

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *minValueLab;

@property (nonatomic, strong) UILabel *maxValueLab;

@property (nonatomic, strong) NTESSlider *slider;


@property (nonatomic, strong) UILabel *secTitleLab;

@property (nonatomic, strong) UILabel *secMinValueLab;

@property (nonatomic, strong) UILabel *secMaxValueLab;

@property (nonatomic, strong) NTESSlider *secSlider;

@end

@implementation NTESBeautyConfigView

- (void)doInit
{
    self.alpha = 0.0;
    [self addSubview:self.titleLab];
    [self addSubview:self.minValueLab];
    [self addSubview:self.slider];
    [self addSubview:self.maxValueLab];
    
    [self addSubview:self.secTitleLab];
    [self addSubview:self.secMinValueLab];
    [self addSubview:self.secMaxValueLab];
    [self addSubview:self.secSlider];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLab.frame = CGRectMake(16, 16.0, _titleLab.width, _titleLab.height);

    _minValueLab.size = CGSizeMake(24, _titleLab.height);
    _minValueLab.left = _titleLab.right + 8.0;
    _minValueLab.centerY = _titleLab.centerY;
    
    _maxValueLab.size = _minValueLab.size;
    _maxValueLab.right = self.width - 16.0;
    _maxValueLab.centerY = _titleLab.centerY;
    
    _slider.frame = CGRectMake(_minValueLab.right + 16.0,
                               8.0,
                               _maxValueLab.left - _minValueLab.right - 16.0*2,
                               self.height - 8.0*2);
    _slider.centerY = _titleLab.centerY;
    
    _secTitleLab.frame = CGRectMake(_titleLab.left, _titleLab.bottom + 16.0, _titleLab.width, _titleLab.height);
    _secMinValueLab.frame = CGRectMake(_minValueLab.left, _secTitleLab.top, _minValueLab.width, _minValueLab.height);
    _secMaxValueLab.frame = CGRectMake(_maxValueLab.left, _secTitleLab.top, _maxValueLab.width, _maxValueLab.height);
    _secSlider.frame = CGRectMake(_slider.left, _secTitleLab.top, _slider.width, _slider.height);

    _secMinValueLab.centerY = _secTitleLab.centerY;
    _secSlider.centerY = _secTitleLab.centerY;
    _secMaxValueLab.centerY = _secTitleLab.centerY;
}

#pragma mark - Public
- (void)showInView:(UIView *)view complete:(void (^)())complete
{
    [self removeFromSuperview];
    
    if (self.alpha == 0.0)
    {
        [view addSubview:self];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (complete) {
                complete();
            }
        }];
    }
    else
    {
        if (complete) {
            complete();
        }
    }
}

- (void)dismissComplete:(void (^)())complete
{
    if (self.alpha != 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (complete) {
                complete();
            }
        }];
    }
    else
    {
        if (complete) {
            complete();
        }
    }
}

#pragma mark - Setter
- (void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    _maxValueLab.text = [NSString stringWithFormat:@"%zi", (NSInteger)maxValue];
    _slider.maxValue = maxValue;
}

- (void)setMinValue:(CGFloat)minValue
{
    _minValue = minValue;
    _minValueLab.text = [NSString stringWithFormat:@"%zi", (NSInteger)minValue];
    _slider.minValue = minValue;
}

- (void)setCurValue:(CGFloat)curValue
{
    if (curValue < _minValue) {
        curValue = _minValue;
    }
    if (curValue > _maxValue) {
        curValue = _maxValue;
    }
    
    _curValue = curValue;
    _slider.value = curValue;
}

- (void)setSecMaxValue:(CGFloat)secMaxValue
{
    _secMaxValue = secMaxValue;
    _secMaxValueLab.text = [NSString stringWithFormat:@"%zi", (NSInteger)secMaxValue];
    _secSlider.maxValue = secMaxValue;
}

- (void)setSecMinValue:(CGFloat)secMinValue
{
    _secMinValue = secMinValue;
    
    _secMinValueLab.text = [NSString stringWithFormat:@"%zi", (NSInteger)secMinValue];
    _secSlider.minValue = secMinValue;
}

- (void)setSecCurValue:(CGFloat)secCurValue
{
    if (secCurValue < _secMinValue) {
        secCurValue = _secMinValue;
    }
    if (secCurValue > _secMaxValue) {
        secCurValue = _secMaxValue;
    }
    
    _secCurValue = secCurValue;
    _secSlider.value = secCurValue;
}

#pragma mark - Getter
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithWhite:1 alpha:0.4];
        _titleLab.font = [UIFont systemFontOfSize:14.0];
        _titleLab.text = @"滤镜强度";
        [_titleLab sizeToFit];
    }
    return _titleLab;
}

- (UILabel *)minValueLab
{
    if (!_minValueLab) {
        _minValueLab = [[UILabel alloc] init];
        _minValueLab.textAlignment = NSTextAlignmentCenter;
        _minValueLab.textColor = [UIColor colorWithWhite:1 alpha:0.4];
        _minValueLab.font = [UIFont systemFontOfSize:14.0];
        _minValueLab.text = @"00";
    }
    return _minValueLab;
}

- (UILabel *)maxValueLab
{
    if (!_maxValueLab) {
        _maxValueLab = [[UILabel alloc] init];
        _maxValueLab = [[UILabel alloc] init];
        _maxValueLab.textAlignment = NSTextAlignmentCenter;
        _maxValueLab.textColor = [UIColor colorWithWhite:1 alpha:0.4];
        _maxValueLab.font = [UIFont systemFontOfSize:14.0];
        _maxValueLab.text = @"10";
    }
    return _maxValueLab;
}

- (NTESSlider *)slider
{
    if (!_slider) {
        _slider = [[NTESSlider alloc] init];
        _slider.maxValue = 10.0;
        _slider.minValue = 0.0;
        
        UIImage *thumbImg = [UIImage imageNamed:@"beauty_slider_thumb"];
        _slider.thumbImage = thumbImg;
        
        __weak typeof(self) weakSelf = self;
        _slider.valueChangedBlock = ^(CGFloat value) {
            if (weakSelf.valueChangedBlock) {
                weakSelf.valueChangedBlock(value);
            }
            
            weakSelf.minValueLab.text = [NSString stringWithFormat:@"%zi", (NSInteger)value];
        };
    }
    return _slider;
}

- (UILabel *)secTitleLab
{
    if (!_secTitleLab) {
        _secTitleLab = [[UILabel alloc] init];
        _secTitleLab.textColor = [UIColor colorWithWhite:1 alpha:0.4];
        _secTitleLab.font = [UIFont systemFontOfSize:14.0];
        _secTitleLab.text = @"磨皮强度";
        [_secTitleLab sizeToFit];
    }
    return _secTitleLab;
}

- (UILabel *)secMinValueLab
{
    if (!_secMinValueLab) {
        _secMinValueLab = [[UILabel alloc] init];
        _secMinValueLab.textAlignment = NSTextAlignmentCenter;
        _secMinValueLab.textColor = [UIColor colorWithWhite:1 alpha:0.4];
        _secMinValueLab.font = [UIFont systemFontOfSize:14.0];
        _secMinValueLab.text = @"0.0";
    }
    return _secMinValueLab;
}

- (UILabel *)secMaxValueLab
{
    if (!_secMaxValueLab) {
        _secMaxValueLab = [[UILabel alloc] init];
        _secMaxValueLab = [[UILabel alloc] init];
        _secMaxValueLab.textAlignment = NSTextAlignmentCenter;
        _secMaxValueLab.textColor = [UIColor colorWithWhite:1 alpha:0.4];
        _secMaxValueLab.font = [UIFont systemFontOfSize:14.0];
        _secMaxValueLab.text = @"10";
    }
    return _secMaxValueLab;
}

- (NTESSlider *)secSlider
{
    if (!_secSlider) {
        _secSlider = [[NTESSlider alloc] init];
        _secSlider.maxValue = 10.0;
        _secSlider.minValue = 0.0;
        
        UIImage *thumbImg = [UIImage imageNamed:@"beauty_slider_thumb"];
        _secSlider.thumbImage = thumbImg;
        
        __weak typeof(self) weakSelf = self;
        _secSlider.valueChangedBlock = ^(CGFloat value) {
            if (weakSelf.secValueChangedBlock) {
                weakSelf.secValueChangedBlock(value);
            }
            
            weakSelf.secMinValueLab.text = [NSString stringWithFormat:@"%.1f", value];
        };
    }
    return _secSlider;
}

@end
