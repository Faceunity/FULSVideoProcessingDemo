//
//  SVDSandboxScanVC.m
//  NELivePlayerDemo
//
//  Created by Netease on 2017/9/5.
//  Copyright © 2017年 netease. All rights reserved.
//  本地沙盒和Bundle扫描视图。

#import "SVDSandboxScanVC.h"
#import "NTESSandboxHelper.h"

@interface SVDSandboxScanVC () <UITableViewDelegate, UITableViewDataSource>
{
    dispatch_queue_t _scan_queue;
}
@property (nonatomic, strong) UITableView *sandboxList;
@property (nonatomic, strong) NSMutableArray *sandboxPaths;
@end

@implementation SVDSandboxScanVC

- (instancetype)init
{
    if (self = [super init])
    {
        _scan_queue = dispatch_queue_create("neplayer_demo_loc_scan_queue", NULL);
        _fileFormats = @[@"mp4", @"mov", @"MOV", @"idx", @"flv", @"mp3"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"沙盒文件";
    [self.view addSubview:self.sandboxList];
    dispatch_async(_scan_queue, ^{
        [self doSacnSandbox];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_sandboxList reloadData];
        });
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _sandboxList.frame = self.view.bounds;
}

#pragma mark - 文件扫描
- (void)doSacnSandbox
{
    if (!_sandboxPaths) {
        _sandboxPaths = [NSMutableArray array];
    }
    else
    {
        [_sandboxPaths removeAllObjects];
    }
    
    NSArray *subPath = [NTESSandboxHelper queryPath:NSHomeDirectory()];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    for (NSString *path in subPath) {
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
            if (isDir) {
                continue;
            }
            
            for (NSString *format in _fileFormats)
            {
                if ([path.lastPathComponent hasSuffix:format])
                {
                    NSMutableArray *tmp = dic[format];
                    if (!tmp) {
                        tmp = [NSMutableArray array];
                    }
                    [tmp addObject:path];
                    dic[format] = tmp;
                    break;
                }
            }
        }
    }
    
    for (NSString *format in _fileFormats) {
        NSMutableArray *tmp = dic[format];
        if (tmp && tmp.count != 0) {
            [_sandboxPaths addObjectsFromArray:tmp];
        }
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sandboxPaths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    cell.textLabel.text = [_sandboxPaths[indexPath.row] lastPathComponent];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(SandboxScanSelectedComplete:)]) {
        [_delegate SandboxScanSelectedComplete:_sandboxPaths[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && tableView == _sandboxList)
    {
        [[NSFileManager defaultManager] removeItemAtPath:_sandboxPaths[indexPath.row] error:nil];
        [_sandboxPaths removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

#pragma mark - Getter / Setter
- (UITableView *)sandboxList
{
    if (!_sandboxList)
    {
        _sandboxList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStylePlain];
        _sandboxList.showsHorizontalScrollIndicator = NO;
        _sandboxList.showsVerticalScrollIndicator = YES;
        _sandboxList.delegate = self;
        _sandboxList.dataSource = self;
        _sandboxList.bounces = YES;
    }
    return _sandboxList;
}
@end
