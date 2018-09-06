//
//  SVDOutputConfigView.h
//  LSMediaTranscodingDemo
//
//  Created by Netease on 16/12/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVDOutputFileConfigModel;

@interface SVDOutputConfigView : UITableViewCell

@property (nonatomic, strong, readwrite) SVDOutputFileConfigModel *configData;

+ (instancetype)instance;

+ (CGFloat)cellHeight;

@end
