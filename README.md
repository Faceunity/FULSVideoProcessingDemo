# FULSVideoProcessingDemo 快速接入文档

FULSVideoProcessingDemo 是集成了 Faceunity 面部跟踪和虚拟道具功能 和 [云信短视频](http://netease.im/svod)  的 Demo。

本文是 FaceUnity SDK 快速对云信短视频的导读说明，关于 `FaceUnity SDK` 的详细说明，请参看 [FULiveDemo](https://github.com/Faceunity/FULiveDemo/tree/dev)


## 快速集成方法

### 一、导入 SDK

将  FaceUnity  文件夹全部拖入工程中，NamaSDK所需依赖库为 `OpenGLES.framework`、`Accelerate.framework`、`CoreMedia.framework`、`AVFoundation.framework`、`libc++.tbd`、`CoreML.framework`

- 备注: 上述NamaSDK 依赖库使用 Pods 管理 会自动添加依赖,运行在iOS11以下系统时,需要手动添加`CoreML.framework`,并在**TARGETS -> Build Phases-> Link Binary With Libraries**将`CoreML.framework`手动修改为可选**Optional**

### FaceUnity 模块简介
```C
-FUManager              //nama 业务类
-FUCamera               //视频采集类(示例程序未用到)
-authpack.h             //权限文件
+FUAPIDemoBar     //美颜工具条,可自定义
+items       //贴纸和美妆资源 xx.bundel文件
      
```

### 二、加入展示 FaceUnity SDK 美颜贴纸效果的UI

1、在 `NTESRecordVC.m` 和 `SVDTranscodePreviewVC.m` 中添加头文件，并创建页面属性

```C
/*  faceU */
#import "FUAPIDemoBar.h"
#import "FUManager.h"

@property (nonatomic, strong) FUAPIDemoBar *demoBar;

/** 选中的滤镜 */
@property (nonatomic, strong) FUBeautyParam *seletedFliter;

```

2、初始化 UI，并遵循代理  FUAPIDemoBarDelegate ，实现代理方法 `bottomDidChange:` 切换贴纸 和 `filterValueChange:` 更新美颜参数。

```C
// demobar 初始化
-(FUAPIDemoBar *)demoBar {
    if (!_demoBar) {
        
        _demoBar = [[FUAPIDemoBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 164 - 194, self.view.frame.size.width, 194)];
        
        _demoBar.mDelegate = self;
    }
    return _demoBar ;
}

```

#### 切换贴纸

```C
// 切换贴纸
-(void)bottomDidChange:(int)index{
    if (index < 3) {
        [[FUManager shareManager] setRenderType:FUDataTypeBeautify];
    }
    if (index == 3) {
        [[FUManager shareManager] setRenderType:FUDataTypeStrick];
    }
    
    if (index == 4) {
        [[FUManager shareManager] setRenderType:FUDataTypeMakeup];
    }
    if (index == 5) {
        [[FUManager shareManager] setRenderType:FUDataTypebody];
    }
}

```

#### 更新美颜参数

```C
// 更新美颜参数    
- (void)filterValueChange:(FUBeautyParam *)param{
    [[FUManager shareManager] filterValueChange:param];
}
```

### 三、在 `viewDidLoad:` 中初始化 SDK  并将  demoBar 添加到页面上

```C
/* faceU */
[[FUManager shareManager] loadFilter];
[FUManager shareManager].flipx = YES;
[FUManager shareManager].trackFlipx = YES;
[FUManager shareManager].isRender = YES;
[[FUManager shareManager] setAsyncTrackFaceEnable:NO];
[self.view addSubview:self.demoBar];
self.seletedFliter = [FUManager shareManager].seletedFliter;

```

### 四、图像处理

#### 4.1、在录制视频的时候添加 FaceUnity 效果

在  `NTESRecordVC.m` 的 `viewDidLoad:`方法中添加一下代码

```C
    __weak typeof(self) weakSelf = self;
    _externalVideoFrameCallback = ^(CMSampleBufferRef pixelBuf) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        CVPixelBufferRef buffer = CMSampleBufferGetImageBuffer(pixelBuf) ;
        [[FUManager shareManager] renderItemsToPixelBuffer:buffer];
        [strongSelf.mediaCapture externalInputVideoFrame:pixelBuf];
        
    };
    
    _mediaCapture.externalVideoFrameCallback = _externalVideoFrameCallback;
```

#### 4.2、在编辑视频的时候添加 FaceUnity 效果

在 `SVDTranscodePreviewVC.m` 中添加以下代码

```C
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak typeof(self)weakSelf = self ;
    _mediaTransc.externalVideoFrameCallback = ^(CMSampleBufferRef sampleBuffer) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        [[FUManager shareManager] renderItemsToPixelBuffer:pixelBuffer];
        [strongSelf.mediaTransc externalInputVideoFrame:sampleBuffer];
    };
}

```


### 五、道具销毁

视频录制结束时需要销毁道具

```c
[[FUManager shareManager] destoryItems]
```

**快速集成完毕，关于 FaceUnity SDK 的更多详细说明，请参看 [FULiveDemo](https://github.com/Faceunity/FULiveDemo/tree/dev)**