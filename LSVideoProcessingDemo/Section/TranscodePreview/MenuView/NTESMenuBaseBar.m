//
//  NTESMenuBaseBar.m
//  NTES_Live_Demo
//
//  Created by zhanggenning on 17/1/20.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESMenuBaseBar.h"

@implementation NTESMenuBaseBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        
        self.selectedIndex = -1;
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex != _selectedIndex)
    {
        _selectedIndex = selectedIndex;
        
        [self doSetSelectedIndex];
    }
}

#pragma mark - 子类重载
- (void)doSetSelectedIndex {};

- (CGFloat)barHeight
{
    return 110.0;
}

@end
