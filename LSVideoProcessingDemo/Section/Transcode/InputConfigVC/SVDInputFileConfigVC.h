//
//  SVDInputFileConfigVC.h
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVDInputFileModel.h"

@protocol InputConfigVCProtocol;

@interface SVDInputFileConfigVC : UIViewController

@property (nonatomic, strong, readonly) NSArray <SVDInputFileModel *> *mainFileModels;

@property (nonatomic, copy, readonly) NSString *secFilePath;

@property (nonatomic, weak) id <InputConfigVCProtocol> delegate;

- (void)setFileInfo:(NSString *)info index:(NSInteger)index;

@end

@protocol InputConfigVCProtocol <NSObject>
- (void)InputConfigSelectedFile:(SVDInputFileConfigVC *)configVC
                       fileModel:(SVDInputFileModel *)model
                          index:(NSInteger)index;
@end
