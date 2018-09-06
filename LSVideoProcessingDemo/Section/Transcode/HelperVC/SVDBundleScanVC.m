//
//  SVDBundleScanVC.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDBundleScanVC.h"

@interface SVDBundleScanVC () <UITableViewDelegate, UITableViewDataSource>
{
    dispatch_queue_t _scan_queue;
}
@property (nonatomic, strong) UITableView *bundleList;
@property (nonatomic, strong) NSMutableArray *bundlePaths;

@end

@implementation SVDBundleScanVC

- (instancetype)init
{
    if (self = [super init])
    {
        //开始扫描，页面更新
        _scan_queue = dispatch_queue_create("neplayer_demo_loc_scan_queue", NULL);
        _fileFormats = @[@"mp4", @"mov", @"MOV", @"idx", @"flv", @"mp3"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Bundle文件";
    [self.view addSubview:self.bundleList];
    dispatch_async(_scan_queue, ^{
        [self doScanBundle];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_bundleList reloadData];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _bundleList.frame = self.view.bounds;
}

#pragma mark - 文件扫描
- (void)doScanBundle
{
    if (!_bundlePaths) {
        _bundlePaths = [NSMutableArray array];
    }
    else
    {
        [_bundlePaths removeAllObjects];
    }
    
    for (NSString *format in _fileFormats) {
        NSArray *path = [[NSBundle mainBundle] pathsForResourcesOfType:format inDirectory:@""];
        if (path && path.count != 0) {
            [_bundlePaths addObjectsFromArray:path];
        }
    }
}

#pragma mark - Getter
- (UITableView *)bundleList
{
    if (!_bundleList)
    {
        _bundleList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
        _bundleList.showsHorizontalScrollIndicator = NO;
        _bundleList.showsVerticalScrollIndicator = YES;
        _bundleList.bounces = YES;
        _bundleList.delegate = self;
        _bundleList.dataSource = self;
    }
    return _bundleList;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bundlePaths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    }
    cell.textLabel.text = [_bundlePaths[indexPath.row] lastPathComponent];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(BundleScanSelectedComplete:)]) {
        [_delegate BundleScanSelectedComplete:_bundlePaths[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

@end
