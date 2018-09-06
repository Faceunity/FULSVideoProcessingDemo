//
//  SVDOutputConfigView.m
//  LSMediaTranscodingDemo
//
//  Created by Netease on 16/12/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "SVDOutputConfigView.h"
#import "SVDOutputFileConfigVC.h"

@interface SVDOutputConfigView ()
@property (weak, nonatomic) IBOutlet UITextField *videoWidth;
@property (weak, nonatomic) IBOutlet UITextField *videoHeight;
@property (weak, nonatomic) IBOutlet UITextField *videoQuality;
@property (weak, nonatomic) IBOutlet UITextField *videoScaleModel;

@property (weak, nonatomic) IBOutlet UISwitch *isMixMainAudio;
@property (weak, nonatomic) IBOutlet UISwitch *isMute;
@property (weak, nonatomic) IBOutlet UITextField *mainValueIntensity;
@property (weak, nonatomic) IBOutlet UITextField *audioValueIntensity;

@property (weak, nonatomic) IBOutlet UITextField *beginTimeS;
@property (weak, nonatomic) IBOutlet UITextField *durationS;


@property (weak, nonatomic) IBOutlet UITextField *cropX;
@property (weak, nonatomic) IBOutlet UITextField *cropY;
@property (weak, nonatomic) IBOutlet UITextField *cropW;
@property (weak, nonatomic) IBOutlet UITextField *cropH;

@property (weak, nonatomic) IBOutlet UITextField *audioFadeInTime;
@property (weak, nonatomic) IBOutlet UITextField *videoFadeInTime;
@property (weak, nonatomic) IBOutlet UITextField *videoFadeInOpacity;

@property (weak, nonatomic) IBOutlet UITextField *filterType;
@property (weak, nonatomic) IBOutlet UITextField *whiting;
@property (weak, nonatomic) IBOutlet UITextField *smooth;
@property (weak, nonatomic) IBOutlet UITextField *brightness;
@property (weak, nonatomic) IBOutlet UITextField *contrast;
@property (weak, nonatomic) IBOutlet UITextField *saturation;
@property (weak, nonatomic) IBOutlet UITextField *sharpness;
@property (weak, nonatomic) IBOutlet UITextField *hue;

@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *uiX;
@property (weak, nonatomic) IBOutlet UITextField *uiY;
@property (weak, nonatomic) IBOutlet UITextField *uiWidth;
@property (weak, nonatomic) IBOutlet UITextField *uiHeight;
@property (weak, nonatomic) IBOutlet UITextField *uiBeginTime;
@property (weak, nonatomic) IBOutlet UITextField *uiDuration;

@end

@implementation SVDOutputConfigView

+ (void)load
{
    [[NSBundle mainBundle] loadNibNamed:@"SVDOutputConfigView" owner:self options:nil];
}

+ (instancetype)instance
{
    SVDOutputConfigView *cell = [[[NSBundle mainBundle] loadNibNamed:@"SVDOutputConfigView" owner:self options:nil] firstObject];
    cell.configData = [[SVDOutputFileConfigModel alloc] init];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat)cellHeight {
    return 675;
}

- (void)setConfigData:(SVDOutputFileConfigModel *)configData
{
    _configData = configData;
    
    _videoWidth.text = [NSString stringWithFormat:@"%zi", configData.videoWidth];
    _videoHeight.text = [NSString stringWithFormat:@"%zi", configData.videoHeight];
    _videoQuality.text = [NSString stringWithFormat:@"%zi", configData.videoQuality];
    _videoScaleModel.text = [NSString stringWithFormat:@"%zi", configData.videoScaleMode];
    
    _audioFadeInTime.text = [NSString stringWithFormat:@"%zi", configData.audioFadeDurationS];
    _videoFadeInTime.text = [NSString stringWithFormat:@"%zi", configData.videoFadeDurationS];
    _videoFadeInOpacity.text = [NSString stringWithFormat:@"%.1f", configData.videoFadeOpacity];
    
    _mainValueIntensity.text = [NSString stringWithFormat:@"%.1f", configData.mainVolumeIntensity];
    _audioValueIntensity.text = [NSString stringWithFormat:@"%.1f", configData.audioVolumeIntensity];
    _isMixMainAudio.on = configData.isMixedMainAudio;
    _isMute.on = configData.isMute;
    
    _beginTimeS.text = [NSString stringWithFormat:@"%zi", configData.begineTimeS];
    _durationS.text = [NSString stringWithFormat:@"%zi", configData.durationS];
    
    _cropX.text = [NSString stringWithFormat:@"%zi", configData.cropX];
    _cropY.text = [NSString stringWithFormat:@"%zi", configData.cropY];
    _cropW.text = [NSString stringWithFormat:@"%zi", configData.cropW];
    _cropH.text = [NSString stringWithFormat:@"%zi", configData.cropH];
    
    _filterType.text = [NSString stringWithFormat:@"%zi", configData.filterType];
    _whiting.text = [NSString stringWithFormat:@"%.1f", configData.whiting];
    _smooth.text = [NSString stringWithFormat:@"%.1f", configData.smooth];
    _brightness.text = [NSString stringWithFormat:@"%.1f", configData.brightness];
    _contrast.text = [NSString stringWithFormat:@"%.1f", configData.contrast];
    _saturation.text = [NSString stringWithFormat:@"%.1f", configData.saturation];
    _sharpness.text = [NSString stringWithFormat:@"%.1f", configData.sharpness];
    _hue.text = [NSString stringWithFormat:@"%.1f", configData.hue];
    
    _location.text = [NSString stringWithFormat:@"%zi", configData.location];
    _uiX.text = [NSString stringWithFormat:@"%zi", configData.uiX];
    _uiY.text = [NSString stringWithFormat:@"%zi", configData.uiY];
    _uiWidth.text = [NSString stringWithFormat:@"%zi", configData.uiWidth];
    _uiHeight.text = [NSString stringWithFormat:@"%zi", configData.uiHeight];
    _uiBeginTime.text = [NSString stringWithFormat:@"%zi", configData.uiBeginTime];
    _uiDuration.text = [NSString stringWithFormat:@"%zi", configData.uiDuration];
}

#pragma mark -- 事件
//输出视频宽度
- (IBAction)videoWidthAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置输出视频宽度: %zi", [sender.text integerValue]);
    _configData.videoWidth = [sender.text integerValue];
}

//输出视频高度
- (IBAction)videoHeightAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置输出视频高度: %zi", [sender.text integerValue]);
    _configData.videoHeight = [sender.text integerValue];
}

//输出视频质量
- (IBAction)videoQuality:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置输出视频质量: %zi", [sender.text integerValue]);
    _configData.videoQuality = [sender.text integerValue];
}

//输出视频填充模式
- (IBAction)videoScaleMode:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置输出视频填充模式: %zi", [sender.text integerValue]);
    _configData.videoScaleMode = [sender.text integerValue];
}

#pragma mark - 视频裁剪
//视频裁剪X
- (IBAction)cropXAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置输出视频裁剪X: %zi", [sender.text integerValue]);
    _configData.cropX = [sender.text integerValue];
}

//视频裁剪Y
- (IBAction)cropYAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置输出视频裁剪Y: %zi", [sender.text integerValue]);
    _configData.cropY = [sender.text integerValue];
}

//视频裁剪width
- (IBAction)cropWAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置输出视频裁剪width: %zi", [sender.text integerValue]);
    _configData.cropW = [sender.text integerValue];
}

//视频裁剪height
- (IBAction)cropHAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置输出视频裁剪height: %zi", [sender.text integerValue]);
    _configData.cropH = [sender.text integerValue];
}

#pragma mark - 特效
//视频转场淡入淡出时间
- (IBAction)videoFadeInOutTimeAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置输出视频转场淡入淡出时间: %zi", [sender.text integerValue]);
    _configData.videoFadeDurationS = [sender.text integerValue];
}

//视频转场淡入淡出透明度
- (IBAction)videoFadeInOutOpacity:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置输出视频转场淡入淡出透明度: %f", [sender.text floatValue]);
    _configData.videoFadeOpacity = [sender.text floatValue];
}

//音频转场淡入淡出时间
- (IBAction)audioFadeInOutTimeAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置输出音频转场淡入淡出时间: %zi", [sender.text integerValue]);
    _configData.audioFadeDurationS = [sender.text integerValue];
}

#pragma mark - 音频
//主文件音量
- (IBAction)mainFileVolumeAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置主文件音量: %f", [sender.text floatValue]);
    _configData.mainVolumeIntensity = [sender.text floatValue];
}

//伴音文件音量
- (IBAction)audioFileVolumeAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置伴音文件音量: %f", [sender.text floatValue]);
    _configData.audioVolumeIntensity = [sender.text floatValue];
}

//是否混入音频
- (IBAction)isMuxed:(UISwitch *)sender {
    NSLog(@"[转码测试Demo] 设置是否混入视频的音频: %@", (sender.isOn ? @"YES" : @"NO"));
    _configData.isMixedMainAudio = sender.isOn;
}

//是否静音
- (IBAction)isMuted:(UISwitch*)sender {
    NSLog(@"[转码测试Demo] 设置是否静音: %@", (sender.isOn ? @"YES" : @"NO"));
    _configData.isMute = sender.isOn;
}

#pragma mark - 截取
//视频截取开始时间
- (IBAction)beginTimeAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置视频截取开始时间: %zi", [sender.text integerValue]);
    _configData.begineTimeS = [sender.text integerValue];
}

//视频截取时长
- (IBAction)durationAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置视频截取时长: %zi", [sender.text integerValue]);
    _configData.durationS = [sender.text integerValue];
}

#pragma mark - 滤镜
//滤镜类型
- (IBAction)fiterType:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置滤镜类型: %zi", [sender.text integerValue]);
    _configData.filterType = [sender.text integerValue];
}

//美白强度
- (IBAction)whitingValue:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置美白强度: %f", [sender.text floatValue]);
    _configData.whiting = [sender.text floatValue];
}

//磨皮强度
- (IBAction)smoothValue:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置磨皮强度: %f", [sender.text floatValue]);
    _configData.smooth = [sender.text floatValue];
}

//亮度
- (IBAction)brightnessAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置亮度: %f", [sender.text floatValue]);
    _configData.brightness = [sender.text floatValue];
}

//对比度
- (IBAction)contrastAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置对比度: %f", [sender.text floatValue]);
    _configData.contrast = [sender.text floatValue];
}

//饱和度
- (IBAction)saturationAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置饱和度: %f", [sender.text floatValue]);
    _configData.saturation = [sender.text floatValue];
}

//锐度
- (IBAction)sharpnessAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置锐度: %f", [sender.text floatValue]);
    _configData.sharpness = [sender.text floatValue];
}

//色温
- (IBAction)hueAction:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置色温: %f", [sender.text floatValue]);
    _configData.hue = [sender.text floatValue];
}

#pragma mark - 水印
//水印位置
- (IBAction)location:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置水印位置: %zi", [sender.text integerValue]);
    _configData.location = [sender.text integerValue];
}

//uiX
- (IBAction)uiX:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置水印uiX: %zi", [sender.text integerValue]);
    _configData.uiX = [sender.text integerValue];
}

//uiY
- (IBAction)uiY:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置水印uiY: %zi", [sender.text integerValue]);
    _configData.uiY = [sender.text integerValue];
}

//uiWidth
- (IBAction)uiWidth:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置水印uiWidth: %zi", [sender.text integerValue]);
    _configData.uiWidth = [sender.text integerValue];
}

//uiHeight
- (IBAction)uiHeight:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置水印uiHeight: %zi", [sender.text integerValue]);
    _configData.uiHeight = [sender.text integerValue];
}

//uiBeginTime
- (IBAction)uiBeginTime:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置水印uiBeginTime: %zi", [sender.text integerValue]);
    _configData.uiBeginTime = [sender.text integerValue];
}

//uiDurationTime
- (IBAction)uiDurationTime:(UITextField *)sender {
    NSLog(@"[转码测试Demo] 设置水印uiDurationTime: %zi", [sender.text integerValue]);
    _configData.uiDuration = [sender.text integerValue];
}
@end
