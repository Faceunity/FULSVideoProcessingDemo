//
//  LSMediaPicprocess.h
//  LSMediaRecoderAndProcessor
//
//  Created by Netease on 2018/4/24.
//  Copyright © 2018年 朱玲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GPUImageFilter;

/**
 图片处理完成回调

 @param oriImage 原图片
 @param dstImage 输出图片
 @param error 错误
 */
typedef void(^LSPicprocessComplete)(UIImage *oriImage, UIImage *dstImage, NSError *error);

/**
 图片滤镜类型
 */
typedef NS_ENUM(NSInteger, LSPicGPUImageFilterType) {
    /**
     无
     */
    LS_PIC_GPUIMAGE_NORMAL = 0,
    /**
     黑白
     */
    LS_PIC_GPUIMAGE_SEPIA,
    /**
     自然
     */
    LS_PIC_GPUIMAGE_ZIRAN,
    /**
     粉嫩
     */
    LS_PIC_GPUIMAGE_MEIYAN1,
    /**
     怀旧
     */
    LS_PIC_GPUIMAGE_MEIYAN2,
};


/**
 图片处理主类
 */
@interface LSMediaPicprocess : NSObject

/**
 输入的图片
 */
@property (nonatomic, strong) UIImage *image;


/**
 图片裁剪

 @param rect 裁剪区域
 @param complete 完成回调
 */
- (void) cropWithRect:(CGRect)rect
             complete:(LSPicprocessComplete)complete;

/**
 图片马赛克预览视图
 */
@property (nonatomic, readonly) UIView *masicPreview;

/**
 图片马赛克的线宽
 */
@property (nonatomic, assign) CGFloat masicLineWidth;

/**
 图片增加马赛克

 @param complete 完成回调
 */
- (void) addmosaicComplete:(LSPicprocessComplete)complete;

/**
 图片增加贴图

 @param image 贴图
 @param rect 粘贴区域
 @param complete 完成回调
 */
- (void) addSticker:(UIImage *)image
               rect:(CGRect)rect
           complete:(LSPicprocessComplete)complete;


/**
 图片增加滤镜

 @param filterType 滤镜类型
 @param filter 自定义滤镜
 @param complete 完成回调
 */
- (void) addFilterWithType:(LSPicGPUImageFilterType)filterType
                    filter:(GPUImageFilter *)filter
                  complete:(LSPicprocessComplete)complete;

@end
