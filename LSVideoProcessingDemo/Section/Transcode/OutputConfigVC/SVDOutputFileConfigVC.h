//
//  SVDOutputFileConfigVC.h
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/29.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVDOutputFileConfigModel;

@interface SVDOutputFileConfigVC : UIViewController

@property (nonatomic, strong, readwrite) SVDOutputFileConfigModel *configData;

@end


@interface SVDOutputFileConfigModel : NSObject

@property (nonatomic, assign) NSInteger videoWidth;
@property (nonatomic, assign) NSInteger videoHeight;
@property (nonatomic, assign) NSInteger videoQuality;
@property (nonatomic, assign) NSInteger videoScaleMode;

@property (nonatomic, assign) CGFloat videoFadeOpacity;
@property (nonatomic, assign) NSInteger videoFadeDurationS;
@property (nonatomic, assign) NSInteger audioFadeDurationS;

@property (nonatomic, assign) CGFloat mainVolumeIntensity;
@property (nonatomic, assign) CGFloat audioVolumeIntensity;
@property (nonatomic, assign) BOOL isMixedMainAudio;
@property (nonatomic, assign) BOOL isMute;

@property (nonatomic, assign) NSInteger begineTimeS;
@property (nonatomic, assign) NSInteger durationS;

@property (nonatomic, assign) NSInteger cropX;
@property (nonatomic, assign) NSInteger cropY;
@property (nonatomic, assign) NSInteger cropW;
@property (nonatomic, assign) NSInteger cropH;

@property (nonatomic, assign) NSInteger filterType;
@property (nonatomic, assign) CGFloat whiting;
@property (nonatomic, assign) CGFloat smooth;
@property (nonatomic, assign) CGFloat brightness;
@property (nonatomic, assign) CGFloat contrast;
@property (nonatomic, assign) CGFloat saturation;
@property (nonatomic, assign) CGFloat sharpness;
@property (nonatomic, assign) CGFloat hue;

@property (nonatomic, assign) NSInteger location;
@property (nonatomic, assign) NSInteger uiX;
@property (nonatomic, assign) NSInteger uiY;
@property (nonatomic, assign) NSInteger uiWidth;
@property (nonatomic, assign) NSInteger uiHeight;
@property (nonatomic, assign) NSInteger uiBeginTime;
@property (nonatomic, assign) NSInteger uiDuration;

@property (nonatomic, assign, readonly) BOOL isNeedCrop;
@property (nonatomic, assign, readonly) BOOL isNeedCut;
@property (nonatomic, assign, readonly) BOOL isNeedWaterMark;

@end
