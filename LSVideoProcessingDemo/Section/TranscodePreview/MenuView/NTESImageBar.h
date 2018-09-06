//
//  NTESImageBar.h
//  LSVideoProcessingDemo
//
//  Created by Netease on 17/6/21.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NTESImageBarBlock)(CGRect rect);

@interface NTESImageBar : UIView

@property (nonatomic, copy) NTESImageBarBlock imageBlock;

@property (nonatomic, strong) UIImage *image;

@end
