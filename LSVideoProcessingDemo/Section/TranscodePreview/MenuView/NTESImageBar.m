//
//  NTESImageBar.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 17/6/21.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESImageBar.h"

@interface NTESImageBar ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *addImage;

@property (nonatomic, strong) UIButton *removeImage;

@end

@implementation NTESImageBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        [self addSubview:self.addImage];
        [self addSubview:self.removeImage];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _addImage.frame = CGRectMake(16, 40, 40, 40);
    _removeImage.frame = CGRectMake(self.width - 16 - 40, _addImage.top, 40, 40);
}

#pragma mark - Action
- (void)tapAction:(UIGestureRecognizer *)tap
{
    self.hidden = YES;
    
    if (self.imageView.superview)
    {
        if (_imageBlock) {
            _imageBlock(self.imageView.frame);
        }
    }
    else
    {
        if (_imageBlock) {
            _imageBlock(CGRectZero);
        }
    }
}

- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 10) {
        [self.imageView removeFromSuperview];
        self.imageView.center = CGPointMake(self.width/2, self.height/2);
        [self addSubview:self.imageView];
    }
    else if (btn.tag == 11) {
        [self.imageView removeFromSuperview];
    }
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self];
    pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}

#pragma mark - Getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.size = CGSizeMake(50, 50);
        _imageView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_imageView addGestureRecognizer:pan];
    }
    return _imageView;
}

- (UIButton *)addImage
{
    if (!_addImage) {
        _addImage = [UIButton buttonWithType:UIButtonTypeSystem];
        [_addImage addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _addImage.tag = 10;
        [_addImage setTitle:@"添加" forState:UIControlStateNormal];
    }
    return _addImage;
}

- (UIButton *)removeImage
{
    if (!_removeImage)
    {
        _removeImage = [UIButton buttonWithType:UIButtonTypeSystem];
        [_removeImage addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_removeImage setTitle:@"移除" forState:UIControlStateNormal];
        _removeImage.tag = 11;
        
    }
    return _removeImage;
}

@end
