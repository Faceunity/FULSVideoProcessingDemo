//
//  NTESRecordDataCenter.h
//  ShortVideoProcess_Demo
//
//  Created by Netease on 17/3/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NTESRecordConfigEntity;

@interface NTESRecordDataCenter : NSObject

+ (instancetype)shareInstance;

+ (void)clear;

@property (nonatomic, strong) NTESRecordConfigEntity *config;  //配置参数（段数、时长等）
@property (nonatomic, strong) LSMediaRecordingParaCtx *pRecordPara; //录制参数
@property (nonatomic, strong) NSMutableArray <NSString *>*recordFilePaths; //录制文件路径

@end

@interface NTESRecordConfigEntity : NSObject

@property (nonatomic, assign) CGFloat exposureValue; //曝光强度
@property (nonatomic, assign) CGFloat beautyValue;   //美颜强度
@property (nonatomic, assign) BOOL beauty; //是否开启美颜

@property (nonatomic, strong) NSArray *filterDatas;     //滤镜显示的字符串
@property (nonatomic, assign) NSInteger curFilterIndex; //当前选择的滤镜index

@property (nonatomic, strong) NSArray *sectionDatas;      //段落显示的字符串
@property (nonatomic, assign) NSInteger curSectionsIndex; //当前选择的段落indx

@property (nonatomic, strong) NSArray *durationDatas;     //时长显示的字符串
@property (nonatomic, assign) NSInteger curDurationIndex; //当前选择的时长index

@property (nonatomic, strong) NSArray *scaleModeDatas;     //比例显示的字符串
@property (nonatomic, assign) NSInteger curScaleModeIndex; //当前选择的比例index

@property (nonatomic, strong) NSArray *resolutionDatas;    //分辨率显示的字符串
@property (nonatomic, assign) NSInteger curResolutionIndex;//分辨率选择的比例字符串

@end
