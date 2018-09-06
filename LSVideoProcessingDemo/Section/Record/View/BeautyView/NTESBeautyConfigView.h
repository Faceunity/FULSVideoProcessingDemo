//
//  NTESBeautyConfigView.h
//  ShortVideoProcess_Demo
//
//  Created by Netease on 17/3/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESBaseView.h"

typedef void(^NTESBeautyValueChangedBlock)(CGFloat value);

@interface NTESBeautyConfigView : NTESBaseView

@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, assign) CGFloat minValue;

@property (nonatomic, assign) CGFloat curValue;

@property (nonatomic, assign) CGFloat secMaxValue;

@property (nonatomic, assign) CGFloat secMinValue;

@property (nonatomic, assign) CGFloat secCurValue;

@property (nonatomic, copy) NTESBeautyValueChangedBlock valueChangedBlock;

@property (nonatomic, copy) NTESBeautyValueChangedBlock secValueChangedBlock;

- (void)showInView:(UIView *)view complete:(void (^)())complete;

- (void)dismissComplete:(void (^)())complete;

@end
