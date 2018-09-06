//
//  NTESAudioMenuBar.h
//  NTES_Live_Demo
//
//  Created by zhanggenning on 17/1/20.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESMenuBaseBar.h"

typedef void(^NTESAudioMenuValueBlock)(CGFloat value);

@interface NTESAudioMenuBar : NTESMenuBaseBar

@property (nonatomic, strong) NTESAudioMenuValueBlock volumeBlock;

@property (nonatomic, strong) NTESAudioMenuValueBlock audioVolumeBlock;

@property (nonatomic, strong) NSArray *audioPaths;

@end
