//
//  SVDInputFileModel.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/10/11.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDInputFileModel.h"

@implementation SVDInputFileModel
- (instancetype)init {
    if (self = [super init]) {
        _videoCellHeight = 143.0;
        _audioCellHeight = 93.0;
        _speed = 1.0;
    }
    return self;
}
@end
