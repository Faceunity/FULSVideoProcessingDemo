//
//  SVDInputFileModel.h
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/10/11.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVDInputFileModel : NSObject
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *fileInfo;
@property (nonatomic, assign) CGFloat audioCellHeight;
@property (nonatomic, assign) CGFloat videoCellHeight;
@property (nonatomic, assign) BOOL isCanPlay;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat speedBegin;
@property (nonatomic, assign) CGFloat speedDuration;
@end
