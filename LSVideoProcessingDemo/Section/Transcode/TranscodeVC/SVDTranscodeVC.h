//
//  SVDTranscodeVC.h
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SVDTranscodeVCProtocol;
@class SVDOutputFileConfigModel;

typedef void(^SVDTranscodeFileInfoBlock)(NSString *fileInfo);

@interface SVDTranscodeVC : UIViewController

@property (nonatomic, weak) id <SVDTranscodeVCProtocol> delegate;

- (void)transcodeGetFileInfo:(NSString *)filePath Complete:(SVDTranscodeFileInfoBlock)complete;

@end

@protocol SVDTranscodeVCProtocol <NSObject>

//获取主文件
- (NSArray *)TranscodeGetMainInputFiles;

//获取伴音文件
- (NSString *)TranscodeGetSecInputFile;

//获取输出参数
- (SVDOutputFileConfigModel *)TranscodeGetOutputConfig;

@end
