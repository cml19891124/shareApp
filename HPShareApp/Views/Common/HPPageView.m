//
//  HPPageView.m
//  HPShareApp
//
//  Created by HP on 2018/12/1.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPageView.h"

@interface HPPageView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIView *leftView;

@property (nonatomic, weak) UIView *centerView;

@property (nonatomic, weak) UIView *rightView;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation HPPageView

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
        _pageMarginLeft = 0.f;
        _pageWidth = 0.f;
        _pageSpace = 0.f;
        _pageNumber = 0;
        _currentPage = 0;
    }
    return self;
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setBounces:NO];
    [scrollView setClipsToBounds:NO];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setDelegate:self];
    [self addSubview:scrollView];
    _scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self);
        make.left.equalTo(self).with.offset(self.pageMarginLeft);
        make.width.mas_equalTo(self.pageWidth + self.pageSpace);
    }];
    
    UIView *leftView = [[UIView alloc] init];
    [scrollView addSubview:leftView];
    _leftView = leftView;
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(scrollView);
        make.left.equalTo(scrollView);
        make.width.mas_equalTo(self.pageWidth);
    }];
    
    UIView *centerView = [[UIView alloc] init];
    [scrollView addSubview:centerView];
    _centerView = centerView;
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(scrollView);
        make.left.equalTo(leftView.mas_right).with.offset(self.pageSpace);
        make.width.mas_equalTo(self.pageWidth);
    }];
    
    UIView *rightView = [[UIView alloc] init];
    [scrollView addSubview:rightView];
    _rightView = rightView;
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(scrollView);
        make.left.equalTo(centerView.mas_right).with.offset(self.pageSpace);
        make.width.mas_equalTo(self.pageWidth);
        make.right.equalTo(scrollView);
    }];
    
    [self setupPageItem];
}

- (void)setupPageItem {
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(pageNumberOfPageView:)]) {
            _pageNumber = [_delegate pageNumberOfPageView:self];
        }
        
        if (_pageNumber <= 0) {
            return;
        }
        else if (_pageNumber < _currentPage + 1) {
            _currentPage = 0;
        }
        else if (_currentPage < 0) {
            _currentPage = _pageNumber - 1;
        }
        
        if ([_delegate respondsToSelector:@selector(pageView:viewAtPageIndex:)]) {
            if (_centerView.subviews.count > 0) {
                [_centerView.subviews[0] removeFromSuperview];
            }
            
            UIView *centerPageItem = [_delegate pageView:self viewAtPageIndex:_currentPage];
            if (centerPageItem) {
                [self.centerView addSubview:centerPageItem];
                [centerPageItem mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.centerView);
                }];
            }
            
            [_scrollView setContentOffset:CGPointMake(self.pageWidth + self.pageSpace, 0.f)];
            
            if (_pageNumber >= 2) {
                if (_leftView.subviews.count > 0) {
                    [_leftView.subviews[0] removeFromSuperview];
                }
                
                NSInteger leftPage = _currentPage - 1 < 0 ? _pageNumber - 1 : _currentPage - 1;
                UIView *leftPageItem = [_delegate pageView:self viewAtPageIndex:leftPage];
                if (leftPageItem) {
                    [self.leftView addSubview:leftPageItem];
                    [leftPageItem mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.leftView);
                    }];
                }
                
                if (_rightView.subviews.count > 0) {
                    [_rightView.subviews[0] removeFromSuperview];
                }
                
                NSInteger rightPage = _currentPage + 1 < _pageNumber ? _currentPage + 1 : 0;
                UIView *rightPageItem = [_delegate pageView:self viewAtPageIndex:rightPage];
                if (rightPageItem) {
                    [self.rightView addSubview:rightPageItem];
                    [rightPageItem mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.rightView);
                    }];
                }
            }
        }
    }
}

- (void)updateConstraints {
    NSLog(@"+++updateConstraints: %f", _scrollView.contentOffset.x);
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"+++layoutSubviews");
    
    if (_pageWidth == 0.f) {
        _pageWidth = self.frame.size.width;
    }
    
    if (_scrollView) {
        [_scrollView removeFromSuperview];
    }
    
    [self setupUI];
}

- (void)drawRect:(CGRect)rect {
    [_scrollView setContentOffset:CGPointMake(self.pageWidth + self.pageSpace, 0.f)];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == self.pageWidth + self.pageSpace) {
        return;
    }
    else if (scrollView.contentOffset.x > self.pageWidth + self.pageSpace) {
        _currentPage += 1;
    }
    else {
        _currentPage -= 1;
    }
    
    [self setupPageItem];
}

@end
