//
//  SVDBundleScanVC.h
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BundleScanProtocol;

@interface SVDBundleScanVC : UIViewController
@property (nonatomic, strong) NSArray *fileFormats;
@property (nonatomic, weak) id <BundleScanProtocol> delegate;
@end

@protocol BundleScanProtocol<NSObject>
- (void)BundleScanSelectedComplete:(NSString *)path;
@end
