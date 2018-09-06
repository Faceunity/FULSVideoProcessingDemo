//
//  SVPictureProcessVC.m
//  LSVideoProcessingDemo
//
//  Created by Netease on 2018/4/27.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "SVPictureProcessVC.h"
#import "NTESAuthorizationHelper.h"
#import "GPUImageGrayscaleFilter.h"
#import "GPUImageHueFilter.h"

@interface SVPictureProcessVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *oriPic;
@property (weak, nonatomic) IBOutlet UIImageView *dstPic;
@property (weak, nonatomic) IBOutlet UILabel *oriInfo;
@property (weak, nonatomic) IBOutlet UILabel *dstInfo;
@property (nonatomic, strong) UIButton *masicCompleteBtn;
@property (nonatomic, strong) LSMediaPicprocess *mediaPicProcess;
@property (nonatomic, assign) CGRect rect;

@property (nonatomic, assign) LSPicGPUImageFilterType filterType;
@property (nonatomic, strong) GPUImageFilter *customFilter;
@property (nonatomic, strong) GPUImageGrayscaleFilter *filter1;
@property (nonatomic, strong) GPUImageHueFilter *filter2;

@end

@implementation SVPictureProcessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mediaPicProcess = [[LSMediaPicprocess alloc] init];
    
    _mediaPicProcess.masicPreview.hidden = YES;
    [self.view addSubview:_mediaPicProcess.masicPreview];
    _masicCompleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_masicCompleteBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_masicCompleteBtn addTarget:self action:@selector(masicComplete:) forControlEvents:UIControlEventTouchUpInside];
    _masicCompleteBtn.hidden = YES;
    [self.view addSubview:_masicCompleteBtn];
    
    _filter1 = [[GPUImageGrayscaleFilter alloc] init];
    _filter2 = [[GPUImageHueFilter alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _mediaPicProcess.masicPreview.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 80);
    _masicCompleteBtn.frame = CGRectMake(0,
                                         _mediaPicProcess.masicPreview.frame.origin.y + _mediaPicProcess.masicPreview.frame.size.height,
                                         self.view.bounds.size.width,
                                         60);
}

#pragma mark - Process Action

- (IBAction)exitAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doCropAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [_mediaPicProcess cropWithRect:_rect complete:^(UIImage *oriImage, UIImage *dstImage, NSError *error) {
        if (oriImage) {
            weakSelf.oriPic.image = oriImage;
            weakSelf.oriInfo.text = [NSString stringWithFormat:@"oriInfo : [%d x %d]", (int)oriImage.size.width, (int)oriImage.size.height];
        }
        if (dstImage) {
            weakSelf.dstPic.image = dstImage;
            weakSelf.dstInfo.text = [NSString stringWithFormat:@"dstInfo : [%d x %d]", (int)dstImage.size.width, (int)dstImage.size.height];
        }
    }];
}

- (IBAction)doAddImage:(UIButton *)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    __weak typeof(self) weakSelf = self;
    [_mediaPicProcess addSticker:image rect:_rect complete:^(UIImage *oriImage, UIImage *dstImage, NSError *error) {
        if (oriImage) {
            weakSelf.oriPic.image = oriImage;
        }
        if (dstImage) {
            weakSelf.dstPic.image = dstImage;
        }
    }];
}

- (IBAction)doAddMasic:(UIButton *)sender {
    _mediaPicProcess.masicPreview.hidden = NO;
    _masicCompleteBtn.hidden = NO;
}

- (void)masicComplete:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    _mediaPicProcess.masicPreview.hidden = YES;
    _masicCompleteBtn.hidden = YES;
    [_mediaPicProcess addmosaicComplete:^(UIImage *oriImage, UIImage *dstImage, NSError *error) {
        if (oriImage) {
            weakSelf.oriPic.image = oriImage;
            weakSelf.oriInfo.text = [NSString stringWithFormat:@"oriInfo : [%d x %d]", (int)oriImage.size.width, (int)oriImage.size.height];
        }
        if (dstImage) {
            weakSelf.dstPic.image = dstImage;
            weakSelf.dstInfo.text = [NSString stringWithFormat:@"dstInfo : [%d x %d]", (int)dstImage.size.width, (int)dstImage.size.height];
        }
    }];
}
- (void)doAddFilter:(LSPicGPUImageFilterType)type customfilter:(GPUImageFilter *)customfilter {
    __weak typeof(self) weakSelf = self;
    [_mediaPicProcess addFilterWithType:type filter:customfilter complete:^(UIImage *oriImage, UIImage *dstImage, NSError *error) {
        if (oriImage) {
            weakSelf.oriPic.image = oriImage;
            weakSelf.oriInfo.text = [NSString stringWithFormat:@"oriInfo : [%d x %d]", (int)oriImage.size.width, (int)oriImage.size.height];
        }
        if (dstImage) {
            weakSelf.dstPic.image = dstImage;
            weakSelf.dstInfo.text = [NSString stringWithFormat:@"dstInfo : [%d x %d]", (int)dstImage.size.width, (int)dstImage.size.height];
        }
    }];
}

#pragma mark - Config Action
- (IBAction)cropX:(UITextField *)sender {
    _rect.origin.x = [sender.text floatValue];
}
- (IBAction)cropY:(UITextField *)sender {
    _rect.origin.y = [sender.text floatValue];
}
- (IBAction)cropW:(UITextField *)sender {
    _rect.size.width = [sender.text floatValue];
}
- (IBAction)cropH:(UITextField *)sender {
    _rect.size.height = [sender.text floatValue];
}
- (IBAction)masicLineWidth:(UITextField *)sender {
    _mediaPicProcess.masicLineWidth = [sender.text floatValue];
}
- (IBAction)filterTypeAction:(UISegmentedControl *)sender {
    _filterType = sender.selectedSegmentIndex;
    [self doAddFilter:_filterType customfilter:_customFilter];
}
- (IBAction)customFilterTypeAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _customFilter = nil;
    } else if (sender.selectedSegmentIndex == 1) {
        _customFilter = _filter1;
    } else if (sender.selectedSegmentIndex == 2) {
        _customFilter = _filter2;
    }
    [self doAddFilter:_filterType customfilter:_customFilter];
}

#pragma mark - System Action
- (void)showImageFromIpc
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (IBAction)ShowAlbumAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [NTESAuthorizationHelper requestAblumAuthorityWithCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"请开启相册权限");
        } else {
            [weakSelf showImageFromIpc];
        }
    }];
}

#pragma mark - <>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [picker dismissViewControllerAnimated:YES completion:nil];
            _oriPic.image = image;
            _oriInfo.text = [NSString stringWithFormat:@"oriInfo : [%d x %d]", (int)image.size.width, (int)image.size.height];
            _mediaPicProcess.image = image;
        });
    }
}

@end
