//
//  SVDAlbumScanVC.m
//  NELivePlayerDemo
//
//  Created by Netease on 2017/9/5.
//  Copyright © 2017年 netease. All rights reserved.
//  相册扫描视图。

#import "SVDAlbumScanVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>


@interface SVDAlbumScanVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation SVDAlbumScanVC

- (instancetype)init
{
    if (self = [super init]) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSArray *arrMediaTypes=[NSArray arrayWithObjects:(NSString *)kUTTypeMovie,
                                (NSString *)kUTTypeVideo,
                                (NSString *)kUTTypeAudio,
                                (NSString *)kUTTypeQuickTimeMovie,
                                nil];
        [_picker setMediaTypes: arrMediaTypes];
        _picker.delegate = self;
    }
    return self;
}

#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie])
    {
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        if (_delegate && [_delegate respondsToSelector:@selector(AlbumScanSelectedComplete:)]) {
            [_delegate AlbumScanSelectedComplete:videoPath];
        }
        //退出
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Authorization
//相册权限
+ (void)requestImagePickerAuthorization:(AuthorizationBlock)callback {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusNotDetermined) { // 未授权
            if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
                if (callback) {
                    callback(NEAuthorizationStatusAuthorized);
                }
            } else {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {
                        if (callback) {
                            callback(NEAuthorizationStatusAuthorized);
                        }
                    } else if (status == PHAuthorizationStatusDenied) {
                        if (callback) {
                            callback(NEAuthorizationStatusDenied);
                        };
                    } else if (status == PHAuthorizationStatusRestricted) {
                        if (callback) {
                            callback(NEAuthorizationStatusRestricted);
                        };
                    }
                }];
            }
        } else if (authStatus == ALAuthorizationStatusAuthorized) {
            if (callback) {
                callback(NEAuthorizationStatusAuthorized);
            }
        } else if (authStatus == ALAuthorizationStatusDenied) {
            if (callback) {
                callback(NEAuthorizationStatusDenied);
            }
        } else if (authStatus == ALAuthorizationStatusRestricted) {
            if (callback) {
                callback(NEAuthorizationStatusRestricted);
            }
        }
    } else {
        if (callback) {
            callback(NEAuthorizationStatusNotSupport);
        }
    }
}

@end
