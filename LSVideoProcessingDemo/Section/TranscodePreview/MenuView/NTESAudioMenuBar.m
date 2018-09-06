//
//  NTESAudioMenuBar.m
//  NTES_Live_Demo
//
//  Created by zhanggenning on 17/1/20.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESAudioMenuBar.h"
#import "NTESMenuCell.h"

const CGFloat gAudioMenuRowsEveryPage = 4;
const CGFloat gAudioMenuLinesEveryPage = 1;

@interface NTESAudioMenuBar ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    CGFloat _row;
    CGFloat _line;
}

@property (nonatomic, strong) UICollectionViewFlowLayout *layout; //布局
@property (nonatomic, strong) UICollectionView *menuList; //选项控件
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *audioInfos; //伴音选项信息

@property (nonatomic, strong) UILabel *volumeLab;
@property (nonatomic, strong) UILabel *volumeMinLab;
@property (nonatomic, strong) UILabel *volumeMaxLab;
@property (nonatomic, strong) UISlider *voluemSlider;

@property (nonatomic, strong) UILabel *audioVolumeLab;
@property (nonatomic, strong) UILabel *audioVolumeMinLab;
@property (nonatomic, strong) UILabel *audioVolumeMaxLab;
@property (nonatomic, strong) UISlider *audioVolumeSlider;

@end

@implementation NTESAudioMenuBar

- (instancetype)init
{
    if (self = [super init])
    {
        [self addSubview:self.titleLab];
        [self addSubview:self.lineView];
        [self addSubview:self.menuList];
        [self addSubview:self.volumeLab];
        [self addSubview:self.volumeMinLab];
        [self addSubview:self.voluemSlider];
        [self addSubview:self.volumeMaxLab];
        [self addSubview:self.audioVolumeLab];
        [self addSubview:self.audioVolumeMinLab];
        [self addSubview:self.audioVolumeMaxLab];
        [self addSubview:self.audioVolumeSlider];
        
        _audioInfos = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!CGRectEqualToRect(self.menuList.frame, self.bounds)) {
        self.menuList.frame = self.bounds;
        self.titleLab.size = CGSizeMake(_titleLab.width, 50);
        self.titleLab.centerX = self.width/2;
        self.lineView.frame = CGRectMake(0, self.titleLab.bottom, self.width, 1);
        self.menuList.frame = CGRectMake(0, self.lineView.bottom + 10, self.width, 120);
        self.volumeLab.size = CGSizeMake(40, 20);
        self.volumeLab.frame = CGRectMake(8, _menuList.bottom + 16.0, 40, 20);
        self.volumeMinLab.size = CGSizeMake(25, 20);
        self.volumeMinLab.left = self.volumeLab.right + 8.0;
        self.volumeMinLab.centerY = self.volumeLab.centerY;
        self.volumeMaxLab.size = self.volumeMinLab.size;
        self.volumeMaxLab.right = self.width - 8.0;
        self.volumeMaxLab.centerY = self.volumeLab.centerY;
        self.voluemSlider.frame = CGRectMake(_volumeMinLab.right + 8.0,
                                             _volumeMinLab.top,
                                             _volumeMaxLab.left - 8.0 - _volumeMinLab.right - 8.0,
                                             _volumeMinLab.height);
        self.audioVolumeLab.frame = CGRectMake(_volumeLab.left, _volumeLab.bottom + 16.0, _volumeLab.width, _volumeLab.height);
        self.audioVolumeMinLab.frame = CGRectMake(_volumeMinLab.left, _audioVolumeLab.top, _volumeMinLab.width, _volumeMinLab.height);
        self.audioVolumeMaxLab.frame = CGRectMake(_volumeMaxLab.left, _audioVolumeLab.top, _volumeMaxLab.width, _volumeMaxLab.height);
        self.audioVolumeSlider.frame = CGRectMake(_voluemSlider.left, _audioVolumeLab.top, _voluemSlider.width, _voluemSlider.height);
    }
}

- (void)setAudioPaths:(NSArray *)audioPaths
{
    _audioPaths = audioPaths;
    
    [self.audioInfos removeAllObjects];
    
    for (NSString *path in audioPaths) {
        NSString *name = [[path lastPathComponent] stringByDeletingPathExtension];
        NSDictionary *dic = @{@"name":name};
        [self.audioInfos addObject:dic];
    }
    
    [self.menuList reloadData];
}

#pragma mark - Aciton
- (void)sliderAction:(UISlider *)slider
{
    if (slider == _voluemSlider) {
        _volumeMinLab.text = [NSString stringWithFormat:@"%.1f", slider.value];
        if (_volumeBlock) {
            _volumeBlock(slider.value);
        }
    }
    else if (slider == _audioVolumeSlider) {
        _audioVolumeMinLab.text = [NSString stringWithFormat:@"%.1f", slider.value];
        if (_audioVolumeBlock) {
            _audioVolumeBlock(slider.value);
        }
    }
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.audioInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NTESMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
     
    NSDictionary *dic = self.audioInfos[indexPath.row];
    if (dic) {
        NSString *name = dic[@"name"];
        NSString *icon = dic[@"icon"];
        [cell refreshCell:name icon:icon selectIcon:nil];
    }
    
    cell.selected = (indexPath.row == self.selectedIndex);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    
    if (self.selectBlock) {
        self.selectBlock(self.selectedIndex);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.width - 4 * 10)/3;
    CGFloat height = width;
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}


#pragma mark - Getter/Setter
- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 10.0f;
        _layout.minimumInteritemSpacing = 0.1f;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UICollectionView *)menuList
{
    if (!_menuList)
    {
        _menuList = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _menuList.backgroundColor = [UIColor clearColor];
        _menuList.showsVerticalScrollIndicator = NO;
        _menuList.showsHorizontalScrollIndicator = NO;
        _menuList.dataSource = self;
        _menuList.delegate   = self;
        _menuList.bounces = NO;
        _menuList.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [_menuList registerClass:[NTESMenuCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _menuList;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor lightGrayColor];
        _titleLab.font = [UIFont systemFontOfSize:15.0];
        _titleLab.text = @"添加音乐";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [_titleLab sizeToFit];
    }
    return _titleLab;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (void)doSetSelectedIndex
{
    [_menuList reloadData];
}

- (CGFloat)barHeight
{
    return 280.0;
}

- (UILabel *)volumeLab
{
    if (!_volumeLab) {
        _volumeLab = [self minLab];
        _volumeLab.text = @"主音量";
    }
    return _volumeLab;
}

- (UILabel *)volumeMinLab
{
    if (!_volumeMinLab) {
        _volumeMinLab = [self minLab];
    }
    return _volumeMinLab;
}

- (UILabel *)volumeMaxLab
{
    if (!_volumeMaxLab) {
        _volumeMaxLab = [self maxLab];
    }
    return _volumeMaxLab;
}

- (UISlider *)voluemSlider
{
    if (!_voluemSlider) {
        _voluemSlider = [self sliderWithMin:0 max:1];
        
        _voluemSlider.value = 1.0;
        self.volumeMinLab.text = @"0.0";
        self.volumeMaxLab.text = @"1.0";
    }
    return _voluemSlider;
}

- (UILabel *)audioVolumeLab {
    if (!_audioVolumeLab) {
        _audioVolumeLab = [self minLab];
        _audioVolumeLab.text = @"伴音量";
    }
    return _audioVolumeLab;
}

- (UILabel *)audioVolumeMinLab {
    if (!_audioVolumeMinLab) {
        _audioVolumeMinLab = [self minLab];
    }
    return _audioVolumeMinLab;
}

- (UILabel *)audioVolumeMaxLab {
    if (!_audioVolumeMaxLab) {
        _audioVolumeMaxLab = [self maxLab];
    }
    return _audioVolumeMaxLab;
}

- (UISlider *)audioVolumeSlider {
    if (!_audioVolumeSlider) {
        _audioVolumeSlider = [self sliderWithMin:0 max:1];
        _audioVolumeSlider.value = 1.0;
        self.audioVolumeMinLab .text = @"0.0";
        self.audioVolumeMaxLab.text = @"1.0";
    }
    return _audioVolumeSlider;
}

- (UILabel *)maxLab
{
    UILabel *maxLab = [[UILabel alloc] init];
    maxLab.textAlignment = NSTextAlignmentRight;
    maxLab.textColor = [UIColor whiteColor];
    maxLab.font = [UIFont systemFontOfSize:12.0];
    return maxLab;
}

- (UILabel *)minLab
{
    UILabel *minLab = [[UILabel alloc] init];
    minLab.textAlignment = NSTextAlignmentLeft;
    minLab.textColor = [UIColor whiteColor];
    minLab.font = [UIFont systemFontOfSize:12.0];
    return minLab;
}

- (UISlider *)sliderWithMin:(CGFloat)min max:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = min;
    slider.maximumValue = max;
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    return slider;
}

@end
