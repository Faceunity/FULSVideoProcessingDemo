//
//  SVDTranscodeView.h
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SVDTranscodeViewProtocol;

@interface SVDTranscodeView : UIView

@property (nonatomic, weak) id <SVDTranscodeViewProtocol> delegate;

@property (nonatomic, copy) NSString *dstFilePath;

@property (nonatomic, assign) BOOL isTranscoding;

@property (nonatomic, assign) BOOL isInverting;

@property (nonatomic, assign) float invertSpeedValue;

@property (nonatomic, assign) CGFloat processValue;

- (void)upedatePlayState;

@end

@protocol SVDTranscodeViewProtocol <NSObject>

- (void)TranscodeViewPlayAction:(SVDTranscodeView *)view;
- (void)TranscodeViewStartAction:(SVDTranscodeView *)view;
- (void)TranscodeViewStopAction:(SVDTranscodeView *)view;
- (void)TranscodeViewInvertStartAction:(SVDTranscodeView *)view;
- (void)TranscodeViewInvertStopAction:(SVDTranscodeView *)view;

@end

