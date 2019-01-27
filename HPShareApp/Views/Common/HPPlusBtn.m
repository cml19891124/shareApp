//
//  HPPlusBtn.m
//  HPShareApp
//
//  Created by HP on 2019/1/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPlusBtn.h"
#import "Macro.h"
#import "HPGlobalVariable.h"
#define buttonW  self.frame.size.width
#define buttonH  self.frame.size.height


@implementation HPPlusBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = kFont_Medium(10.f);
        [self setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return kRect((buttonW - getWidth(39.f))/2,0, getWidth(39.f), getWidth(39.f));
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return kRect(0, buttonH - getWidth(10.f), buttonW, getWidth(13.f));
}

//超出区域外点击无效
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //tabbarVC 是否隐藏，隐藏了就不需要考虑点击了
    if (self.hidden) {
        return [super hitTest:point withEvent:event];
    }else{
        //将centerBtn上的点转化成父View上的点
        CGPoint touch = [self convertPoint:point fromView:self];
        //判断点击的点是否在按钮的区域内
        if (CGRectContainsPoint(self.bounds, touch)) {
            return self;
        }else{
            return [super hitTest:point withEvent:event];
        }
    }
}
@end
