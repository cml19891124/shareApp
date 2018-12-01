//
//  HPCirclePageControl.m
//  HPShareApp
//
//  Created by HP on 2018/12/1.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCirclePageControl.h"

@interface HPCirclePageControl ()

@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation HPCirclePageControl

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
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [pageControl setPageIndicatorTintColor:[UIColor.whiteColor colorWithAlphaComponent:0.5f]];
    [pageControl setCurrentPageIndicatorTintColor:UIColor.whiteColor];
    [self addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setNumberOfPages:(NSInteger)numOfPages {
    [_pageControl setNumberOfPages:numOfPages];
}

- (void)setCurrentPage:(NSInteger)page {
    [_pageControl setCurrentPage:page];
}

@end
