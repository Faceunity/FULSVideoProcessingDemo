//
//  SVDTranscodeView.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDTranscodeView.h"

@interface SVDTranscodeView ()
{
    CGRect _oriRect;
    CGFloat _infoHeight;
}
@property (nonatomic, strong) UILabel *outputTitle;
@property (nonatomic, strong) UITextField *outputFileText;
@property (nonatomic, strong) UIView *Vinterval0;
@property (nonatomic, strong) UIView *Hinterval0;
@property (nonatomic, strong) UIView *Hinterval1;
@property (nonatomic, strong) UILabel *processTitleLab;
@property (nonatomic, strong) UILabel *processValueLab;
@property (nonatomic, strong) UIProgressView *process;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UILabel *invertTitle;
@property (nonatomic, strong) UITextField *invertSpeed;
@property (nonatomic, strong) UILabel *invertWarning;
@property (nonatomic, strong) UIButton *invertBtn;
@property (nonatomic, strong) UIButton *invertStopBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *outputInfoLab;
@property (nonatomic, strong) UIButton *maskBtn;
@property (nonatomic, copy) NSString *dstFileName;
@end

@implementation SVDTranscodeView
@synthesize dstFileName = _dstFileName;
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self doSetupSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(_oriRect, self.bounds)) {
        [self doLayoutsubviews];
        _oriRect = self.bounds;
    }
}

- (void)upedatePlayState
{
    _playBtn.enabled = [NTESSandboxHelper fileIsExist:_dstFilePath];
}

#pragma mark - Setter && Getter
- (NSString *)dstFileName
{
    return _outputFileText.text;
}

- (void)setDstFileName:(NSString *)dstFileName
{
    if (dstFileName)
    {
        if ((dstFileName.length != 0) && ![dstFileName hasSuffix:@"mp4"])
        {
            _outputFileText.text = [dstFileName stringByAppendingString:@".mp4"];
        }
        else
        {
            _outputFileText.text = dstFileName;
        }
    }
    else
    {
        _outputFileText.text = @"";
    }
}

- (void)setDstFilePath:(NSString *)dstFilePath
{
    _dstFilePath = (dstFilePath ? dstFilePath : @"");
    _outputInfoLab.text = dstFilePath;
    _infoHeight = [dstFilePath heightWithWidth:_outputInfoLab.width] + 8.0;
    _playBtn.enabled = [NTESSandboxHelper fileIsExist:dstFilePath];
    [self doLayoutsubviews];
}

- (void)setIsTranscoding:(BOOL)isTranscoding
{
    _isTranscoding = isTranscoding;
    _stopBtn.enabled = isTranscoding;
    _startBtn.enabled = !_stopBtn.isEnabled;
}

- (void)setIsInverting:(BOOL)isInverting
{
    _isInverting = isInverting;
    _invertStopBtn.enabled = isInverting;
    _invertBtn.enabled = !_invertStopBtn.enabled;
}

- (void)setProcessValue:(CGFloat)processValue
{
    _processValue = processValue;
    _processValueLab.text = [NSString stringWithFormat:@"%%%.2f", processValue*100];
    _process.progress = processValue;
}

#pragma mark - Action
- (void)btnAction:(UIButton *)btn
{
    if (btn == _startBtn)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(TranscodeViewStartAction:)]) {
            [_delegate TranscodeViewStartAction:self];
        }
    }
    else if (btn == _stopBtn)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(TranscodeViewStopAction:)]) {
            [_delegate TranscodeViewStopAction:self];
        }
    }
    else if (btn == _invertBtn)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(TranscodeViewInvertStartAction:)]) {
            [_delegate TranscodeViewInvertStartAction:self];
        }
    }
    else if (btn == _invertStopBtn)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(TranscodeViewInvertStopAction:)]) {
            [_delegate TranscodeViewInvertStopAction:self];
        }
    }
    else if (btn == _playBtn)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(TranscodeViewPlayAction:)]) {
            [_delegate TranscodeViewPlayAction:self];
        }
    }
    else if (btn == _maskBtn)
    {
        [self endEditing:YES];
        btn.hidden = YES;
    }
}

- (void)keyBoardShowAction:(NSNotification *)note {
    _maskBtn.hidden = NO;
}

- (void)textEditDone:(UITextView *)sender
{
    if (![sender.text hasSuffix:@"mp4"]) {
        NSString *text = [sender.text stringByAppendingString:@".mp4"];
        sender.text = text;
    }
    
    if (sender.text.length != 0)
    {
        self.dstFilePath = [[NTESSandboxHelper videoOutputPath] stringByAppendingPathComponent:sender.text];
    }
    else
    {
        self.dstFilePath = @"";
    }
}

- (void)invertTextEditDone:(UITextField *)sender {
    _invertSpeedValue = [sender.text floatValue];
}

#pragma mark - Setup subviews
- (void)doLayoutsubviews
{
    _maskBtn.frame = self.bounds;
    _outputTitle.frame = CGRectMake(8.0, 0.0, _outputTitle.width, 44.0);
    _Hinterval0.frame = CGRectMake(0.0, _outputTitle.bottom, self.width, 1.0);
    _playBtn.frame = CGRectMake(self.width - 60.0, _Hinterval0.bottom, 60, _outputTitle.height);
    _outputFileText.frame = CGRectMake(_outputTitle.left,
                                       _playBtn.top,
                                       self.width - _playBtn.width - _outputTitle.left - 8.0,
                                       _outputTitle.height);
    _Vinterval0.frame = CGRectMake(_playBtn.left - 1.0, _playBtn.top, 1.0, _playBtn.height);
    _Hinterval1.frame = CGRectMake(0, _playBtn.bottom, self.width, 1.0);

    _outputInfoLab.frame = CGRectMake(_outputFileText.left, _Hinterval1.bottom + 16.0, self.width - _outputFileText.left*2, _infoHeight);
    
    _processTitleLab.frame = CGRectMake(_outputInfoLab.left, _outputInfoLab.bottom + 16.0, _processTitleLab.width, _processTitleLab.height);
    _processValueLab.frame = CGRectMake(_processTitleLab.right + 8.0, _processTitleLab.top, self.width - _processTitleLab.right - 16.0, _processValueLab.height);
    _process.frame = CGRectMake(_processTitleLab.left, _processTitleLab.bottom + 16.0, self.width - 2*_processTitleLab.left, 2.0);

    _startBtn.frame = CGRectMake((self.width - 100 * 2)/3, _process.bottom + 32.0, 100, 44.0);
    _stopBtn.frame = CGRectMake(_startBtn.right + (self.width - 100 * 2)/3, _startBtn.top, _startBtn.width, _startBtn.height);
    
    _invertTitle.origin = CGPointMake(_processTitleLab.left, _startBtn.bottom + 8.0);
    
    _invertSpeed.frame = CGRectMake(_invertTitle.right + 8.0, _startBtn.bottom, 60, 28);
    _invertWarning.left = _invertSpeed.right + 12.0;
    _invertWarning.centerY = _invertSpeed.centerY;
    _invertTitle.centerY = _invertSpeed.centerY;
    
    _invertBtn.frame = CGRectMake(_startBtn.left, _invertSpeed.bottom + 8.0, _startBtn.width, _startBtn.height);
    _invertStopBtn.frame= CGRectMake(_stopBtn.left, _invertSpeed.bottom + 8.0, _stopBtn.width, _stopBtn.height);
}

- (void)doSetupSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    _outputTitle = [self setupTitleLab:@"目标文件"];
    [self addSubview:_outputTitle];
    [self addSubview:self.outputFileText];
    [self addSubview:self.outputInfoLab];
    
    _processTitleLab = [self setupTitleLab:@"转码进度"];
    [self addSubview:_processTitleLab];
    _processValueLab = [self setupTitleLab:@"00.00%"];
    [self addSubview:_processValueLab];
    [self addSubview:self.process];

    _startBtn = [self setupBtn:@"转码"];
    [self addSubview:_startBtn];
    _stopBtn = [self setupBtn:@"中断"];
    _stopBtn.enabled = NO;
    [self addSubview:_stopBtn];
    
    
    _invertTitle = [self setupTitleLab:@"逆序速度"];
    [self addSubview:self.invertTitle];
    _invertWarning = [self setupTitleLab:@"[值越大速度越快占用内存越大]"];
    _invertWarning.font = [UIFont systemFontOfSize:11.0];
    _invertWarning.textColor = [UIColor redColor];
    [self addSubview:_invertWarning];
    [self addSubview:self.invertSpeed];
    
    _invertBtn = [self setupBtn:@"逆序"];
    [self addSubview:_invertBtn];
    _invertStopBtn = [self setupBtn:@"逆序中断"];
    [self addSubview:_invertStopBtn];
    _invertStopBtn.enabled = NO;
    
    _playBtn = [self setupBtn:@"播放"];
    _playBtn.enabled = NO;
    [self addSubview:_playBtn];
    
    _Vinterval0 = [self setupInterval];
    [self addSubview:_Vinterval0];
    _Hinterval0 = [self setupInterval];
    [self addSubview:_Hinterval0];
    _Hinterval1 = [self setupInterval];
    [self addSubview:_Hinterval1];
    [self addSubview:self.maskBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardShowAction:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (UIView *)setupInterval {
    UIView *interval = [[UIView alloc] init];
    interval.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return interval;
}

- (UILabel *)setupTitleLab:(NSString *)text {
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont boldSystemFontOfSize:15.0];
    title.text = text;
    [title sizeToFit];
    return title;
}

- (UIButton *)setupBtn:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UITextField *)outputFileText
{
    if (!_outputFileText) {
        _outputFileText = [[UITextField alloc] init];
        _outputFileText.placeholder = @"请输入目标文件名称";
        _outputFileText.font = [UIFont systemFontOfSize:14.0];
        [_outputFileText addTarget:self action:@selector(textEditDone:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return _outputFileText;
}

- (UITextField *)invertSpeed
{
    if (!_invertSpeed) {
        _invertSpeed = [[UITextField alloc] init];
        _invertSpeed.text = @"3.0";
        _invertSpeed.keyboardType = UIKeyboardTypeDecimalPad;
        _invertSpeed.font = [UIFont systemFontOfSize:14.0];
        _invertSpeed.borderStyle = UITextBorderStyleRoundedRect;
        [_invertSpeed addTarget:self action:@selector(invertTextEditDone:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return _invertSpeed;
}

- (UIProgressView *)process
{
    if (!_process) {
        _process = [[UIProgressView alloc] init];
        _process.progress = 0.0;
    }
    return _process;
}

- (UILabel *)outputInfoLab
{
    if (!_outputInfoLab) {
        _outputInfoLab = [[UILabel alloc] init];
        _outputInfoLab.textColor = [UIColor lightGrayColor];
        _outputInfoLab.font = [UIFont systemFontOfSize:13.0];
        _outputInfoLab.numberOfLines = 0;
        _outputInfoLab.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _outputInfoLab;
}

- (UIButton *)maskBtn
{
    if (!_maskBtn) {
        _maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_maskBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _maskBtn.hidden = YES;
    }
    return _maskBtn;
}

@end
