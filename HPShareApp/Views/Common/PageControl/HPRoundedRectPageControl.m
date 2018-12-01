//
//  HPPageControl.m
//  HPShareApp
//
//  Created by HP on 2018/11/22.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRoundedRectPageControl.h"
#import "StyledPageControl.h"
#import "HPImageUtil.h"

@interface HPRoundedRectPageControl ()

@property (nonatomic, weak) StyledPageControl *pageControl;

@end

@implementation HPRoundedRectPageControl

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
    UIImage *pageCurrentImage = [HPImageUtil getRectangleByStrokeColor:UIColor.whiteColor fillColor:UIColor.whiteColor borderWidth:1.f cornerRadius:2.f inRect:CGRectMake(0.f, 0.f, 9.f, 4.f)];
    UIImage *pageImage = [HPImageUtil getRectangleByStrokeColor:UIColor.whiteColor fillColor:[UIColor.whiteColor colorWithAlphaComponent:0.5f] borderWidth:0.f cornerRadius:2.f inRect:CGRectMake(0.f, 0.f, 4.f, 4.f)];
    
    StyledPageControl *pageControl = [[StyledPageControl alloc] init];
    [pageControl setCoreNormalColor:[UIColor.whiteColor colorWithAlphaComponent:0.5f]];
    [pageControl setPageControlStyle:PageControlStyleThumb];
    [pageControl setSelectedThumbImage:pageCurrentImage];
    [pageControl setThumbImage:pageImage];
    [pageControl setGapWidth:2.5f];
    [self addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(5.f);
    }];
}

- (void)setNumberOfPages:(NSInteger)numOfPages {
    [_pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(numOfPages*9.f + (numOfPages-1)*self.pageControl.gapWidth);
    }];
    [_pageControl setNumberOfPages:numOfPages];
}

- (void)setCurrentPage:(NSInteger)page {
    [_pageControl setCurrentPage:page];
}

@end
