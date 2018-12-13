//
//  HPPageView.m
//  HPShareApp
//
//  Created by HP on 2018/12/1.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPageView.h"

@interface HPPageView ()

@property (nonatomic, assign) NSInteger pageItemNum;

@property (nonatomic, assign) NSInteger centerPageItemIndex;

@property (nonatomic, assign) CGFloat centerOffsetX;

@property (nonatomic, strong) NSMutableArray *pageItemViews;

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
        _pageItemViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setupUI {
    [self setClipsToBounds:YES];
    
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
    
    for (int i = 0; i < _pageItemNum; i ++) {
        UIView *pageItemView = [[UIView alloc] init];
        [scrollView addSubview:pageItemView];
        [_pageItemViews addObject:pageItemView];
        [pageItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self);
            make.width.mas_equalTo(self.pageWidth);
            make.height.mas_equalTo(self.frame.size.height);
            
            if (i == 0) {
                make.left.equalTo(scrollView);
            }
            else {
                UIView *lastPageItemView = self.pageItemViews[i - 1];
                make.left.equalTo(lastPageItemView.mas_right).with.offset(self.pageSpace);
            }
            
            if (i == self.pageItemNum - 1) {
                make.right.equalTo(scrollView).with.offset(-self.pageSpace);
            }
        }];
    }
    
    [self refreshPageItem];
}

- (void)refreshPageItem {
    if (_pageItemViews.count == 0) {
        return;
    }
    
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(pageNumberOfPageView:)]) {
            _pageNumber = [_delegate pageNumberOfPageView:self];
        }
        
        if (_pageNumber <= 0) {
            return;
        }
        else if (_currentPage > _pageNumber - 1) {
            _currentPage = _currentPage - _pageNumber;
        }
        else if (_currentPage < 0) {
            _currentPage = _pageNumber + _currentPage;
        }
        
        if ([_delegate respondsToSelector:@selector(pageView:viewAtPageIndex:)]) {
            UIView *centerView = _pageItemViews[_centerPageItemIndex];
            
            if (centerView.subviews.count > 0) {
                [centerView.subviews[0] removeFromSuperview];
            }
            
            UIView *centerPageItem = [_delegate pageView:self viewAtPageIndex:_currentPage];
            if (centerPageItem) {
                [centerView addSubview:centerPageItem];
                [centerPageItem mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(centerView);
                }];
            }
            
            [_scrollView setContentOffset:CGPointMake(_centerOffsetX, 0.f)];
            
            if (_pageNumber >= 2) {
                for (NSInteger i = _centerPageItemIndex - 1; i >= 0; i --) {
                    UIView *leftView = _pageItemViews[i];
                    if (leftView.subviews.count > 0) {
                        [leftView.subviews[0] removeFromSuperview];
                    }
                    
                    NSInteger leftPageIndex = _currentPage - (_centerPageItemIndex - i) < 0 ? _pageNumber + _currentPage - (_centerPageItemIndex - i) : _currentPage - (_centerPageItemIndex - i);
                    
                    UIView *leftPageItem = [_delegate pageView:self viewAtPageIndex:leftPageIndex];
                    if (leftPageItem) {
                        [leftView addSubview:leftPageItem];
                        [leftPageItem mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.edges.equalTo(leftView);
                        }];
                    }
                }
                
                for (NSInteger i = _centerPageItemIndex + 1; i < _pageItemNum; i ++) {
                    UIView *rightView = _pageItemViews[i];
                    if (rightView.subviews.count > 0) {
                        [rightView.subviews[0] removeFromSuperview];
                    }
                    
                    NSInteger rightPageIndex = _currentPage + i - _centerPageItemIndex < _pageNumber ? _currentPage + i - _centerPageItemIndex : _currentPage + i - _centerPageItemIndex - _pageNumber;
                    
                    UIView *rightPageItem = [_delegate pageView:self viewAtPageIndex:rightPageIndex];
                    if (rightPageItem) {
                        [rightView addSubview:rightPageItem];
                        [rightPageItem mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.edges.equalTo(rightView);
                        }];
                    }
                }
            }
        }
    }
}

- (void)updateConstraints {
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"+++layoutSubviews");
    
    if (_pageWidth == 0.f) {
        _pageWidth = self.frame.size.width;
    }
    
    if (_pageWidth == self.frame.size.width) {
        _pageItemNum = 3;
    }
    else {
        _pageItemNum = 5;
    }
    
    _centerPageItemIndex = _pageItemNum/2;
    _centerOffsetX = _centerPageItemIndex*(self.pageWidth + self.pageSpace);
    
    if (_scrollView) {
        [_scrollView removeFromSuperview];
        [_pageItemViews removeAllObjects];
    }
    
    [self setupUI];
}

- (void)drawRect:(CGRect)rect {
    [_scrollView setContentOffset:CGPointMake(_centerOffsetX, 0.f)];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == _centerOffsetX) {
        return;
    }
    
    CGFloat deltaOffsetX = scrollView.contentOffset.x - _centerOffsetX;
    NSInteger deltaIndex = deltaOffsetX / (_pageWidth + _pageSpace);
    
    _currentPage += deltaIndex;
    
    [self refreshPageItem];
    
    if (_delegate && [_delegate respondsToSelector:@selector(pageView:didScrollAtIndex:)]) {
        [_delegate pageView:self didScrollAtIndex:_currentPage];
    }
}

@end
