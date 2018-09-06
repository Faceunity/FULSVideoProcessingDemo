//
//  NTESRecordControlBar.h
//  ShortVideoProcess_Demo
//
//  Created by Netease on 17/3/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESBaseView.h"
#import "NTESRecordDataCenter.h"

@protocol NTESRecordControlBarProtocol;

@interface NTESRecordControlBar : NTESBaseView

@property (nonatomic, weak) id <NTESRecordControlBarProtocol> delegate;

@property (nonatomic, strong) NTESRecordConfigEntity *configEntity; //配置信息

@property (nonatomic, assign) NSInteger completeRecordSections; //完成录制的段数

//取消录制
- (void)sendCancelRecordAction;

//删除录制
- (void)sendDeleteRecordAction;

//开始录制动画
- (void)startRecordAnimation;

//停止录制动画
- (void)stopRecordAnimation;

//获取视频的宽高
- (CGRect)videoRectWithScreenScale: (NSInteger)scale;

@end


@protocol NTESRecordControlBarProtocol <NSObject>
@optional

//退出事件
- (void)ControlBarQuit:(NTESRecordControlBar *)bar;

//摄像头事件
- (void)ControlBarCameraSwitch:(NTESRecordControlBar *)bar;

//美颜开关事件
- (void)ControlBar:(NTESRecordControlBar *)bar beauty:(BOOL)isBeauty;

//FaceU开关事件
- (void)ControlBar:(NTESRecordControlBar *)bar faceUOpen:(BOOL)isOpen;

//磨皮滤镜事件
- (void)ControlBar:(NTESRecordControlBar *)bar smooth:(CGFloat)smooth;

//美白滤镜事件
- (void)ControlBar:(NTESRecordControlBar *)bar whitening:(CGFloat)whitening;

//滤镜事件
- (void)ControlBar:(NTESRecordControlBar *)bar filter:(NSInteger)index;

//水印事件
- (void)ControlBar:(NTESRecordControlBar *)bar waterType:(NSInteger)waterType waterLoc:(NSInteger)waterLoc;

//分辨率事件
- (void)ControlBar:(NTESRecordControlBar *)bar resolution:(NSInteger)resolution;

//画幅事件
- (void)ControlBar:(NTESRecordControlBar *)bar frame:(CGRect)frame mode:(NSInteger)mode;

//曝光率事件
- (void)ControlBar:(NTESRecordControlBar *)bar exposure:(CGFloat)exposure;

//手动聚焦事件
- (void)ControlBar:(NTESRecordControlBar *)bar focusPoint:(CGPoint)point;

//变焦事件
- (void)ContorlBar:(NTESRecordControlBar *)bar zoom:(CGFloat)zoom;

//开始录制事件
- (void)ControlBarRecordDidStart:(NTESRecordControlBar *)bar;

//取消录制事件
- (void)ControlBarRecordDidCancelled:(NTESRecordControlBar *)bar;

//删除录制事件(上一个)
- (void)ControlBarRecordDidDeleted:(NTESRecordControlBar *)bar;

//完成录制事件
- (void)ControlBarRecordDidCompleted:(NTESRecordControlBar *)bar isSkip:(BOOL)isSkip;

//录制动画结束
- (void)ControlBarRecordAnimationDidStop:(NTESRecordControlBar *)bar  isCancel:(BOOL)isCancel;

//播放伴音事件
- (void)ControlBarStartPlay:(NTESRecordControlBar *)bar path:(NSString *)path;

//停止播放伴音事件
- (void)ControlBarStopPlay:(NTESRecordControlBar *)bar;

//麦克风采集音量设置
- (void)ControlBarSetMacrophoneVolume:(NTESRecordControlBar *)bar  volume:(CGFloat)volume;

//伴音音量
- (void)ControlBarSetAudioVolume:(NTESRecordControlBar *)bar  volume:(CGFloat)volume;

@end
