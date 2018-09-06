//
//  SVDEditTopBar.h
//  LSVideoProcessingDemo
//
//  Created by Netease on 17/2/22.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SVDEditTopBarProtocol;

@interface SVDEditTopBar : UIView

@property (nonatomic, weak) id <SVDEditTopBarProtocol> delegate;

@end

@protocol SVDEditTopBarProtocol <NSObject>

- (void)SVDEditTopBarAudioAction:(SVDEditTopBar *)bar;

- (void)SVDEditTopBarAdjustAction:(SVDEditTopBar *)bar;

- (void)SVDEditTopBarImageAction:(SVDEditTopBar *)bar;

- (void)SVDEditTopBarFilterAction:(SVDEditTopBar *)bar;

- (void)SVDEditTopBarFaceUAction:(SVDEditTopBar *)bar isOn:(BOOL)isOn;

@end
