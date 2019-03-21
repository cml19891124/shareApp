//
//  UIView+Corner.m
//  HPShareApp
//
//  Created by HP on 2019/3/21.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)
/*
 当设置完控件的约束，需要调用layoutIfNeeded 函数进行布局，然后所约束的控件才会按照约束条件，生成当前布局相应的frame和bounds。这样就可以利用这两个属性来进行图片圆角剪裁。

下面是我写的一个view分类中的设置圆角方法
 */
/**
 * setCornerRadius   给view设置圆角
 * @param value      圆角大小
 * @param rectCorner 圆角位置
 **/
- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner{
    
    [self layoutIfNeeded];//这句代码很重要，不能忘了
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(value, value)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
    
}

@end
