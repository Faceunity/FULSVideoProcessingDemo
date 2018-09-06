//
//  NTESFilterBar.h
//  LSVideoProcessingDemo
//
//  Created by Netease on 17/6/22.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESMenuBaseBar.h"

typedef void(^NTESFilterBarValueBlock)(CGFloat value);
typedef void(^NTESFilterBarSwitchBlock)(BOOL isOn);

@interface NTESFilterBar : NTESMenuBaseBar

@property (nonatomic, copy) NTESFilterBarValueBlock whiteningBlock;

@property (nonatomic, copy) NTESFilterBarValueBlock smoothBlock;

@property (nonatomic, copy) NTESFilterBarSwitchBlock beautyBlock;

@property (nonatomic, strong) NSArray *datas;

@end
