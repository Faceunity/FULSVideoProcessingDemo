//
//  NTESGlobalMacro.h
//  NIMDemo
//
//  Created by chris on 15/2/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#ifndef NIMDemo_GlobalMacro_h
#define NIMDemo_GlobalMacro_h

#define NTES_TEST_APP_KEY @"55f3fcee14db4682a11e1c633739d314"

#define NTES_ERROR_MSG_KEY @"description"

#define ChatCellDefaultChatInterval 10.0
#define DefaultToolButtonWidth 40.0

#define IOS8            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define UIScreenWidth                              [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight                             [UIScreen mainScreen].bounds.size.height
#define UISreenWidthScale   UIScreenWidth / 375 //以iphone6 尺寸为标准
#define UISreenHeightScale  UIScreenHeight / 667 

#define UICommonTableBkgColor UIColorFromRGB(0xe4e7ec)
#define UICommonBtnBkgColor UIColorFromRGB(0x238ef1)
#define Chatroom_Message_Font [UIFont boldSystemFontOfSize:14] // 聊天室聊天文字字体


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#pragma mark - UIColor宏定义
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

/******* 效验对象是否是空 *******/
#define HDStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
#define HDArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
#define HDDictionaryIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
#define HDObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
/******* 效验对象是否是空 *******/

#endif
