//
//  SVDEditBottomBar.h
//  ShortVideo_Demo
//
//  Created by Netease on 17/2/20.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SVDEditBottomBarProtocol;

@interface SVDEditBottomBar : UIView

@property (nonatomic, assign) BOOL enableSave;

@property (nonatomic, weak) id <SVDEditBottomBarProtocol> delegate;

@end

@protocol SVDEditBottomBarProtocol <NSObject>

- (void)SVDEditBottomBarBackAction:(SVDEditBottomBar *)bar;

- (void)SVDEditBottomBarSureAction:(SVDEditBottomBar *)bar;

- (void)SVDEditBottomBarSaveAction:(SVDEditBottomBar *)bar;

@end
