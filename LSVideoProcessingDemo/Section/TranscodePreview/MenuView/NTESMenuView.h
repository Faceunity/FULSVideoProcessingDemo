//
//  NTESMenuView.h
//  NEUIDemo
//
//  Created by Netease on 17/1/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESMenuViewProtocol;

typedef NS_ENUM(NSInteger,NTESMenuType)
{
    NTESMenuTypeAudio , //伴音选项
    NTESMenuTypeAdjust , //调节选项
    NTESMenuTypeFilter //滤镜选项
};

@interface NTESMenuView : UIControl

@property (nonatomic, weak) id <NTESMenuViewProtocol> delegate;

@property (nonatomic, assign) NSInteger selectedIndex; //选择

@property (nonatomic, strong) NSArray *audioPaths;

@property (nonatomic, strong) NSArray *filterTypes;

- (instancetype)initWithType:(NTESMenuType)type;

- (void)show;

- (void)dismiss;

- (void)defaultValue;

@end

@protocol NTESMenuViewProtocol <NSObject>
@optional
- (void)menuView:(NTESMenuView *)menu startPlayAudio:(NSString *)path;

- (void)menuViewStopPlayAudio:(NTESMenuView *)menu;

- (void)menuView:(NTESMenuView *)menu mainAudioVolume:(CGFloat)volume;

- (void)menuView:(NTESMenuView *)menu secAudioVolume:(CGFloat)volume;

- (void)menuView:(NTESMenuView *)menu brightness:(CGFloat)brightness;

- (void)menuView:(NTESMenuView *)menu contrast:(CGFloat)contrast;

- (void)menuView:(NTESMenuView *)menu saturation:(CGFloat)saturation;

- (void)menuView:(NTESMenuView *)menu sharpness:(CGFloat)sharpness;

- (void)menuView:(NTESMenuView *)menu hue:(CGFloat)hue;

- (void)menuView:(NTESMenuView *)menu filter:(NSInteger)type;

- (void)menuView:(NTESMenuView *)menu whitening:(CGFloat)whitening;

- (void)menuView:(NTESMenuView *)menu smooth:(CGFloat)smooth;

- (void)menuView:(NTESMenuView *)menu beauty:(BOOL)beauty;

@end
