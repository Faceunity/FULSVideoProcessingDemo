//
//  SVDInputConfigView.h
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVDInputFileModel.h"

@protocol InputConfigProtocol;

@interface SVDInputConfigView : UITableViewCell

@property (nonatomic, copy) NSString *infoText;
@property (nonatomic, weak) id <InputConfigProtocol> delegate;
@property (nonatomic, assign) BOOL canPlay;

@property (nonatomic, strong) SVDInputFileModel *model;

- (CGFloat)cellHeight;

@end

@protocol InputConfigProtocol<NSObject>
- (void)InputConfigBundleAction:(SVDInputConfigView *)configView;
- (void)InputConfigLocalAction:(SVDInputConfigView *)configView;
- (void)InputConfigAlbumAction:(SVDInputConfigView *)configView;
- (void)InputConfigPlayAction:(SVDInputConfigView *)configView;
- (void)InputConfigAddAction:(SVDInputConfigView *)configView;
- (void)InputConfigDelAction:(SVDInputConfigView *)configView;

- (void)InputConfigSetSpeed:(SVDInputConfigView *)configView speed:(CGFloat)speed;
- (void)InputConfigSetSpeedBegin:(SVDInputConfigView *)configView begin:(CGFloat)begin;
- (void)InputConfigSetSpeedDuration:(SVDInputConfigView *)configView duration:(CGFloat)duration;
@end
