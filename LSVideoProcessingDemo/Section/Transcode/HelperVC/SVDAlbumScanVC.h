//
//  SVDAlbumScanVC.h
//  NELivePlayerDemo
//
//  Created by Netease on 2017/9/5.
//  Copyright © 2017年 netease. All rights reserved.
//  相册扫描视图。

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NEAuthorizationStatus) {
    NEAuthorizationStatusAuthorized = 0,    // 已授权
    NEAuthorizationStatusDenied,            // 拒绝
    NEAuthorizationStatusRestricted,        // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    NEAuthorizationStatusNotSupport         // 硬件等不支持
};

typedef void (^AuthorizationBlock)(NEAuthorizationStatus status);

@protocol SVDAlbumScanVCProtocol;

@interface SVDAlbumScanVC : NSObject

@property (nonatomic, strong) UIImagePickerController *picker; //图片VC

@property (nonatomic, weak) id <SVDAlbumScanVCProtocol> delegate;

+ (void)requestImagePickerAuthorization:(AuthorizationBlock)callback;

@end

@protocol SVDAlbumScanVCProtocol <NSObject>

- (void)AlbumScanSelectedComplete:(NSString *)path;

@end
