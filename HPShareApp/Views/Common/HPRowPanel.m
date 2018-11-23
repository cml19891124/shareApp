//
//  HPRowPanel.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPRowPanel.h"

@interface HPRowPanel () {
    int shrinkStart;
    int shrinkEnd;
    CGFloat wholeHeight; //panel的高度
}

/**
 行视图数组
 */
@property (nonatomic, strong) NSMutableArray *rowViews;

/**
 分割线数组
 */
@property (nonatomic, strong) NSMutableArray *lines;

@end

@implementation HPRowPanel

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
        [self setBackgroundColor:UIColor.whiteColor];
        [self.layer setMasksToBounds:YES];
        _rowHeight = 45.f * g_rateWidth;
        _lineWidth = 335.f * g_rateWidth;
        _lineColor = COLOR_GRAY_EEEEEE;
        _rowViews = [[NSMutableArray alloc] init];
        _lines = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addRowView:(UIView *)view {
    [self addRowView:view withHeight:_rowHeight];
}

- (void)addRowView:(UIView *)view withHeight:(CGFloat)height {
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.left.and.width.equalTo(self);
        if (self.rowViews.count > 0) {
            UIView *lastLine = self.lines.lastObject;
            make.top.equalTo(lastLine.mas_bottom);
        }
        else {
            make.top.equalTo(self);
        }
    }];
    [self.rowViews addObject:view];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:_lineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.lineWidth, 1.f));
        make.top.equalTo(view.mas_bottom);
    }];
    [self.lines addObject:line];
}

- (void)shrinkFrom:(int)start to:(int)end {
    shrinkStart = start;
    shrinkEnd = end;
    [self layoutIfNeeded];
    wholeHeight = self.frame.size.height;
    CGFloat shrinkHeight = 0.f;
    for (int i = start; i <= end; i ++) {
        UIView *view = self.rowViews[i];
        UIView *line = self.lines[i];
        [view setHidden:YES];
        [line setHidden:YES];
        shrinkHeight += view.frame.size.height + line.frame.size.height;
    }
    
    UIView *endNextView = self.rowViews[end + 1];
    UIView *startUpLine = self.lines[start - 1];
    CGFloat height = endNextView.frame.size.height;
    [endNextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self);
        make.top.equalTo(startUpLine.mas_bottom);
        make.height.mas_equalTo(height);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self->wholeHeight - shrinkHeight);
    }];
}

- (void)expand {
    for (int i = shrinkStart; i <= shrinkEnd; i ++) {
        UIView *view = self.rowViews[i];
        UIView *line = self.lines[i];
        [view setHidden:NO];
        [line setHidden:NO];
    }
    
    UIView *endNextView = self.rowViews[shrinkEnd + 1];
    UIView *endNextLine = self.lines[shrinkEnd];
    CGFloat height = endNextView.frame.size.height;
    [endNextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self);
        make.top.equalTo(endNextLine.mas_bottom);
        make.height.mas_equalTo(height);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self->wholeHeight);
    }];
}


@end

