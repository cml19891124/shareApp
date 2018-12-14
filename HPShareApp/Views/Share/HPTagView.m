//
//  HPTagView.m
//  HPShareApp
//
//  Created by Jay on 2018/12/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTagView.h"

@interface HPTagView ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation HPTagView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.layer setCornerRadius:4.f];
    [self setBackgroundColor:COLOR_GREEN_EFF3F6];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:kFont_Medium(11.f)];
    [label setTextColor:COLOR_GREEN_7B929F];
    [self addSubview:label];
    _label = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(5.f);
        make.right.equalTo(self).with.offset(-5.f);
        make.top.and.bottom.equalTo(self);
        make.height.mas_equalTo(17.f);
    }];
}

- (void)setText:(NSString *)text {
    [_label setText:text];
}

@end
