//
//  NTESAdjustBar.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 17/6/21.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESAdjustBar.h"

@interface NTESAdjustBar ()

@property (nonatomic, strong) UILabel *brightnessTitle;
@property (nonatomic, strong) UILabel *brightnessMinLab;
@property (nonatomic, strong) UILabel *brightnessMaxLab;
@property (nonatomic, strong) UISlider *brightnessSlider;

@property (nonatomic, strong) UILabel *contrastTitle;
@property (nonatomic, strong) UILabel *contrastMinLab;
@property (nonatomic, strong) UILabel *contrastMaxLab;
@property (nonatomic, strong) UISlider *contrastSlider;

@property (nonatomic, strong) UILabel *saturationTitle;
@property (nonatomic, strong) UILabel *saturationMinLab;
@property (nonatomic, strong) UILabel *saturationMaxLab;
@property (nonatomic, strong) UISlider *saturationSlider;

@property (nonatomic, strong) UILabel *sharpnessTitle;
@property (nonatomic, strong) UILabel *sharpnessMinLab;
@property (nonatomic, strong) UILabel *sharpnessMaxLab;
@property (nonatomic, strong) UISlider *sharpnessSlider;

@property (nonatomic, strong) UILabel *hueTitle;
@property (nonatomic, strong) UILabel *hueMinLab;
@property (nonatomic, strong) UILabel *hueMaxLab;
@property (nonatomic, strong) UISlider *hueSlider;
@end

@implementation NTESAdjustBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.brightnessTitle];
        [self addSubview:self.brightnessMinLab];
        [self addSubview:self.brightnessSlider];
        [self addSubview:self.brightnessMaxLab];
        
        [self addSubview:self.contrastTitle];
        [self addSubview:self.contrastMinLab];
        [self addSubview:self.contrastSlider];
        [self addSubview:self.contrastMaxLab];
        
        [self addSubview:self.saturationTitle];
        [self addSubview:self.saturationMinLab];
        [self addSubview:self.saturationSlider];
        [self addSubview:self.saturationMaxLab];
        
        [self addSubview:self.sharpnessTitle];
        [self addSubview:self.sharpnessMinLab];
        [self addSubview:self.sharpnessSlider];
        [self addSubview:self.sharpnessMaxLab];
        
        [self addSubview:self.hueTitle];
        [self addSubview:self.hueMinLab];
        [self addSubview:self.hueSlider];
        [self addSubview:self.hueMaxLab];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _brightnessTitle.frame = CGRectMake(8, 16, 40, 20);
    
    _brightnessMinLab.size = CGSizeMake(25, 20);
    _brightnessMinLab.left = _brightnessTitle.right + 8.0;
    _brightnessMinLab.centerY = _brightnessTitle.centerY;
    _brightnessMaxLab.size = _brightnessMinLab.size;
    _brightnessMaxLab.right = self.width - 8;
    _brightnessMaxLab.centerY = _brightnessMinLab.centerY;
    _brightnessSlider.frame = CGRectMake(_brightnessMinLab.right + 8.0,
                                         _brightnessMinLab.top,
                                         _brightnessMaxLab.left - 8.0 - _brightnessMinLab.right - 8.0,
                                         _brightnessMinLab.height);
    
    
    _contrastTitle.size = _brightnessTitle.size;
    _contrastTitle.top = _brightnessTitle.bottom + 16.0;
    _contrastTitle.left = _brightnessTitle.left;
    _contrastMinLab.size = _brightnessMinLab.size;
    _contrastMinLab.centerY = _contrastTitle.centerY;
    _contrastMinLab.left = _brightnessMinLab.left;
    _contrastSlider.size = _brightnessSlider.size;
    _contrastSlider.centerY = _contrastMinLab.centerY;
    _contrastSlider.left = _brightnessSlider.left;
    _contrastMaxLab.size = _brightnessMaxLab.size;
    _contrastMaxLab.centerY = _contrastMinLab.centerY;
    _contrastMaxLab.left = _brightnessMaxLab.left;
    
    _saturationTitle.size = _contrastTitle.size;
    _saturationTitle.top = _contrastTitle.bottom + 16.0;
    _saturationTitle.left = _contrastTitle.left;
    _saturationMinLab.size = _contrastMinLab.size;
    _saturationMinLab.centerY = _saturationTitle.centerY;
    _saturationMinLab.left = _contrastMinLab.left;
    _saturationSlider.size = _contrastSlider.size;
    _saturationSlider.centerY = _saturationMinLab.centerY;
    _saturationSlider.left = _contrastSlider.left;
    _saturationMaxLab.size = _contrastMaxLab.size;
    _saturationMaxLab.centerY = _saturationMinLab.centerY;
    _saturationMaxLab.left = _contrastMaxLab.left;
    
    _sharpnessTitle.size = _saturationTitle.size;
    _sharpnessTitle.top = _saturationTitle.bottom + 16.0;
    _sharpnessTitle.left = _saturationTitle.left;
    _sharpnessMinLab.size = _saturationMinLab.size;
    _sharpnessMinLab.centerY = _sharpnessTitle.centerY;
    _sharpnessMinLab.left = _saturationMinLab.left;
    _sharpnessSlider.size = _saturationSlider.size;
    _sharpnessSlider.centerY = _sharpnessTitle.centerY;
    _sharpnessSlider.left = _saturationSlider.left;
    _sharpnessMaxLab.size = _saturationMinLab.size;
    _sharpnessMaxLab.centerY = _sharpnessTitle.centerY;
    _sharpnessMaxLab.left = _saturationMaxLab.left;
    
    _hueTitle.size = _sharpnessTitle.size;
    _hueTitle.top = _sharpnessTitle.bottom + 16.0;
    _hueTitle.left = _sharpnessTitle.left;
    _hueMinLab.size = _sharpnessMinLab.size;
    _hueMinLab.left = _sharpnessMinLab.left;
    _hueMinLab.centerY = _hueTitle.centerY;
    _hueSlider.size = _sharpnessSlider.size;
    _hueSlider.left = _sharpnessSlider.left;
    _hueSlider.centerY = _hueTitle.centerY;
    _hueMaxLab.size = _hueMinLab.size;
    _hueMaxLab.left = _sharpnessMaxLab.left;
    _hueMaxLab.centerY = _hueTitle.centerY;
}

#pragma mark - Action
- (void)sliderAction:(UISlider *)slider
{
    CGFloat value = slider.value;
    NSString *string = @"";
    if (slider.tag == 10) //亮度
    {
        string = [NSString stringWithFormat:@"%.1f", value];
        _brightnessMinLab.text = string;
        
        if (_brightnessBlock) {
            _brightnessBlock(value);
        }
    }
    else if (slider.tag == 11) //对比度
    {
        string = [NSString stringWithFormat:@"%.1f", value];
        _contrastMinLab.text = string;
        
        if (_contrastBlock) {
            _contrastBlock(value);
        }
    }
    else if (slider.tag == 12) //饱和度
    {
        string = [NSString stringWithFormat:@"%.1f", value];
        _saturationMinLab.text = string;
        
        if (_saturationBlock) {
            _saturationBlock(value);
        }
    }
    else if (slider.tag == 13) //锐度
    {
        string = [NSString stringWithFormat:@"%.1f", value];
        _sharpnessMinLab.text = string;
        
        if (_sharpnessBlock) {
            _sharpnessBlock(value);
        }
    }
    else if (slider.tag == 14) //色温
    {
        string = [NSString stringWithFormat:@"%zi", (NSInteger)value];
        _hueMinLab.text = string;
        if (_hueBlock) {
            _hueBlock(value);
        }
    }
}

- (UILabel *)maxLab
{
    UILabel *maxLab = [[UILabel alloc] init];
    maxLab.textAlignment = NSTextAlignmentRight;
    maxLab.textColor = [UIColor whiteColor];
    maxLab.font = [UIFont systemFontOfSize:12.0];
    return maxLab;
}

- (UILabel *)minLab
{
    UILabel *minLab = [[UILabel alloc] init];
    minLab.textAlignment = NSTextAlignmentLeft;
    minLab.textColor = [UIColor whiteColor];
    minLab.font = [UIFont systemFontOfSize:12.0];
    return minLab;
}

- (UISlider *)sliderWithMin:(CGFloat)min max:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = min;
    slider.maximumValue = max;
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    return slider;
}

#pragma mark - Getter
- (UILabel *)brightnessTitle
{
    if (!_brightnessTitle) {
        _brightnessTitle = [self minLab];
        _brightnessTitle.text = @"亮  度";
    }
    return _brightnessTitle;
}

- (UILabel *)brightnessMaxLab
{
    if (!_brightnessMaxLab)
    {
        _brightnessMaxLab = [self maxLab];
        _brightnessMaxLab.text = @"1.0";
    }
    return _brightnessMaxLab;
}

- (UILabel *)brightnessMinLab
{
    if (!_brightnessMinLab) {
        _brightnessMinLab = [self minLab];
        _brightnessMinLab.text = @"-1.0";
    }
    return _brightnessMinLab;
}

- (UILabel *)contrastTitle
{
    if (!_contrastTitle) {
        _contrastTitle = [self minLab];
        _contrastTitle.text = @"对比度";
    }
    return _contrastTitle;
}

- (UILabel *)contrastMaxLab
{
    if (!_contrastMaxLab) {
        _contrastMaxLab = [self maxLab];
        _contrastMaxLab.text = @"4.0";
    }
    return _contrastMaxLab;
}

- (UILabel *)contrastMinLab
{
    if (!_contrastMinLab) {
        _contrastMinLab = [self minLab];
        _contrastMinLab.text = @"0.0";
    }
    return _contrastMinLab;
}

- (UILabel *)saturationTitle
{

    if (!_saturationTitle) {
        _saturationTitle = [self minLab];
        _saturationTitle.text = @"饱和度";
    }
    return _saturationTitle;
}

- (UILabel *)saturationMaxLab
{
    if (!_saturationMaxLab) {
        _saturationMaxLab = [self maxLab];
        _saturationMaxLab.text = @"2.0";
    }
    return _saturationMaxLab;
}

- (UILabel *)saturationMinLab
{
    if (!_saturationMinLab) {
        _saturationMinLab = [self minLab];
        _saturationMinLab.text = @"0.0";
    }
    return _saturationMinLab;
}

- (UILabel *)sharpnessTitle
{
    if (!_sharpnessTitle) {
        _sharpnessTitle = [self minLab];
        _sharpnessTitle.text = @"锐  度";
    }
    return _sharpnessTitle;
}

- (UILabel *)sharpnessMaxLab
{
    if (!_sharpnessMaxLab) {
        _sharpnessMaxLab = [self maxLab];
        _sharpnessMaxLab.text = @"4.0";
    }
    return _sharpnessMaxLab;
}

- (UILabel *)sharpnessMinLab
{
    if (!_sharpnessMinLab) {
        _sharpnessMinLab = [self minLab];
        _sharpnessMinLab.text = @"-4.0";
    }
    return _sharpnessMinLab;
}

- (UILabel *)hueTitle
{
    if (!_hueTitle) {
        _hueTitle = [self minLab];
        _hueTitle.text = @"色  温";
    }
    return _hueTitle;
}

- (UILabel *)hueMaxLab
{
    if (!_hueMaxLab) {
        _hueMaxLab = [self maxLab];
        _hueMaxLab.text = @"360";
    }
    return _hueMaxLab;
}

- (UILabel *)hueMinLab
{
    if (!_hueMinLab) {
        _hueMinLab = [self minLab];
        _hueMinLab.text = @"0";
    }
    return _hueMinLab;
}

- (UISlider *)brightnessSlider
{
    if (!_brightnessSlider) {
        _brightnessSlider = [self sliderWithMin:-1 max:1];
        _brightnessSlider.tag = 10;
        _brightnessSlider.value = 0.0;
        self.brightnessMinLab.text = @"0.0";
    }
    return _brightnessSlider;
}

- (UISlider *)contrastSlider
{
    if (!_contrastSlider) {
        _contrastSlider = [self sliderWithMin:0 max:4.0];
        _contrastSlider.tag = 11;
        _contrastSlider.value = 1.0;
        self.contrastMinLab.text = @"1.0";
    }
    return _contrastSlider;
}

- (UISlider *)saturationSlider
{
    if (!_saturationSlider) {
        _saturationSlider = [self sliderWithMin:0 max:2];
        _saturationSlider.tag = 12;
        _saturationSlider.value = 1.0;
        self.saturationMinLab.text = @"1.0";
    }
    return _saturationSlider;
}

- (UISlider *)sharpnessSlider
{
    if (!_sharpnessSlider) {
        _sharpnessSlider = [self sliderWithMin:-4 max:4];
        _sharpnessSlider.tag = 13;
        _sharpnessSlider.value = 0.0;
        self.sharpnessMinLab.text = @"0.0";
    }
    return _sharpnessSlider;
}

- (UISlider *)hueSlider
{
    if (!_hueSlider) {
        _hueSlider = [self sliderWithMin:0 max:360];
        _hueSlider.tag = 14;
        _hueSlider.value = 0.0;
        self.hueMinLab.text = @"0";
    }
    return _hueSlider;
}

- (void)defaultValue
{
    _sharpnessSlider.value = 0.0;
    self.sharpnessMinLab.text = @"0.0";
    if (_sharpnessBlock) {
        _sharpnessBlock(_sharpnessSlider.value);
    }
    
    _hueSlider.value = 0.0;
    self.hueMinLab.text = @"0";
    if (_hueBlock) {
        _hueBlock(_hueSlider.value);
    }
    
    _saturationSlider.value = 1.0;
    self.saturationMinLab.text = @"1.0";
    if (_saturationBlock) {
        _saturationBlock(_saturationSlider.value);
    }
    
    _contrastSlider.value = 1.0;
    self.contrastMinLab.text = @"1.0";
    if (_contrastBlock) {
        _contrastBlock(_contrastSlider.value);
    }
    
    _brightnessSlider.value = 0.0;
    self.brightnessMinLab.text = @"0.0";
    if (_brightnessBlock) {
        _brightnessBlock(_brightnessSlider.value);
    }
}

@end
