//
//  SVDSandboxScanVC.h
//  NELivePlayerDemo
//
//  Created by Netease on 2017/9/5.
//  Copyright © 2017年 netease. All rights reserved.
//  本地沙盒和Bundle扫描视图。

#import <UIKit/UIKit.h>

@protocol SandBoxScanProtocol;
@interface SVDSandboxScanVC : UIViewController
@property (nonatomic, strong) NSArray *fileFormats;
@property (nonatomic, weak) id<SandBoxScanProtocol> delegate;
@end

@protocol SandBoxScanProtocol<NSObject>
- (void)SandboxScanSelectedComplete:(NSString *)path;
@end
