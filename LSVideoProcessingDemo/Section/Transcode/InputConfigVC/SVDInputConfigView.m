//
//  SVDInputConfigView.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDInputConfigView.h"


@interface SVDInputConfigView()
{
    BOOL _isAudioCell;
}
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *bundleBtn;
@property (nonatomic, strong) UIButton *localBtn;
@property (nonatomic, strong) UIButton *albumBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UILabel *infoLab;

@property (nonatomic, strong) UIView *HintervalLine0;
@property (nonatomic, strong) UIView *HintervalLine1;
@property (nonatomic, strong) UIView *HintervalLine2;
@property (nonatomic, strong) UIView *HintervalLine3;
@property (nonatomic, strong) UIView *VintervalLine0;
@property (nonatomic, strong) UIView *VintervalLine1;
@property (nonatomic, strong) UIView *VintervalLine2;

@property (nonatomic, strong) UILabel *speedTitle;
@property (nonatomic, strong) UITextField *speedInput;
@property (nonatomic, strong) UILabel *speedBeginTitle;
@property (nonatomic, strong) UITextField *speedBeginInput;
@property (nonatomic, strong) UILabel *speedDurationTitle;
@property (nonatomic, strong) UITextField *speedDurationInput;

@end

@implementation SVDInputConfigView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _isAudioCell = [reuseIdentifier isEqualToString:@"secCell"];
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupSubviews];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview)
    {
        [self doLayoutSubviews];
    }
}

- (void)setupSubviews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    _HintervalLine0 = [self setupIntervalView];
    _HintervalLine1 = [self setupIntervalView];
    _HintervalLine2 = [self setupIntervalView];
    _HintervalLine3 = [self setupIntervalView];
    _VintervalLine0 = [self setupIntervalView];
    _VintervalLine1 = [self setupIntervalView];
    _VintervalLine2 = [self setupIntervalView];
    [self addSubview:self.titleLab];
    [self addSubview:self.playBtn];
    if (!_isAudioCell)
    {
        [self addSubview:self.addBtn];
        [self addSubview:self.delBtn];
        
        [self addSubview:_VintervalLine2];
        [self addSubview:_HintervalLine2];
        [self addSubview:_HintervalLine3];
        [self addSubview:self.speedInput];
        [self addSubview:self.speedTitle];
        [self addSubview:self.speedBeginTitle];
        [self addSubview:self.speedBeginInput];
        [self addSubview:self.speedDurationTitle];
        [self addSubview:self.speedDurationInput];
    }
    [self addSubview:self.bundleBtn];
    [self addSubview:self.localBtn];
    [self addSubview:self.albumBtn];
    [self addSubview:self.infoLab];
    [self addSubview:_HintervalLine0];
    [self addSubview:_HintervalLine1];
    [self addSubview:_VintervalLine0];
    [self addSubview:_VintervalLine1];
}

- (UIView *)setupIntervalView
{
    UIView *intervalView = [[UIView alloc] init];
    intervalView.backgroundColor = [UIColor lightGrayColor];
    return intervalView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self doLayoutSubviews];
}

- (void)doLayoutSubviews
{
    _playBtn.frame = CGRectMake(self.width/3, 0, self.width/3, 44);
    _addBtn.frame = CGRectMake(_playBtn.right, 0, _playBtn.width/2, _playBtn.height);
    _delBtn.frame = CGRectMake(_addBtn.right, 0, _addBtn.width, _addBtn.height);
    _titleLab.frame = CGRectMake(8.0, 0, self.width - _playBtn.width - 8.0 * 2, _playBtn.height);
    _VintervalLine0.frame = CGRectMake(0, _titleLab.bottom, self.width, 1.0);
    
    _bundleBtn.frame = CGRectMake(0, _VintervalLine0.bottom, self.width/3, _playBtn.height);
    _localBtn.frame = CGRectMake(_bundleBtn.right, _bundleBtn.top, _bundleBtn.width, _bundleBtn.height);
    _albumBtn.frame = CGRectMake(_localBtn.right, _localBtn.top, _localBtn.width, _localBtn.height);
    _HintervalLine0.frame = CGRectMake(_bundleBtn.right - 1, _bundleBtn.top, 1.0, _bundleBtn.height);
    _HintervalLine1.frame = CGRectMake(_localBtn.right - 1, _localBtn.top, 1.0, _localBtn.height);
    _VintervalLine1.frame = CGRectMake(0, _bundleBtn.bottom, self.width, 1.0);
    
    if (!_isAudioCell)
    {
        _HintervalLine2.frame = CGRectMake(_HintervalLine0.left, _VintervalLine1.bottom, 1.0, _HintervalLine0.height);
        _HintervalLine3.frame = CGRectMake(_HintervalLine1.left, _VintervalLine1.bottom, 1.0, _HintervalLine1.height);
        _VintervalLine2.frame = CGRectMake(0, _VintervalLine1.bottom + 44.0, self.width, 1.0);
        
        _speedTitle.frame = CGRectMake(8.0, _VintervalLine1.bottom + 8.0, _speedTitle.width, (_VintervalLine2.top - _VintervalLine1.bottom) - 16.0);
        _speedInput.frame = CGRectMake(_speedTitle.right + 8.0, _speedTitle.top, (_HintervalLine2.left - _speedTitle.right - 16.0), _speedTitle.height);
        _speedBeginTitle.frame = CGRectMake(_HintervalLine2.right + 8.0, _speedTitle.top, _speedTitle.width, _speedTitle.height);
        _speedBeginInput.frame = CGRectMake(_speedBeginTitle.right + 8.0, _speedInput.top, _speedInput.width, _speedInput.height);
        _speedDurationTitle.frame = CGRectMake(_HintervalLine3.right + 8.0, _speedBeginTitle.top, _speedBeginTitle.width, _speedBeginTitle.height);
        _speedDurationInput.frame = CGRectMake(_speedDurationTitle.right + 8.0, _speedBeginInput.top, _speedBeginInput.width, _speedBeginInput.height);
    }

    if (!_isAudioCell)
    {
        _infoLab.frame = CGRectMake(8.0, _VintervalLine1.bottom + 8, self.width - 8.0*2, _infoLab.height + 8.0);
    }
    else
    {
        _infoLab.frame = CGRectMake(8.0, _VintervalLine2.bottom + 8, self.width - 8.0*2, _infoLab.height + 8.0);
    }
    
    self.infoText = _infoText;
}

#pragma mark - Action
- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == 10)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(InputConfigLocalAction:)]) {
            [_delegate InputConfigLocalAction:self];
        }
    }
    else if (btn.tag == 11)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(InputConfigBundleAction:)]) {
            [_delegate InputConfigBundleAction:self];
        }
    }
    else if (btn.tag == 12)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(InputConfigAlbumAction:)]) {
            [_delegate InputConfigAlbumAction:self];
        }
    }
    else if (btn.tag == 13)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(InputConfigPlayAction:)]) {
            [_delegate InputConfigPlayAction:self];
        }
    }
    else if (btn.tag == 14)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(InputConfigAddAction:)]) {
            [_delegate InputConfigAddAction:self];
        }
    }
    else if (btn.tag == 15)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(InputConfigDelAction:)]) {
            [_delegate InputConfigDelAction:self];
        }
    }
}

- (void)inputAction:(UITextView *)sender
{
    CGFloat value = 0.0;
    if (sender.tag == 20)
    {
        value = ((sender.text.length != 0) ? [sender.text floatValue] : 1.0);
        if (_delegate && [_delegate respondsToSelector:@selector(InputConfigSetSpeed:speed:)]) {
            [_delegate InputConfigSetSpeed:self speed:value];
        }
    }
    else if (sender.tag == 21)
    {
        value = ((sender.text.length != 0) ? [sender.text floatValue] : 0.0);
        if (_delegate && [_delegate respondsToSelector:@selector(InputConfigSetSpeedBegin:begin:)]) {
            [_delegate InputConfigSetSpeedBegin:self begin:value];
        }
    }
    else if (sender.tag == 22)
    {
        value = ((sender.text.length != 0) ? [sender.text floatValue] : 0.0);
        if (_delegate && [_delegate respondsToSelector:@selector(InputConfigSetSpeedDuration:duration:)]) {
            [_delegate InputConfigSetSpeedDuration:self duration:value];
        }
    }
}

#pragma mark - Setter
- (void)setInfoText:(NSString *)infoText
{
    _infoText = (infoText ? infoText : @"");
    self.infoLab.text = infoText;
    CGFloat height = (_infoText.length == 0) ? 0 : [infoText heightWithWidth:(self.width - 8.0 * 2)];
    CGFloat top = (_isAudioCell ? (_VintervalLine1.bottom + 8) : (_VintervalLine2.bottom + 8));
    _infoLab.frame = CGRectMake(8.0, top, self.width - 8.0*2, height);
}

- (void)setDisableDel:(BOOL)disableDel
{
    _delBtn.enabled = !disableDel;
}

- (void)setCanPlay:(BOOL)canPlay
{
    _canPlay = canPlay;
    _playBtn.enabled = canPlay;
}

- (void)setModel:(SVDInputFileModel *)model
{
    _model = model;
    self.canPlay = model.isCanPlay;
    self.infoText = model.fileInfo;
    _speedInput.text = ((model.speed == 1.0) ? @"" : [NSString stringWithFormat:@"%.1f", model.speed]);
    _speedBeginInput.text = ((model.speedBegin == 0.0) ? @"" : [NSString stringWithFormat:@"%.1f", model.speedBegin]);
    _speedDurationInput.text = ((model.speedDuration == 0.0) ? @"" : [NSString stringWithFormat:@"%.1f", model.speedDuration]);
}

#pragma mark - Getter
- (CGFloat)cellHeight
{
    return _infoLab.bottom;
}

- (UIButton *)localBtn
{
    if (!_localBtn)
    {
        _localBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _localBtn.tag = 10;
        [_localBtn setTitle:@"沙盒" forState:UIControlStateNormal];
        [_localBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _localBtn;
}

- (UIButton *)bundleBtn
{
    if (!_bundleBtn)
    {
        _bundleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _bundleBtn.tag = 11;
        [_bundleBtn setTitle:@"Bundle" forState:UIControlStateNormal];
        [_bundleBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bundleBtn;
}

- (UIButton *)albumBtn
{
    if (!_albumBtn)
    {
        _albumBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _albumBtn.tag = 12;
        [_albumBtn setTitle:@"相册" forState:UIControlStateNormal];
        [_albumBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumBtn;
}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _playBtn.tag = 13;
        _playBtn.enabled = NO;
        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _addBtn.tag = 14;
        [_addBtn setTitle:@"+" forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)delBtn
{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _delBtn.tag = 15;
        [_delBtn setTitle:@"-" forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}

- (UILabel *)infoLab
{
    if (!_infoLab)
    {
        _infoLab = [[UILabel alloc] init];
        _infoLab.textAlignment = NSTextAlignmentLeft;
        _infoLab.font = [UIFont systemFontOfSize:11.0];
        _infoLab.textColor = [UIColor blackColor];
        _infoLab.numberOfLines = 0;
    }
    return _infoLab;
}

- (UILabel *)titleLab
{
    if (!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = [UIFont boldSystemFontOfSize:15.0];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.text = (_isAudioCell ? @"输入伴音文件" : @"输入主文件");
    }
    return _titleLab;
}

- (UILabel *)speedTitle
{
    if (!_speedTitle)
    {
        _speedTitle = [[UILabel alloc] init];
        _speedTitle.textAlignment = NSTextAlignmentLeft;
        _speedTitle.font = [UIFont boldSystemFontOfSize:11.0];
        _speedTitle.textColor = [UIColor blackColor];
        _speedTitle.text = @"加速\n速率";
        _speedTitle.numberOfLines = 2;
        [_speedTitle sizeToFit];
    }
    return _speedTitle;
}

- (UITextField *)speedInput
{
    if (!_speedInput) {
        _speedInput = [[UITextField alloc] init];
        _speedInput.font = [UIFont boldSystemFontOfSize:11.0];
        _speedInput.borderStyle = UITextBorderStyleRoundedRect;
        _speedInput.keyboardType = UIKeyboardTypeDecimalPad;
        _speedInput.placeholder = @"1.0";
        _speedInput.tag = 20;
        [_speedInput addTarget:self action:@selector(inputAction:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return _speedInput;
}

- (UILabel *)speedBeginTitle
{
    if (!_speedBeginTitle)
    {
        _speedBeginTitle = [[UILabel alloc] init];
        _speedBeginTitle.textAlignment = NSTextAlignmentLeft;
        _speedBeginTitle.font = [UIFont boldSystemFontOfSize:11.0];
        _speedBeginTitle.textColor = [UIColor blackColor];
        _speedBeginTitle.text = @"加速\n开始";
        _speedBeginTitle.numberOfLines = 2;
        [_speedBeginTitle sizeToFit];
    }
    return _speedBeginTitle;
}

- (UITextField *)speedBeginInput
{
    if (!_speedBeginInput) {
        _speedBeginInput = [[UITextField alloc] init];
        _speedBeginInput.font = [UIFont boldSystemFontOfSize:11.0];
        _speedBeginInput.borderStyle = UITextBorderStyleRoundedRect;
        _speedBeginInput.keyboardType = UIKeyboardTypeDecimalPad;
        _speedBeginInput.placeholder = @"0.0";
        _speedBeginInput.tag = 21;
        [_speedBeginInput addTarget:self action:@selector(inputAction:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return _speedBeginInput;
}

- (UILabel *)speedDurationTitle
{
    if (!_speedDurationTitle)
    {
        _speedDurationTitle = [[UILabel alloc] init];
        _speedDurationTitle.textAlignment = NSTextAlignmentLeft;
        _speedDurationTitle.font = [UIFont boldSystemFontOfSize:11.0];
        _speedDurationTitle.textColor = [UIColor blackColor];
        _speedDurationTitle.text = @"加速\n持续";
        _speedDurationTitle.numberOfLines = 2;
        [_speedDurationTitle sizeToFit];
    }
    return _speedDurationTitle;
}

- (UITextField *)speedDurationInput
{
    if (!_speedDurationInput) {
        _speedDurationInput = [[UITextField alloc] init];
        _speedDurationInput.font = [UIFont boldSystemFontOfSize:11.0];
        _speedDurationInput.borderStyle = UITextBorderStyleRoundedRect;
        _speedDurationInput.keyboardType = UIKeyboardTypeDecimalPad;
        _speedDurationInput.placeholder = @"0.0";
        _speedDurationInput.tag = 22;
        [_speedDurationInput addTarget:self action:@selector(inputAction:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return _speedDurationInput;
}

@end
