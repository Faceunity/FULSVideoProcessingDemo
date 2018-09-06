//
//  SVDMainVC.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 17/6/20.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDMainVC.h"
#import "NTESAuthorizationHelper.h"
#import "NTESRecordVC.h"
#import "SVDContainerVC.h"
#import "SVDTranscodePreviewVC.h"
#import "SVPictureProcessVC.h"
#import "UIAlertView+NTESBlock.h"

@interface SVDMainVC ()

@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UIButton *transcodeBtn;
@property (nonatomic, strong) UIButton *previewBtn;
@property (nonatomic, strong) UIButton *pictureBtn;

@end

@implementation SVDMainVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.transcodeBtn];
    [self.view addSubview:self.previewBtn];
    [self.view addSubview:self.pictureBtn];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _recordBtn.frame = CGRectMake(64, 80, self.view.width - 2 * 64, 64);
    _transcodeBtn.frame = CGRectMake(_recordBtn.left, _recordBtn.bottom + 64, _recordBtn.width, _recordBtn.height);
    _previewBtn.frame = CGRectMake(_recordBtn.left, _transcodeBtn.bottom + 64, _transcodeBtn.width, _transcodeBtn.height);
    _pictureBtn.frame = CGRectMake(_recordBtn.left, _previewBtn.bottom + 64, _previewBtn.width, _previewBtn.height);
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication].keyWindow.rootViewController setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Action
//进入录制测试Demo
- (void)goRecordVC:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [NTESAuthorizationHelper requestMediaCapturerAccessWithHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil)
            {
                NTESRecordVC *recordVC = [[NTESRecordVC alloc] init];
                [weakSelf.navigationController pushViewController:recordVC animated:YES];
            }
            else
            {
                [UIAlertView showMessage:@"请开启摄像头和麦克风权限"];
            }
        });
    }];
}

//进入转码测试Demo
- (void)goTransVC:(UIButton *)sender {
    SVDContainerVC *push = [[SVDContainerVC alloc] init];
    [self.navigationController pushViewController:push animated:YES];
   
}

//进入转码预览Demo
- (void)goPreviewVC:(UIButton *)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"MOV"];
    SVDTranscodePreviewVC *editVC = [[SVDTranscodePreviewVC alloc] initWithFilePaths:@[path]];
    [self.navigationController pushViewController:editVC animated:YES];
}

//进入图片预览Demo
- (void)goPictureVC:(UIButton *)sender {
    SVPictureProcessVC *picVC = [[SVPictureProcessVC alloc] init];
    [self.navigationController pushViewController:picVC animated:YES];
}

#pragma mark - Getter
- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setTitle:@"录制测试Demo" forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"按钮 按下"] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(goRecordVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (UIButton *)transcodeBtn {
    if (!_transcodeBtn) {
        _transcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_transcodeBtn setBackgroundImage:[UIImage imageNamed:@"按钮 按下"] forState:UIControlStateNormal];
        [_transcodeBtn setTitle:@"转码测试Demo" forState:UIControlStateNormal];
        [_transcodeBtn addTarget:self action:@selector(goTransVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transcodeBtn;
}

- (UIButton *)previewBtn {
    if (!_previewBtn) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewBtn setBackgroundImage:[UIImage imageNamed:@"按钮 按下"] forState:UIControlStateNormal];
        [_previewBtn setTitle:@"转码预览Demo" forState:UIControlStateNormal];
        [_previewBtn addTarget:self action:@selector(goPreviewVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewBtn;
}


- (UIButton *)pictureBtn {
    if (!_pictureBtn) {
        _pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pictureBtn setBackgroundImage:[UIImage imageNamed:@"按钮 按下"] forState:UIControlStateNormal];
        [_pictureBtn setTitle:@"图片处理Demo" forState:UIControlStateNormal];
        [_pictureBtn addTarget:self action:@selector(goPictureVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pictureBtn;
}

@end
