//
//  Macro.h
//  HPShareApp
//
//  Created by HP on 2018/11/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define JPushAppKey @"e9ab740a789860714d7a511a"
/**
 全局宏定义。
 */
#define IPHONE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define IPHONE_HAS_NOTCH [[UIScreen mainScreen] bounds].size.height >= 812
//获取屏幕宽度与高度
#define kScreenWidth \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)
#define kScreenHeight \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)
#define getWidth(x)       x*g_rateWidth
#define getHeight(y)     y*g_rateHeight
/**
 颜色宏定义
 */
#import "UIColor+Hex.h"
#define COLOR_WHITE_F9FCFF [UIColor colorWithHexString:@"#F9FCFF"]
#define COLOR_WHITE_FAF9FE [UIColor colorWithHexString:@"#FAF9FE"]
#define COLOR_WHITE_FCFDFF [UIColor colorWithHexString:@"#FCFDFF"]

#define COLOR_RED_FF3C5E [UIColor colorWithHexString:@"#ff3c5e"]
#define COLOR_BLUE_D5F2FF [UIColor colorWithHexString:@"#D5F2FF"]
#define COLOR_GRAY_DADADA [UIColor colorWithHexString:@"#DADADA"]

#define COLOR_RED_EA0000 [UIColor colorWithHexString:@"#EA0000"]
#define COLOR_BLACK_000000 [UIColor colorWithHexString:@"#000000"]
#define COLOR_RED_FF0000 [UIColor colorWithHexString:@"#FF0000"]
#define COLOR_YELLOW_FFBA15 [UIColor colorWithHexString:@"#FFBA15"]
#define COLOR_RED_FF531E    [UIColor colorWithHexString:@"#FF531E"]

#define COLOR_RED_FF3455 [UIColor colorWithHexString:@"#FF3455"]
#define COLOR_RED_FF9B5E [UIColor colorWithHexString:@"#FF9B5E"]
#define COLOR_RED_FF3559 [UIColor colorWithHexString:@"#FF3559"]
#define COLOR_RED_FC4865 [UIColor colorWithHexString:@"#fc4865"]
#define COLOR_RED_F93362 [UIColor colorWithHexString:@"#F93362"]
#define COLOR_RED_FC4865 [UIColor colorWithHexString:@"#fc4865"]
#define COLOR_RED_FF4666 [UIColor colorWithHexString:@"#FF4666"]
#define COLOR_RED_FE2A3B [UIColor colorWithHexString:@"#FE2A3B"]
#define COLOR_RED_F94766 [UIColor colorWithHexString:@"#F94766"]
#define COLOR_RED_FF4260 [UIColor colorWithHexString:@"#FF4260"]
#define COLOR_RED_FF4562 [UIColor colorWithHexString:@"#FF4562"]
#define COLOR_RED_912D01 [UIColor colorWithHexString:@"#912D01"]

#define COLOR_BLUE_0E78f6 [UIColor colorWithHexString:@"#0E78f6"]
#define COLOR_BLUE_74A1BA [UIColor colorWithHexString:@"#74A1BA"]

#define COLOR_PINK_FF1F5E [UIColor colorWithHexString:@"#ff1f5e"]
#define COLOR_PINK_FFEFF2 [UIColor colorWithHexString:@"#FFEFF2"]
#define COLOR_PINK_FFC5C4 [UIColor colorWithHexString:@"#FFC5C4"]

#define COLOR_GREEN_EFF3F6 [UIColor colorWithHexString:@"#EFF3F6"]
#define COLOR_GREEN_7B929F [UIColor colorWithHexString:@"#7B929F"]
#define COLOR_BLUE_259BFF [UIColor colorWithHexString:@"#259BFF"]

#define COLOR_YELLOW_FFAF47 [UIColor colorWithHexString:@"#FFAF47"]

#define COLOR_ORANGE_F59C40 [UIColor colorWithHexString:@"#F59C40"]
#define COLOR_ORANGE_FF9B5E [UIColor colorWithHexString:@"#FF9B5E"]

#define COLOR_BLUE_2AA5FC [UIColor colorWithHexString:@"#2AA5FC"]
#define COLOR_GRAY_F2F2F2 [UIColor colorWithHexString:@"#F2F2F2"]
#define COLOR_GRAY_AAAAAA  [UIColor colorWithHexString:@"#AAAAAA"]
#define COLOR_BLACK_333333 [UIColor colorWithHexString:@"#333333"]
#define COLOR_BLACK_444444 [UIColor colorWithHexString:@"#444444"]
#define COLOR_BLACK_666666 [UIColor colorWithHexString:@"#666666"]
#define COLOR_BLACK_6E7980 [UIColor colorWithHexString:@"#6E7980"]
#define COLOR_BLACK_111111 [UIColor colorWithHexString:@"#111111"]
#define COLOR_BLACK_101010 [UIColor colorWithHexString:@"#101010"]
#define COLOR_BLACK_4A4A4B [UIColor colorWithHexString:@"#4A4A4B"]
#define COLOR_BLACK_090103 [UIColor colorWithHexString:@"#090103"]
#define COLOR_BLACK_TRANS_1111119b [UIColor colorWithHexString:@"#1111119b"]

#define COLOR_GRAY_DBDBDB [UIColor colorWithHexString:@"#dbdbdb"]
#define COLOR_GRAY_E0E0E0 [UIColor colorWithHexString:@"#E0E0E0"]
#define COLOR_GRAY_E6E5E5 [UIColor colorWithHexString:@"#E6E5E5"]
#define COLOR_GRAY_E5E5E5 [UIColor colorWithHexString:@"#E5E5E5"]
#define COLOR_GRAY_E6E6E6 [UIColor colorWithHexString:@"#E6E6E6"]
#define COLOR_GRAY_EBEBEB [UIColor colorWithHexString:@"#EBEBEB"]
#define COLOR_GRAY_F0F0F0 [UIColor colorWithHexString:@"#F0F0F0"]
#define COLOR_GRAY_F1F1F1 [UIColor colorWithHexString:@"#F1F1F1"]
#define COLOR_GRAY_F2F2F2 [UIColor colorWithHexString:@"#F2F2F2"]
#define COLOR_GRAY_F4F4F4 [UIColor colorWithHexString:@"#F4F4F4"]
#define COLOR_GRAY_F44230 [UIColor colorWithHexString:@"#F44230"]

#define COLOR_GRAY_F6F6F6 [UIColor colorWithHexString:@"#F6F6F6"]
#define COLOR_GRAY_F7F7F7 [UIColor colorWithHexString:@"#F7F7F7"]
#define COLOR_GRAY_F8F8F8 [UIColor colorWithHexString:@"#F8F8F8"]
#define COLOR_GRAY_F8FAFC [UIColor colorWithHexString:@"#F8FAFC"]
#define COLOR_GRAY_FAF9FE [UIColor colorWithHexString:@"#FAF9FE"]
#define COLOR_GRAY_F9FAFD [UIColor colorWithHexString:@"#F9FAFD"]
#define COLOR_GRAY_FBFBFB [UIColor colorWithHexString:@"#FBFBFB"]
#define COLOR_GRAY_EEEEEE [UIColor colorWithHexString:@"#eeeeee"]
#define COLOR_GRAY_FFFFFF [UIColor colorWithHexString:@"#ffffff"]
#define COLOR_BLACK_1B1C23 [UIColor colorWithHexString:@"#1B1C23"]

#define COLOR_GRAY_CCCCCC [UIColor colorWithHexString:@"#CCCCCC"]
#define COLOR_GRAY_C4C4C4 [UIColor colorWithHexString:@"#C4C4C4"]
#define COLOR_GRAY_999999 [UIColor colorWithHexString:@"#999999"]
#define COLOR_BLUE_83A4FF [UIColor colorWithHexString:@"#83A4FF"]
#define COLOR_GRAY_D7D7E1 [UIColor colorWithHexString:@"#d7d7e1"]
#define COLOR_GRAY_D2D3D4 [UIColor colorWithHexString:@"#D2D3D4"]
#define COLOR_GRAY_DDDDDD [UIColor colorWithHexString:@"#DDDDDD"]
#define COLOR_GRAY_D9D9D9 [UIColor colorWithHexString:@"#D9D9D9"]
#define COLOR_GRAY_BFBFBF [UIColor colorWithHexString:@"#BFBFBF"]
#define COLOR_GRAY_AAAAAA [UIColor colorWithHexString:@"#AAAAAA"]
#define COLOR_GRAY_7A7878 [UIColor colorWithHexString:@"#7A7878"]
#define COLOR_GRAY_CDCDCD [UIColor colorWithHexString:@"#CDCDCD"]
#define COLOR_GRAY_A5B9CE [UIColor colorWithHexString:@"#A5B9CE"]
#define COLOR_GRAY_DAA6A6 [UIColor colorWithHexString:@"#DAA6A6"]
#define COLOR_GRAY_A6A6A6 [UIColor colorWithHexString:@"#A6A6A6"]
#define COLOR_GRAY_BBBBBB [UIColor colorWithHexString:@"#BBBBBB"]
#define COLOR_GRAY_B2B2B2 [UIColor colorWithHexString:@"#B2B2B2"]
#define COLOR_GRAY_BCC1CF [UIColor colorWithHexString:@"#BCC1CF"]
#define COLOR_GRAY_888888 [UIColor colorWithHexString:@"#888888"]
#define COLOR_GRAY_878787 [UIColor colorWithHexString:@"#878787"]
#define COLOR_GRAY_808080 [UIColor colorWithHexString:@"#808080"]
#define COLOR_RED_F91E54 [UIColor colorWithHexString:@"#F91E54"]
#define COLOR_GRAY_F9F9F9 [UIColor colorWithHexString:@"#F9F9F9"]


#define kAppleId @"1447187764"

/**
 字体宏定义
 */
#define FONT_BOLD @"PingFangSC-Semibold"
#define FONT_MEDIUM @"PingFangSC-Medium"
#define FONT_REGULAR @"PingFangSC-Regular"
#define FONT_LIGHT @"PingFangSC-Light"
#define ImageNamed(_pointer) ([UIImage imageNamed:_pointer])
/* 平方-中号 */
#define kFont_Medium(font)  [UIFont fontWithName:@"PingFangSC-Medium"size:font]
/* 平方-粗体 */
#define kFont_Bold(font)  [UIFont fontWithName:@"PingFangSC-Semibold"size:font]
#define kFont_Regular(font)  [UIFont fontWithName:@"PingFangSC-Regular"size:font]
#define kFont_Heavy(font)  [UIFont fontWithName:@"PingFangSC-Semibold"size:font]
#define kRect(x, y, w, h)   CGRectMake(x, y, w, h)
//#define kBaseUrl  @"https://inner.hepaicn.com"
//#define kBaseUrl  @"https://app.hepaicn.com"
#define kBaseUrl  @"http://192.168.0.104:8083"//测试
//#define kBaseUrl  @"http://192.168.0.60:8083"//罗
//#define kBaseUrl  @"http://192.168.0.148:8083"//胜光

#define BoundWithSize(str,width,font)   ([str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil])
//APP版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//系统版本号
#define kSystemVersion [[UIDevice currentDevice] systemVersion]
#define kAppdelegateWindow    [UIApplication sharedApplication].delegate.window
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define iPhone5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define CODE                 [[responseObject objectForKey:@"code"] integerValue]
#define MSG                 [responseObject objectForKey:@"msg"]
#define DATA                 [responseObject objectForKey:@"data"]
#define ErrorNet                 [HPProgressHUD alertMessage:@"网络错误"];
//弱引用/强引用
#define kWeakSelf(weakSelf)  __weak __typeof(&*self) weakSelf = self;

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#import "MJExtension.h"
#import "AFNetworking.h"
#import "HPHTTPSever.h"
#import "HPProgressHUD.h"
#import "HPLoginModel.h"
#import "HPUserTool.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "YYLRefreshNoDataView.h"
#import "UIScrollView+Refresh.h"
#import "HPTimeString.h"
//高德地图相关
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

//自定义打印语句
#ifdef DEBUG
# define HPLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define HPLog(...);
#endif

/**
 高德地图API key
 */
#define AMAP_KEY @"bdd5ea7841253bf7196e963c2e5a830a"

#endif /* Macro_h */
