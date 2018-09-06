//
//  NTESFilterBar.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 17/6/22.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESFilterBar.h"
#import "NTESFilterConfigView.h"

@interface NTESFilterBar ()

@property (nonatomic, strong) NTESFilterConfigView *filterConfig;

@property (nonatomic, strong) UILabel *whiteningTitle;
@property (nonatomic, strong) UILabel *whiteningMinLab;
@property (nonatomic, strong) UILabel *whiteningMaxLab;
@property (nonatomic, strong) UISlider *whiteningSlider;

@property (nonatomic, strong) UILabel *smoothTitle;
@property (nonatomic, strong) UILabel *smoothMinLab;
@property (nonatomic, strong) UILabel *smoothMaxLab;
@property (nonatomic, strong) UISlider *smoothSlider;

@property (nonatomic, strong) UILabel *beautyTitle;
@property (nonatomic, strong) UISwitch *beautySwitch;
@end

@implementation NTESFilterBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.filterConfig];
        
        [self addSubview:self.whiteningTitle];
        [self addSubview:self.whiteningMinLab];
        [self addSubview:self.whiteningSlider];
        [self addSubview:self.whiteningMaxLab];
        
        [self addSubview:self.smoothTitle];
        [self addSubview:self.smoothMinLab];
        [self addSubview:self.smoothSlider];
        [self addSubview:self.smoothMaxLab];
        
        [self addSubview:self.beautyTitle];
        [self addSubview:self.beautySwitch];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _filterConfig.frame = CGRectMake(0, 0, self.width, 60.0);
    
    _whiteningTitle.frame = CGRectMake(16, _filterConfig.bottom + 16.0, _whiteningTitle.width, 20);
    _whiteningMinLab.frame = CGRectMake(_whiteningTitle.right + 8.0, _whiteningTitle.top, 25, 20);
    _whiteningMaxLab.frame = CGRectMake(self.width - 16.0 - 20.0, _whiteningTitle.top, 25, 20);
    _whiteningSlider.frame = CGRectMake(_whiteningMinLab.right + 8.0,
                                        _whiteningTitle.top,
                                        _whiteningMaxLab.left - 8.0 - _whiteningMinLab.right - 8.0,
                                        20);
    
    _smoothTitle.top = _whiteningTitle.bottom + 16.0;
    _smoothTitle.left = _whiteningTitle.left;
    _smoothTitle.size = _whiteningTitle.size;
    _smoothMinLab.top = _smoothTitle.top;
    _smoothMinLab.left = _whiteningMinLab.left;
    _smoothMinLab.size = _whiteningMinLab.size;
    _smoothSlider.top = _smoothTitle.top;
    _smoothSlider.left = _whiteningSlider.left;
    _smoothSlider.size = _whiteningSlider.size;
    _smoothMaxLab.top = _smoothTitle.top;
    _smoothMaxLab.left = _whiteningMaxLab.left;
    _smoothMaxLab.size = _whiteningMaxLab.size;
    
    _beautyTitle.size = _whiteningTitle.size;
    _beautyTitle.left = _whiteningTitle.left;
    _beautyTitle.top = _filterConfig.bottom + 32.0;
    _beautySwitch.centerY = _beautyTitle.centerY;
    _beautySwitch.left = _beautyTitle.right + 8.0;
}

#pragma mark - Action
- (void)sliderAction:(UISlider *)slider
{
    if (slider.tag == 10) {
        _whiteningMinLab.text = [NSString stringWithFormat:@"%.1f", slider.value];
        if (_whiteningBlock) {
            _whiteningBlock(slider.value);
        }
    }
    else if (slider.tag == 11) {
        _smoothMinLab.text = [NSString stringWithFormat:@"%zi", (NSInteger)slider.value];
        if (_smoothBlock) {
            _smoothBlock(slider.value);
        }
    }
}

- (void)switchAction:(UISwitch *)sender
{
    if (_beautyBlock) {
        _beautyBlock(sender.isOn);
    }
}

#pragma mark - Getter/Setter
- (UILabel *)maxLab
{
    UILabel *maxLab = [[UILabel alloc] init];
    maxLab.textAlignment = NSTextAlignmentRight;
    maxLab.textColor = [UIColor whiteColor];
    maxLab.font = [UIFont systemFontOfSize:12.0];
    maxLab.hidden = YES;
    return maxLab;
}

- (UILabel *)minLab
{
    UILabel *minLab = [[UILabel alloc] init];
    minLab.textAlignment = NSTextAlignmentLeft;
    minLab.textColor = [UIColor whiteColor];
    minLab.font = [UIFont systemFontOfSize:12.0];
    minLab.hidden = YES;
    return minLab;
}

- (UISlider *)sliderWithMin:(CGFloat)min max:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = min;
    slider.maximumValue = max;
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    slider.hidden = YES;
    return slider;
}

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    
    _filterConfig.datas = datas;
}

- (NTESFilterConfigView *)filterConfig
{
    if (!_filterConfig) {
        _filterConfig = [[NTESFilterConfigView alloc] init];
        _filterConfig.alpha = 1.0;
  
        __weak typeof(self) weakSelf = self;
        _filterConfig.selectBlock = ^(NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            strongSelf.selectedIndex = index;
            
            if (strongSelf.selectBlock) {
                strongSelf.selectBlock(index);
            }
            
            if (index < 2)
            {
                strongSelf.whiteningTitle.hidden = YES;
                strongSelf.whiteningMinLab.hidden = YES;
                strongSelf.whiteningSlider.hidden = YES;
                strongSelf.whiteningMaxLab.hidden = YES;
                strongSelf.smoothTitle.hidden = YES;
                strongSelf.smoothMinLab.hidden = YES;
                strongSelf.smoothSlider.hidden = YES;
                strongSelf.smoothMaxLab.hidden = YES;
                strongSelf.beautyTitle.hidden = YES;
                strongSelf.beautySwitch.hidden = YES;
            }
            else if (index < 5)
            {
                strongSelf.whiteningTitle.hidden = NO;
                strongSelf.whiteningMinLab.hidden = NO;
                strongSelf.whiteningSlider.hidden = NO;
                strongSelf.whiteningMaxLab.hidden = NO;
                strongSelf.smoothTitle.hidden = NO;
                strongSelf.smoothMinLab.hidden = NO;
                strongSelf.smoothSlider.hidden = NO;
                strongSelf.smoothMaxLab.hidden = NO;
                strongSelf.beautyTitle.hidden = YES;
                strongSelf.beautySwitch.hidden = YES;
            }
            else
            {
                strongSelf.whiteningTitle.hidden = YES;
                strongSelf.whiteningMinLab.hidden = YES;
                strongSelf.whiteningSlider.hidden = YES;
                strongSelf.whiteningMaxLab.hidden = YES;
                strongSelf.smoothTitle.hidden = YES;
                strongSelf.smoothMinLab.hidden = YES;
                strongSelf.smoothSlider.hidden = YES;
                strongSelf.smoothMaxLab.hidden = YES;
                strongSelf.beautyTitle.hidden = NO;
                strongSelf.beautySwitch.hidden = NO;
            }
        };
    }
    return _filterConfig;
}

- (UILabel *)whiteningTitle
{
    if (!_whiteningTitle) {
        _whiteningTitle = [self minLab];
        _whiteningTitle.text = @"美白强度:";
        [_whiteningTitle sizeToFit];
    }
    return _whiteningTitle;
}

- (UILabel *)whiteningMinLab {

    if (!_whiteningMinLab) {
        _whiteningMinLab = [self minLab];
    }
    return _whiteningMinLab;
};

- (UILabel *)whiteningMaxLab
{
    if (!_whiteningMaxLab) {
        _whiteningMaxLab = [self maxLab];
    }
    return _whiteningMaxLab;
}

- (UISlider *)whiteningSlider
{
    if (!_whiteningSlider) {
        _whiteningSlider = [self sliderWithMin:0 max:1];
        self.whiteningMinLab.text = @"0";
        self.whiteningMaxLab.text = @"1";
        _whiteningSlider.tag = 10;
    }
    return _whiteningSlider;
}

- (UILabel *)smoothTitle
{
    if (!_smoothTitle) {
        _smoothTitle = [self minLab];
        _smoothTitle.text = @"磨皮强度:";
    }
    return _smoothTitle;
}

- (UILabel *)smoothMinLab
{
    if (!_smoothMinLab) {
        _smoothMinLab = [self minLab];
    }
    return _smoothMinLab;
}

- (UILabel *)smoothMaxLab
{
    if (!_smoothMaxLab) {
        _smoothMaxLab = [self maxLab];
    }
    return _smoothMaxLab;
}

- (UISlider *)smoothSlider
{
    if (!_smoothSlider) {
        _smoothSlider = [self sliderWithMin:0 max:40];
        self.smoothMinLab.text = @"0";
        self.smoothMaxLab.text = @"40";
        _smoothSlider.tag = 11;
    }
    return _smoothSlider;
}

- (UILabel *)beautyTitle
{
    if (!_beautyTitle) {
        _beautyTitle = [self minLab];
        _beautyTitle.text = @"美颜选项:";
    }
    return _beautyTitle;
}

- (UISwitch *)beautySwitch
{
    if (!_beautySwitch) {
        _beautySwitch = [[UISwitch alloc] init];
        _beautySwitch.on = NO;
        [_beautySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        _beautySwitch.hidden = YES;
    }
    return _beautySwitch;
}




@end
