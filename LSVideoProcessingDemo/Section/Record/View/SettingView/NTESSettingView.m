//
//  NTESSettingView.m
//  ShortVideo_Demo
//
//  Created by Netease on 17/2/17.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESSettingView.h"
#import "NTESSettingViewCell.h"
#import "NTESRecordDataCenter.h"

@interface NTESSettingView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *titleLine;
@property (nonatomic, strong) UITableView *list;

@property (nonatomic, strong) NSMutableArray *durationStrs;
@property (nonatomic, strong) NSMutableArray *sectionStrs;
@property (nonatomic, strong) NTESRecordConfigEntity *entity;

@end

@implementation NTESSettingView

- (void)doInit
{
    self.alpha = 0.0;
    self.clipsToBounds = YES;

    //初始化
    [self addSubview:self.titleLab];
    [self addSubview:self.titleLine];
    [self addSubview:self.list];
}

- (void)configWithEntity:(NTESRecordConfigEntity *)entity
{
    if (!entity) {
        return;
    }
    
    _entity = entity;
    
    //时长
    if (!_durationStrs)
    {
        _durationStrs = [NSMutableArray array];
    }
    else
    {
        [_durationStrs removeAllObjects];
    }
    for (NSNumber *num in entity.durationDatas)
    {
        NSString *str = [NSString stringWithFormat:@"%@S", num];
        [_durationStrs addObject:str];
    }
    
    //段落
    if (!_sectionStrs)
    {
        _sectionStrs = [NSMutableArray array];
    }
    else
    {
        [_sectionStrs removeAllObjects];
    }
    [self.list reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLine.frame = CGRectMake(16, 57.0, self.width - 16*2, 1);
    self.titleLab.center = CGPointMake(self.width/2, self.titleLine.top/2);
    self.list.frame = CGRectMake(0,
                                 self.titleLine.bottom + 2,
                                 self.width,
                                 self.height - self.titleLine.bottom + 2);
}

#pragma mark - Public
- (void)showInView:(UIView *)view complete:(void(^)())complete
{
    [self removeFromSuperview];
    
    if (self.alpha == 0.0)
    {
        [view addSubview:self];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (complete) {
                complete();
            }
        }];
    }
    else
    {
        if (complete) {
            complete();
        }
    }
}

- (void)dismissComplete:(void(^)())complete
{
    if (self.alpha != 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            
            if (complete) {
                complete();
            }
        }];
    }
    else
    {
        if (complete) {
            complete();
        }
    }
}

- (CGFloat)settingHeight
{
    return 272.0;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _entity ? 4 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) //选择分辨率
    {
        NTESSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NTESSettingViewCell"
                                                                    forIndexPath:indexPath];
        
        [cell configCellWithTitle:@"清晰度" datas:_entity.resolutionDatas selecedIndex:_entity.curResolutionIndex];
        
        //选择回调
        __weak typeof(self) weakSelf = self;
        cell.selectedBlock = ^(NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            strongSelf.entity.curResolutionIndex = index;
            
            if (strongSelf.delegate &&
                [strongSelf.delegate respondsToSelector:@selector(NTESSettingView:selectResolution:)])
            {
                [strongSelf.delegate NTESSettingView:strongSelf selectResolution:index];
            }
        };
        return cell;
    }
    else if (indexPath.row == 1) //选择段数
    {
        NTESSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NTESSettingViewCell"
                                                                    forIndexPath:indexPath];
        [cell configCellWithTitle:@"分段数" datas:_entity.sectionDatas selecedIndex:_entity.curSectionsIndex];
        
        //选择回调
        __weak typeof(self) weakSelf = self;
        cell.selectedBlock = ^(NSInteger index){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.entity.curSectionsIndex = index;
            if (strongSelf.delegate &&
                [strongSelf.delegate respondsToSelector:@selector(NTESSettingView:selectSection:)])
            {
                NSInteger section = [strongSelf.entity.sectionDatas[index] integerValue];
                [strongSelf.delegate NTESSettingView:strongSelf selectSection:section];
            }
        };
        return cell;
    }
    else if (indexPath.row == 2) //选择时长
    {
        NTESSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NTESSettingViewCell"
                                                                    forIndexPath:indexPath];
        
        [cell configCellWithTitle:@"总时长" datas:_entity.durationDatas selecedIndex:_entity.curDurationIndex];
        
        //选择回调
        __weak typeof(self) weakSelf = self;
        cell.selectedBlock = ^(NSInteger index){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.entity.curDurationIndex = index;
            if (strongSelf.delegate &&
                [strongSelf.delegate respondsToSelector:@selector(NTESSettingView:selectDuration:)])
            {
                NSInteger duration = [strongSelf.entity.durationDatas[index] integerValue];
                [strongSelf.delegate NTESSettingView:strongSelf selectDuration:duration];
            }
        };
        return cell;
    }
    else if (indexPath.row == 3) //选择画幅
    {
        NTESSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NTESSettingViewCell"
                                                                    forIndexPath:indexPath];
        [cell configCellWithTitle:@"画幅" datas:_entity.scaleModeDatas selecedIndex:_entity.curScaleModeIndex];
        
        //选择回调
        __weak typeof(self) weakSelf = self;
        cell.selectedBlock = ^(NSInteger index){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.entity.curScaleModeIndex = index;
            if (strongSelf.delegate &&
                [strongSelf.delegate respondsToSelector:@selector(NTESSettingView:selectScreen:)])
            {
                [strongSelf.delegate NTESSettingView:strongSelf selectScreen:index];
            }
        };
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"
                                                                forIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53.5;
}

#pragma mark - Getter
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:14.0];
        _titleLab.text = @"视频设置";
        [_titleLab sizeToFit];
    }
    return _titleLab;
}

- (UIView *)titleLine
{
    if (!_titleLine) {
        _titleLine = [[UIView alloc] init];
        _titleLine.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    }
    return _titleLine;
}

- (UITableView *)list
{
    if (!_list) {
        _list = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
        _list.dataSource = self;
        _list.delegate = self;
        _list.showsVerticalScrollIndicator = NO;
        _list.showsHorizontalScrollIndicator = NO;
        _list.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_list setBackgroundView:nil];
        [_list setBackgroundView:[[UIView alloc]init]];
        _list.backgroundView.backgroundColor = [UIColor clearColor];
        _list.backgroundColor = [UIColor clearColor];
        _list.clipsToBounds = YES;
        _list.bounces = NO;
        _list.scrollEnabled = NO;
        [_list registerClass:[NTESSettingViewCell class] forCellReuseIdentifier:@"NTESSettingViewCell"];
        [_list registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defaultCell"];
    }
    return _list;
}

@end
