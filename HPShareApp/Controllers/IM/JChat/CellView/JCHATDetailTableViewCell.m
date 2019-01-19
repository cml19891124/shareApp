//
//  JCHATDetailTableViewCell.m
//  JPush IM
//
//  Created by Apple on 15/1/22.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATDetailTableViewCell.h"
#import "Macro.h"
//#import "JChatConstants.h"
#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation JCHATDetailTableViewCell

- (void)awakeFromNib {
  UILabel *line =[[UILabel alloc] initWithFrame:CGRectMake(0, 56,kScreenWidth, 0.5)];
  [line setBackgroundColor:UIColorFromRGB(0xd0d0cf)];
  [self addSubview:line];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
