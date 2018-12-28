//
//  HPHeaderTableView.m
//  HPShareApp
//
//  Created by Jay on 2018/12/16.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSubTableView.h"

@interface HPSubTableView ()

@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation HPSubTableView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _contentHeight = self.contentSize.height - self.frame.size.height;
}


- (void)setContentOffset:(CGPoint)contentOffset {
    if (contentOffset.y == 0.f) {
        contentOffset.y = 0.5f;
    }
    else if (contentOffset.y == _contentHeight) {
        contentOffset.y = _contentHeight - 1.f;
    }
    
    [super setContentOffset:contentOffset];
}

@end
