//
//  HPHotImageView.m
//  HPShareApp
//
//  Created by HP on 2018/12/26.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHotImageView.h"

@implementation HPHotImageView

- (instancetype)initWithFrame:(CGRect)frame andAreaString:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.title = title;
        self.userInteractionEnabled = YES;
        UILabel *areaLabel = [UILabel new];
        areaLabel.textColor = COLOR_GRAY_FFFFFF;
        areaLabel.font = kFont_Bold(16.f);
        areaLabel.textAlignment = NSTextAlignmentCenter;
        areaLabel.text = _title;
        [self addSubview:areaLabel];
        _areaLabel = areaLabel;
        
        [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self);
            make.height.mas_equalTo(self.areaLabel.font.pointSize);
            make.centerY.mas_equalTo(self);
        }];
    }
    return self;
}


@end
