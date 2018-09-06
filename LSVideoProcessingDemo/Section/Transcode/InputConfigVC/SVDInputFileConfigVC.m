//
//  SVDInputFileConfigVC.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDInputFileConfigVC.h"
#import "SVDInputConfigView.h"
#import "SVDBundleScanVC.h"
#import "SVDSandboxScanVC.h"
#import "SVDAlbumScanVC.h"
#import "SVDSystemPlayer.h"

#define DEFAULT_CELL_HEIGHT 98

@interface SVDInputFileConfigVC ()<UITableViewDelegate, UITableViewDataSource, InputConfigProtocol, BundleScanProtocol, SandBoxScanProtocol, SVDAlbumScanVCProtocol>
{
    NSInteger _selectIndex;
}
@property (nonatomic, strong) UITableView *inputConfigList;
@property (nonatomic, strong) NSMutableArray <SVDInputFileModel *>*models;
@property (nonatomic, strong) SVDInputFileModel *secModel;
@property (nonatomic, strong) SVDAlbumScanVC *album;
@end

@implementation SVDInputFileConfigVC

- (void)dealloc {
    NSLog(@"[转码测试Demo] SVDInputFileConfigVC 释放!");
}

- (instancetype)init
{
    if (self = [super init]) {
        _models = [NSMutableArray arrayWithObject:[[SVDInputFileModel alloc] init]];
        _secModel = [[SVDInputFileModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.inputConfigList];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _inputConfigList.frame = CGRectMake(0, 0, self.view.width, self.view.height);
}

- (void)setFileCanPlay:(BOOL)canPlay index:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    SVDInputConfigView *cell = [_inputConfigList cellForRowAtIndexPath:indexPath];
    if (cell) {
        cell.canPlay = canPlay;
        SVDInputFileModel *model = ((index == _models.count) ? _secModel : [_models objectAtIndex:index]);
        model.isCanPlay = canPlay;
    }
}

- (void)setFileInfo:(NSString *)info index:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    SVDInputConfigView *cell = [_inputConfigList cellForRowAtIndexPath:indexPath];
    if (cell)
    {
        cell.infoText = info;
        SVDInputFileModel *model = ((index == _models.count) ? _secModel : [_models objectAtIndex:index]);
        model.videoCellHeight = [cell cellHeight];
        model.audioCellHeight = [cell cellHeight];
        model.fileInfo = info;
        [_inputConfigList reloadData];
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _models.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != _models.count)
    {
        SVDInputConfigView *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
        SVDInputFileModel *model = ((indexPath.section == _models.count) ? _secModel : _models[indexPath.section]);
        cell.model = model;
        cell.delegate = self;
        return cell;
    }
    else
    {
        SVDInputConfigView *cell = [tableView dequeueReusableCellWithIdentifier:@"secCell" forIndexPath:indexPath];
        cell.infoText = _secModel.fileInfo;
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVDInputFileModel *model = ((indexPath.section == _models.count) ? _secModel : _models[indexPath.section]);
    return ((indexPath.section == _models.count) ? model.audioCellHeight : model.videoCellHeight);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - <InputConfigProtocol>
//点击了 Bundle
- (void)InputConfigBundleAction:(SVDInputConfigView *)configView {
    NSInteger index = [_inputConfigList indexPathForCell:configView].section;
    _selectIndex = index;
    SVDBundleScanVC *scanVC = [[SVDBundleScanVC alloc] init];
    scanVC.delegate = self;
    [self.navigationController pushViewController:scanVC animated:YES];
}

//点击了 沙盒
- (void)InputConfigLocalAction:(SVDInputConfigView *)configView {
    NSInteger index = [_inputConfigList indexPathForCell:configView].section;
    _selectIndex = index;
    SVDSandboxScanVC *scanVC = [[SVDSandboxScanVC alloc] init];
    scanVC.delegate = self;
    [self.navigationController pushViewController:scanVC animated:YES];
}

//点击了 相册
- (void)InputConfigAlbumAction:(SVDInputConfigView *)configView {
    NSInteger index = [_inputConfigList indexPathForCell:configView].section;
    _selectIndex = index;
    __weak typeof(self) weakSelf = self;
    [SVDAlbumScanVC requestImagePickerAuthorization:^(NEAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == NEAuthorizationStatusAuthorized) {
                [weakSelf presentViewController:weakSelf.album.picker animated:YES completion:nil];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请开启相册权限!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        });
    }];
}

//点击了 播放
- (void)InputConfigPlayAction:(SVDInputConfigView *)configView {
    NSIndexPath *indexPath = [_inputConfigList indexPathForCell:configView];
    SVDInputFileModel *model = ((indexPath.section == _models.count) ? _secModel : _models[indexPath.section]);
    [SVDSystemPlayer playWithFilePath:model.filePath];
}

//点击了 +
- (void)InputConfigAddAction:(SVDInputConfigView *)configView {
    NSInteger index = [_inputConfigList indexPathForCell:configView].section;
    [_models insertObject:[[SVDInputFileModel alloc] init] atIndex:(index + 1)];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:(index + 1)];
    [_inputConfigList insertSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:(index + 1)];
    [_inputConfigList scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

//点击了 -
- (void)InputConfigDelAction:(SVDInputConfigView *)configView {
    if (_models.count > 1) {
        NSInteger index = [_inputConfigList indexPathForCell:configView].section;
        [_models removeObjectAtIndex:index];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
        [_inputConfigList deleteSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    }
}

//设置加速
- (void)InputConfigSetSpeed:(SVDInputConfigView *)configView speed:(CGFloat)speed
{
    NSInteger index = [_inputConfigList indexPathForCell:configView].section;
    SVDInputFileModel *model = ((index == _models.count) ? _secModel : _models[index]);
    model.speed = speed;
}

//设置加速开始
- (void)InputConfigSetSpeedBegin:(SVDInputConfigView *)configView begin:(CGFloat)begin
{
    NSInteger index = [_inputConfigList indexPathForCell:configView].section;
    SVDInputFileModel *model = ((index == _models.count) ? _secModel : _models[index]);
    model.speedBegin = begin;
}

//设置加速持续
- (void)InputConfigSetSpeedDuration:(SVDInputConfigView *)configView duration:(CGFloat)duration
{
    NSInteger index = [_inputConfigList indexPathForCell:configView].section;
    SVDInputFileModel *model = ((index == _models.count) ? _secModel : _models[index]);
    model.speedDuration = duration;
}

#pragma mark - <BundleScanProtocol>
- (void)BundleScanSelectedComplete:(NSString *)path {
    SVDInputFileModel *model = ((_selectIndex == _models.count) ? _secModel : _models[_selectIndex]);
    model.filePath = path;
    [self setFileCanPlay:[NTESSandboxHelper fileIsExist:path] index:_selectIndex];
    if (_delegate && [_delegate respondsToSelector:@selector(InputConfigSelectedFile:fileModel:index:)]) {
        [_delegate InputConfigSelectedFile:self
                                 fileModel:model
                                     index:_selectIndex];
    }
}

#pragma mark - <SandBoxScanProtocol>
- (void)SandboxScanSelectedComplete:(NSString *)path {
    SVDInputFileModel *model = ((_selectIndex == _models.count) ? _secModel : _models[_selectIndex]);
    model.filePath = path;
    [self setFileCanPlay:[NTESSandboxHelper fileIsExist:path] index:_selectIndex];
    if (_delegate && [_delegate respondsToSelector:@selector(InputConfigSelectedFile:fileModel:index:)]) {
        [_delegate InputConfigSelectedFile:self
                                      fileModel:model
                                     index:_selectIndex];
    }
}

#pragma mark - <SVDAlbumScanVC>
- (void)AlbumScanSelectedComplete:(NSString *)path {
    SVDInputFileModel *model = ((_selectIndex == _models.count) ? _secModel : _models[_selectIndex]);
    model.filePath = path;
    [self setFileCanPlay:[NTESSandboxHelper fileIsExist:path] index:_selectIndex];
    if (_delegate && [_delegate respondsToSelector:@selector(InputConfigSelectedFile:fileModel:index:)]) {
        [_delegate InputConfigSelectedFile:self
                                 fileModel:model
                                     index:_selectIndex];
    }
}

#pragma mark - Getter
- (UITableView *)inputConfigList {
    if (!_inputConfigList) {
        _inputConfigList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStyleGrouped];
        _inputConfigList.delegate = self;
        _inputConfigList.dataSource = self;
        _inputConfigList.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_inputConfigList registerClass:[SVDInputConfigView class] forCellReuseIdentifier:@"mainCell"];
        [_inputConfigList registerClass:[SVDInputConfigView class] forCellReuseIdentifier:@"secCell"];
    }
    return _inputConfigList;
}

- (NSArray *)mainFileModels {
    return _models;
}

- (NSString *)secFilePath {
    return _secModel.filePath;
}

- (SVDAlbumScanVC *)album {
    if (!_album) {
        _album = [[SVDAlbumScanVC alloc] init];
        _album.delegate = self;
    }
    return _album;
}

@end
