//
//  HPLinkageTopModalView.m
//  HPShareApp
//
//  Created by Jay on 2018/12/27.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPLinkageTopModalView.h"

@interface HPLinkageTopModalView ()

@property (nonatomic, strong) HPLinkageData *data;

@property (nonatomic, weak) HPLinkageView *linkageView;

@end

@implementation HPLinkageTopModalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithData:(HPLinkageData *)data {
    _data = data;
    self = [super init];
    return self;
}

- (void)setupModalView:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.top.equalTo(self);
    }];
    
    HPLinkageView *linkageView = [[HPLinkageView alloc] initWithData:_data];
    [linkageView setBackgroundColor:UIColor.whiteColor];
    [linkageView setLeftHeaderHeight:getWidth(15.f)];
    [linkageView setLeftCellHeight:12.f + getWidth(30.f)];
    [linkageView setLeftTextFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [linkageView setLeftTextColor:COLOR_BLACK_666666];
    [linkageView setRightHeaderHeight:getWidth(15.f)];
    [linkageView setRightCellHeight:12.f + getWidth(30.f)];
    [linkageView setRightTextFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [linkageView setRightTextColor:COLOR_BLACK_666666];
    [linkageView setSelectedIcon:[UIImage imageNamed:@"select_icon"]];
    [linkageView setSelectedIconMarginRight:getWidth(100.f)];
    [view addSubview:linkageView];
    _linkageView = linkageView;
    [linkageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.width.equalTo(view);
        make.height.mas_equalTo(getWidth(280.f));
        make.bottom.equalTo(view);
    }];
}

- (void)onTapModalOutSide {
    [self show:NO];
}

- (void)setDelegate:(id<HPLinkageViewDelegate>)delegate {
    _delegate = delegate;
    [_linkageView setDelegate:delegate];
}

- (void)selectCellAtParentIndex:(NSInteger)pIndex childIndex:(NSInteger)cIndex {
    [_linkageView selectCellAtParentIndex:pIndex childIndex:cIndex];
}

@end
