//
//  SVDSystemPlayer.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDSystemPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation SVDSystemPlayer
+ (void)playWithFilePath:(NSString *)filePath
{
    NSLog(@"[转码测试Demo] 系统播放器，播放:[%@]", filePath);
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
    {
        MPMoviePlayerViewController *mpPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
        mpPlayer.moviePlayer.scalingMode = MPMovieScalingModeFill;
        [mpPlayer.moviePlayer prepareToPlay];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:mpPlayer animated:YES completion:nil];
    }
    else
    {
        AVPlayerViewController *avplayer = [[AVPlayerViewController alloc] init];
        AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
        avplayer.player = player;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:avplayer animated:YES completion:nil];
        [avplayer.player play];
    }
}

+ (AVAudioPlayer *)audioPlayWithFilePath:(NSString *)path
{
    AVAudioPlayer *player = nil;
    
    if (path)
    {
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        player.volume = 1.0;
        if (!error) {
            player.numberOfLoops = -1;
        }
    }
    
    return player;
}

@end
