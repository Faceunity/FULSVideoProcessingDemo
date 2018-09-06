//
//  NTESRootNavVC.m
//  LiveStream_IM_Demo
//
//  Created by Netease on 17/1/11.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESRootNavVC.h"

@interface NTESRootNavVC ()

@end

@implementation NTESRootNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.viewControllers.lastObject preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    return [self.viewControllers.lastObject prefersStatusBarHidden];
}

@end
