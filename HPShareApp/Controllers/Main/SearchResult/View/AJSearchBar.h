//
//  AJSearchBar.h
//  准到-ipad
//
//  Created by zhundao on 2017/9/8.
//  Copyright © 2017年 zhundao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>

/**
   根据文字搜索店铺
 */
- (void)searchWithStr:(NSString *)text;

/**
 点击取消返回
 */
- (void)clickPopToHomeVC;
@end

@interface AJSearchBar : UIView

/**
 搜索文字占位符字符串
 */
@property(nonatomic,copy)NSString *AJPlaceholder;

@property(nonatomic,strong)UIColor *AJCursorColor;

/**
 搜索的历史记录数组
 */
@property (nonatomic, strong) NSMutableArray *historyArray;

@property(nonatomic,weak) id<SearchDelegate> SearchDelegate;

/*! 输入框 */
@property(nonatomic,strong)UITextField *textField;

@property (nonatomic, strong) UIView *lineView;

/*! 取消按钮 */
@property(nonatomic,strong)UIButton *cancelButton;

/**
 隐藏lineView 和 cancelbtn
 */
@property (nonatomic, assign) BOOL hidden;

/**
 点击后清理搜索历史记录
 */
- (void)clear;

@end
