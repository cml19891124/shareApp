//
//  HPCheckTableCell.h
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPCheckTableCell : HPBaseTableViewCell

@property (nonatomic) BOOL isSingle;

@property (nonatomic, readonly) BOOL isCheck;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) CGFloat textMarginLeft;

@property (nonatomic, assign) CGFloat selectedIconMarginRight;

@property (nonatomic, strong) UIImage *selectedIcon;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *textSelectedColor;

- (void)setCheck:(BOOL)isCheck;

@end

NS_ASSUME_NONNULL_END
