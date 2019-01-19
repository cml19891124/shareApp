//
//  JCHATPersonInfoCell.m
//  JPush IM
//
//  Created by Apple on 15/2/5.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATPersonInfoCell.h"
//#import "JChatConstants.h"
#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "Masonry.h"
#import "Macro.h"
#define kSeparationLineColor UIColorFromRGB(0xd0d0d0)

@implementation JCHATPersonInfoCell

- (void)awakeFromNib {
  // Initialization code
  [_personInfoConten setTextColor:UIColorFromRGB(0x808080)];
  _personInfoConten.textAlignment = NSTextAlignmentRight;
  [_personInfoConten setEnabled:NO];
  [_personInfoConten setNumberOfLines:0];
  
  UIView *subLine = [UIView new];
  [self  addSubview:subLine];
  [subLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self);
    make.right.mas_equalTo(self);
    make.height.mas_equalTo(0.5);
    make.bottom.mas_equalTo(self);
  }];
  subLine.backgroundColor = kSeparationLineColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
