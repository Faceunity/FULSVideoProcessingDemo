//
//  SVDContainerVC.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 2017/9/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "SVDContainerVC.h"
#import "SVDInputFileConfigVC.h"
#import "SVDOutputFileConfigVC.h"
#import "SVDTranscodeVC.h"

@interface SVDContainerVC ()<UIScrollViewDelegate, InputConfigVCProtocol, SVDTranscodeVCProtocol>
{
    dispatch_queue_t _getFileInfoQueue;
}
@property (nonatomic, strong) UIScrollView *vcList;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger selectFileInfoIndex;
@end

@implementation SVDContainerVC

- (void)dealloc {
    NSLog(@"[转码测试Demo] SVDContainerVC 释放!");
}

- (instancetype)init {
    if (self = [super init]) {
        _titles = @[@"输入设置", @"输出设置", @"执行转码"];
        _getFileInfoQueue = dispatch_queue_create("svdemo_getfileinfo_queue", NULL);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupSubControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self doLayoutSubviews];
}

#pragma mark - <InputConfigVCProtocol>
- (void)InputConfigSelectedFile:(SVDInputFileConfigVC *)configVC
                      fileModel:(SVDInputFileModel *)model
                          index:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_getFileInfoQueue, ^{
        SVDTranscodeVC *transVC = [weakSelf.childViewControllers lastObject];
        weakSelf.selectFileInfoIndex = index;
        [transVC transcodeGetFileInfo:model.filePath Complete:^(NSString *fileInfo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"文件路径:\n%@\n\n", model.filePath];
                NSString *info = [str stringByAppendingString:[NSString stringWithFormat:@"文件信息:\n%@", fileInfo]];
                SVDInputFileConfigVC *inputVC  = [weakSelf.childViewControllers firstObject];
                [inputVC setFileInfo:info index:weakSelf.selectFileInfoIndex];
            });
        }];
    });
}

#pragma mark -  <SVDTranscodeVCProtocol>
- (NSArray *)TranscodeGetMainInputFiles {
    SVDInputFileConfigVC *inputVC = [self.childViewControllers firstObject];
    return inputVC.mainFileModels;
}

- (NSString *)TranscodeGetSecInputFile {
    SVDInputFileConfigVC *inputVC = [self.childViewControllers firstObject];
    return inputVC.secFilePath;
}

- (SVDOutputFileConfigModel *)TranscodeGetOutputConfig {
    SVDOutputFileConfigVC *outputVC  =[self.childViewControllers objectAtIndex:1];
    return outputVC.configData;
}

#pragma mark - Actions
- (void)btnAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 10;
    self.selectIndex = index;
    [_vcList setContentOffset:CGPointMake(index * _vcList.width, 0) animated:YES];
}

#pragma mark - Setup subviews
- (void)doLayoutSubviews
{
    __weak typeof(self) weakSelf = self;
    [_titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger btnTag = idx + 10;
        NSInteger intervalTag = idx + 20;
        
        UIButton *btn = [weakSelf.view viewWithTag:btnTag];
        CGFloat width = weakSelf.view.width/weakSelf.titles.count;
        btn.frame = CGRectMake(idx * width, 64, width, 42);
        UIView *interval = [weakSelf.view viewWithTag:intervalTag];
        interval.frame = CGRectMake(btn.left, btn.bottom, btn.width, 2.0);
    }];
    
    _vcList.frame = CGRectMake(0, 108, self.view.width, self.view.height - 104);
    _vcList.contentSize = CGSizeMake(_vcList.width * _titles.count, _vcList.height);
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.view.frame = CGRectMake(weakSelf.vcList.width * idx, 0, weakSelf.vcList.width, weakSelf.vcList.height);
    }];
}

- (void)setupSubviews
{
    self.title = @"转码测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
    [_titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [weakSelf setupTitleBtnWithTitle:obj tag:idx + 10];
        UIView *interval = [weakSelf setupIntervalViewWithTag:idx + 20];
        [weakSelf.view addSubview:btn];
        [weakSelf.view addSubview:interval];
        if (idx == 0) {
            btn.selected = YES;
            interval.hidden = NO;
        }
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:bottomLine];
    
    _vcList = [[UIScrollView alloc] init];
    _vcList.pagingEnabled = YES;
    _vcList.delegate = self;
    [self.view addSubview:_vcList];
}

- (void)setupSubControllers
{
    SVDInputFileConfigVC *inputVC = [[SVDInputFileConfigVC alloc] init];
    inputVC.delegate = self;
    [self addChildViewController:inputVC];
    [self.vcList addSubview:inputVC.view];
    
    SVDOutputFileConfigVC *outputVC = [[SVDOutputFileConfigVC alloc] init];
    [self addChildViewController:outputVC];
    [self.vcList addSubview:outputVC.view];
    
    SVDTranscodeVC *transcodeVC = [[SVDTranscodeVC alloc] init];
    [self addChildViewController:transcodeVC];
    transcodeVC.delegate = self;
    [self.vcList addSubview:transcodeVC.view];
}

- (UIButton *)setupTitleBtnWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIView *)setupIntervalViewWithTag:(NSInteger)tag
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    view.hidden = YES;
    view.tag = tag;
    return view;
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    UIButton *lastBtn = [self.view viewWithTag:(10 + _selectIndex)];
    lastBtn.selected = NO;
    UIView *lastInterval = [self.view viewWithTag:(20 + _selectIndex)];
    lastInterval.hidden = YES;
    UIButton *btn = [self.view viewWithTag:10 + selectIndex];
    btn.selected = YES;
    UIView *Interval = [self.view viewWithTag:(20 + selectIndex)];
    Interval.hidden = NO;
    _selectIndex = selectIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.selectIndex = scrollView.contentOffset.x / scrollView.width;
}

@end
