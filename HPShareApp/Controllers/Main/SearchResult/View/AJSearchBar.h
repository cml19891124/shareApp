//
//  AJSearchBar.h
//  准到-ipad
//
//  Created by zhundao on 2017/9/8.
//  Copyright © 2017年 zhundao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>

- (void)searchWithStr:(NSString *)text;

- (void)clickPopToHomeVC;
@end

@interface AJSearchBar : UIView

@property(nonatomic,copy)NSString *AJPlaceholder;

@property(nonatomic,strong)UIColor *AJCursorColor;

@property (nonatomic, strong) NSMutableArray *historyArray;

@property(nonatomic,weak) id<SearchDelegate> SearchDelegate;

/*! 输入框 */
@property(nonatomic,strong)UITextField *textField;

@property (nonatomic, strong) UIView *lineView;

/*! 取消按钮 */
@property(nonatomic,strong)UIButton *cancelButton;

@property (nonatomic, assign) BOOL hidden;
- (void)clear;

@end
