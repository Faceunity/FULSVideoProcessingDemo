//
//  NTESRecordTopBar.h
//  ShortVideoProcess_Demo
//
//  Created by Netease on 17/3/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESBaseView.h"

@protocol NTESRecordTopBarProtocol;

@interface NTESRecordTopBar : NTESBaseView

@property (nonatomic, weak) id <NTESRecordTopBarProtocol> delegate;

@property (nonatomic, assign) BOOL hiddenBeauty;

@property (nonatomic, assign) BOOL hiddenFilterConfig;

@property (nonatomic, assign) BOOL isBeauty;

@end

@protocol NTESRecordTopBarProtocol <NSObject>

@optional

- (void)TopBarQuitAction:(NTESRecordTopBar *)bar;

- (void)TopBarFilterConfigAction:(NTESRecordTopBar *)bar;

- (void)TopBarFilterAction:(NTESRecordTopBar *)bar;

- (void)TopBarCameraAction:(NTESRecordTopBar *)bar;

- (void)TopBarAudioAction:(NTESRecordTopBar *)bar;

- (void)TopBarBeautyAction:(NTESRecordTopBar *)bar on:(BOOL)isOn;

- (void)TopBarFaceUSdkAction:(NTESRecordTopBar *)bar on:(BOOL)isOn;

- (void)TopBarWaterAction:(NTESRecordTopBar *)bar type:(NSInteger)type loc:(NSInteger)loc;

@end
