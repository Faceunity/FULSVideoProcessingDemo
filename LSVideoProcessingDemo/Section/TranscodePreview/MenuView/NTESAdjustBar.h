//
//  NTESAdjustBar.h
//  LSVideoProcessingDemo
//
//  Created by Netease on 17/6/21.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESMenuBaseBar.h"

typedef void(^NTESAdjustValueChanged)(CGFloat value);

@interface NTESAdjustBar : NTESMenuBaseBar

@property (nonatomic, copy) NTESAdjustValueChanged brightnessBlock;
@property (nonatomic, copy) NTESAdjustValueChanged contrastBlock;
@property (nonatomic, copy) NTESAdjustValueChanged saturationBlock;
@property (nonatomic, copy) NTESAdjustValueChanged sharpnessBlock;
@property (nonatomic, copy) NTESAdjustValueChanged hueBlock;

- (void)defaultValue;

@end
