//
//  SVDSystemPlayer.h
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVDSystemPlayer : NSObject

+ (void)playWithFilePath:(NSString *)filePath;

+ (AVAudioPlayer *)audioPlayWithFilePath:(NSString *)path;

@end
