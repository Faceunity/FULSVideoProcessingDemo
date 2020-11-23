//
//  SVDTranscodePreviewVC.h
//  ShortVideo_Demo
//
//  Created by Netease on 17/2/20.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVDTranscodePreviewVC : UIViewController

- (instancetype)initWithFilePaths:(NSArray *)filePaths;

/// 是否从录制进来
@property(nonatomic, assign) BOOL isFromRecord;


@end
