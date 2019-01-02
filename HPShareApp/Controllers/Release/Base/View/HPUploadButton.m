//
//  HPUploadButton.m
//  HPShareApp
//
//  Created by HP on 2018/12/27.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPUploadButton.h"

@implementation HPUploadButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = COLOR_GRAY_999999;
        self.titleLabel.font = kFont_Medium(11.f);
        
//        [self addSubview:self.deleteBtn];
//        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(getWidth(15.f), getWidth(15.f)));
//            make.left.mas_equalTo(getWidth(67.5f));
//            make.top.mas_equalTo(getWidth(-7.5f));
//        }];
        
        [self addSubview:self.faceLabel];
        [self.faceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(self.faceLabel.font.pointSize + getWidth(10.f));
        }];
    }
    return self;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    if (self.titleLabel.text.length) {
        return kRect(getWidth(27.f), getWidth(12.f), getWidth(23.f), getWidth(20.f));
    }else{
        return kRect(getWidth(27.f), getWidth(23.f), getWidth(23.f), getWidth(20.f));
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return kRect(0, getWidth(44.f), self.frame.size.width, getWidth(11.f));
}

//- (UIButton *)deleteBtn
//{
//    if (!_deleteBtn) {
//        _deleteBtn = [UIButton new];
//        _deleteBtn.layer.cornerRadius = _deleteBtn.frame.size.height/2;
//        _deleteBtn.layer.masksToBounds = YES;
//        [_deleteBtn setBackgroundImage:ImageNamed(@"shop_transfer_cancel") forState:UIControlStateNormal];
//        [_deleteBtn addTarget:self action:@selector(clickTeletePhotoInActionSheet:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _deleteBtn;
//}


- (UILabel *)faceLabel
{
    if (!_faceLabel) {
        _faceLabel = [UILabel new];
        _faceLabel.text = @"店铺封面";
        _faceLabel.textColor = COLOR_GRAY_FFFFFF;
        _faceLabel.font = kFont_Medium(11.f);
        _faceLabel.textAlignment = NSTextAlignmentCenter;
        _faceLabel.backgroundColor = COLOR_BLACK_000000;
        _faceLabel.alpha = 0.5;
        _faceLabel.hidden = YES;
    }
    return _faceLabel;
}

- (void)clickTeletePhotoInActionSheet:(UIButton *)button
{
    if (self.clickDeleteBtnblock) {
        self.clickDeleteBtnblock(button.tag);
    }
}
@end
