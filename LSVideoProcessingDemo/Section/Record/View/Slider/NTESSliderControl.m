//
//  NTESSliderControl.m
//  NTESSliderControl
//
//  Created by Netease on 17/4/18.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESSliderControl.h"

@interface NTESSliderControl ()
{
    CGRect _currentRect;
}
@property (nonatomic, assign) BOOL isVertical;
@property (nonatomic, strong) UIImageView *minTrackImageView;
@property (nonatomic, strong) UIImageView *maxTrackImageView;
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UILabel *thumbLab;

@property (nonatomic, assign) CGFloat interlValue;

@end

@implementation NTESSliderControl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _trackWidth = 2.0;
        _thumbSize = CGSizeMake(16.0, 16.0);
        _minValue = 0.0;
        _maxValue = 1.0;
        self.value = 0.0;
        [self addSubview:self.minTrackImageView];
        [self addSubview:self.maxTrackImageView];
        [self addSubview:self.thumbImageView];
        [self addSubview:self.thumbLab];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(_currentRect, self.bounds))
    {
        [self refreshLayoutWithValue:_interlValue];
        
        _currentRect = self.bounds;
    }
}

- (CGFloat)maxTrackLength:(CGFloat)value
{
    CGFloat length = 0.0;
    
    if (self.isVertical)
    {
        if (value <= 0) {
            length = (self.height - _thumbImageView.height);
        }
        else if (value >= 1) {
            length = 0;
        }
        else {
            length = (self.height - _thumbImageView.height) * (1 - value);
        }
    }
    else
    {
        if (value <= 0) {
            length = (self.width - _thumbImageView.width);
        }
        else if (value >= 1) {
            length = 0;
        }
        else {
            length = (self.width - _thumbImageView.width) * (1 - value);
        }
    }
    
    return length;
}

- (CGFloat)minTrackLength:(CGFloat)value
{
    CGFloat length = 0.0;
    
    if (self.isVertical)
    {
        if (value <= 0) {
            length = 0;
        }
        else if (value >= 1) {
            length = (self.height - _thumbImageView.height);
        }
        else {
            length = (self.height - _thumbImageView.height) * value;
        }
    }
    else
    {
        if (value <= 0) {
            length = 0;
        }
        else if (value >= 1) {
            length = (self.width - _thumbImageView.width);
        }
        else {
            length = (self.width - _thumbImageView.width) * value;
        }
    }

    return length;
}

- (void)refreshLayoutWithValue:(CGFloat)value
{
    CGFloat minTrackLength = [self minTrackLength:value];
    CGFloat maxTrackLength = [self maxTrackLength:value];
    
    if (self.isVertical) //竖直方向
    {
        self.maxTrackImageView.frame = CGRectMake(0, 0, _trackWidth, maxTrackLength);
        self.maxTrackImageView.centerX = self.width/2;
        
        self.minTrackImageView.frame = CGRectMake(0,
                                              self.height - minTrackLength,
                                              _trackWidth,
                                              minTrackLength);
        self.minTrackImageView.centerX = self.width/2;
        self.thumbImageView.size = _thumbSize;
        self.thumbImageView.centerX = self.width/2;
        self.thumbImageView.bottom = self.minTrackImageView.top;
        self.thumbLab.size = self.thumbImageView.size;
        self.thumbLab.center = self.thumbImageView.center;
        

        self.thumbLab.text = [self valueStr:_value style:_valueStyle];
    }
    else //水平方向
    {
        self.minTrackImageView.frame = CGRectMake(0, 0, minTrackLength, _trackWidth);
        self.minTrackImageView.centerY = self.height/2;
        self.thumbImageView.size = _thumbSize;
        self.thumbImageView.centerY = self.height/2;
        self.thumbImageView.left = self.minTrackImageView.right;
        self.maxTrackImageView.frame = CGRectMake(self.width - maxTrackLength,
                                              0,
                                              maxTrackLength,
                                              _trackWidth);
        self.maxTrackImageView.centerY = self.height/2;
        self.thumbLab.size = self.thumbImageView.size;
        self.thumbLab.center = self.thumbImageView.center;
        self.thumbLab.text = [self valueStr:_value style:_valueStyle];
    }
}

- (NSString *)valueStr:(CGFloat)value style:(NTESValueStyle)style
{
    NSString *str = @"";
    
    
    switch (style) {
        case NTESValueStyleInteger:
            str = [NSString stringWithFormat:@"%zi", (NSInteger)value];
            break;
        case NTESValueStyleSignal:
            str = [NSString stringWithFormat:@"%.1f", value];
            break;
        case NTESValueStyleFocus:
            str = [NSString stringWithFormat:@"%.1f", value];
            if ((NSInteger)(value * 100) % 100 == 0) //整数
            {
                str = [NSString stringWithFormat:@"%zix", (NSInteger)round(value)];
            }
            break;
        default:
            break;
    }
    return str;
}

#pragma mark - Setter
- (void)setValue:(CGFloat)value
{
    if (value < _minValue) {
        value = _minValue;
    }
    if (value > _maxValue) {
        value = _maxValue;
    }
    
    _value = value;
    
    if (_maxValue == _minValue)
    {
        _interlValue = 0;
    }
    else
    {
        _interlValue = (value - _minValue)/(_maxValue - _minValue);
    }
    [self refreshLayoutWithValue:_interlValue];
}

- (void)setThumbImage:(UIImage *)thumbImage
{
    _thumbImage = thumbImage;
    
    if (thumbImage) {
        self.thumbImageView.image = thumbImage;
    }
}

- (void)setMinThrackImage:(UIImage *)minThrackImage
{
    _minThrackImage = minThrackImage;
    
    if (minThrackImage) {
        self.minTrackImageView.image = minThrackImage;
    }
}

- (void)setMaxThrackImage:(UIImage *)maxThrackImage
{
    _maxThrackImage = maxThrackImage;
    
    if (maxThrackImage) {
        self.minTrackImageView.image = maxThrackImage;
    }
}

- (void)setMinValue:(CGFloat)minValue
{
    _minValue = minValue;
    
    self.value = _value;
}

- (void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    
    self.value = _value;
}

- (void)setValueStyle:(NTESValueStyle)valueStyle
{
    _valueStyle = valueStyle;
    
    self.thumbLab.text = [self valueStr:_value style:_valueStyle];
}

- (void)setTrackWidth:(CGFloat)trackWidth
{
    _trackWidth = trackWidth;
    
    [self refreshLayoutWithValue:_value];
}

- (void)setThumbSize:(CGSize)thumbSize
{
    _thumbSize = thumbSize;
    
    [self refreshLayoutWithValue:_value];
}

#pragma mark - Getter
- (UIImageView *)minTrackImageView
{
    if (!_minTrackImageView) {
        _minTrackImageView = [[UIImageView alloc] init];
        _minTrackImageView.contentMode = UIViewContentModeScaleToFill;
        _minTrackImageView.backgroundColor = [UIColor whiteColor];
    }
    return _minTrackImageView;
}

- (UIImageView *)maxTrackImageView
{
    if (!_maxTrackImageView) {
        _maxTrackImageView = [[UIImageView alloc] init];
        _maxTrackImageView.contentMode = UIViewContentModeScaleToFill;
        _maxTrackImageView.backgroundColor = [UIColor whiteColor];
    }
    return _maxTrackImageView;
}

- (UIImageView *)thumbImageView
{
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        _thumbImageView.size = _thumbSize;
    }
    return _thumbImageView;
}

- (UILabel *)thumbLab
{
    if (!_thumbLab) {
        _thumbLab = [[UILabel alloc] init];
        _thumbLab.textAlignment = NSTextAlignmentCenter;
        _thumbLab.font = [UIFont systemFontOfSize:10.0];
        _thumbLab.textColor = [UIColor whiteColor];
        _thumbImageView.backgroundColor = [UIColor clearColor];
    }
    return _thumbLab;
}

- (BOOL)isVertical
{
    return (self.bounds.size.height > self.bounds.size.width);
}

- (BOOL)rect:(CGRect)rect containPoint:(CGPoint)point
{
    return (point.x > rect.origin.x - 15
            && point.x < rect.origin.x + rect.size.width + 15
            && point.y > rect.origin.y - 15
            && point.y < rect.origin.y + rect.size.height + 15);
}

#pragma mark ---UIColor Touchu
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CGPoint point = [touch locationInView:self];
    
    if ([self rect:_thumbImageView.frame containPoint:point])
    {
        [self changePointX:touch];
        [self refreshLayoutWithValue:_interlValue];
        
        if (_valueBlock) {
            _valueBlock(_value);
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self changePointX:touch];
    [self refreshLayoutWithValue:_interlValue];
    
    if (_valueBlock) {
        _valueBlock(_value);
    }
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self changePointX:touch];
    [self refreshLayoutWithValue:_interlValue];
    
    if (_valueBlock) {
        _valueBlock(_value);
    }
    
    if (_valueEndChangeBlock) {
        _valueEndChangeBlock(_value);
    }
}

-(void)changePointX:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];

    if (self.isVertical)
    {
        CGFloat pointY = point.y;
        
        if (point.y <= _thumbImageView.height/2)
        {
            pointY = _thumbImageView.height/2;
        }
        else if (point.y > self.height - _thumbImageView.height/2)
        {
            pointY = self.height - _thumbImageView.height/2;
        }
        
        _interlValue = 1 - (pointY - _thumbImageView.height/2) / (self.height - _thumbImageView.height);
        _value = [self valueWithInterValue:_interlValue];
    }
    else
    {
        CGFloat pointX = point.x;
        
        if (point.x <= _thumbImageView.width/2)
        {
            pointX = _thumbImageView.width/2;
        }
        else if (point.x >= self.width - _thumbImageView.width/2)
        {
            pointX = self.width - _thumbImageView.width/2;
        }
        
        _interlValue = (pointX - _thumbImageView.width/2) / (self.width - _thumbImageView.width);
        _value = [self valueWithInterValue:_interlValue];
    }
    
    //NSLog(@"%f", _value);
}

- (CGFloat)valueWithInterValue:(CGFloat)interValue
{
    CGFloat value = interValue * (_maxValue - _minValue) + _minValue;
    return value;
}

@end
