//
//  NTESVideoMaskBar.h
//  ShortVideoProcess_Demo
//
//  Created by Netease on 17/4/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESVideoMaskBarDelegate;

@interface NTESVideoMaskBar : UIControl

@property (nonatomic, assign) CGFloat exposureValue;

@property (nonatomic, weak) id <NTESVideoMaskBarDelegate> delegate;

@end


@protocol NTESVideoMaskBarDelegate <NSObject>

- (void)MaskBar:(NTESVideoMaskBar *)bar exposureValueChanged:(CGFloat)exposure;

- (void)MaskBar:(NTESVideoMaskBar *)bar focusInPoint:(CGPoint)point;

- (void)MaskBar:(NTESVideoMaskBar *)bar zoomChanged:(CGFloat)zoom;

@end
