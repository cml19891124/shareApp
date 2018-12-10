//
//  HPRightImageButton.h
//  HPShareApp
//
//  Created by HP on 2018/11/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPRightImageButton : HPBaseControl

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *selectedText;

@property (nonatomic, assign) CGFloat space;

- (void)setImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END