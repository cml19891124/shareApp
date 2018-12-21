//
//  HPAddPhotoView.m
//  HPShareApp
//
//  Created by Jay on 2018/12/10.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAddPhotoView.h"

@interface HPAddPhotoView () {
    BOOL _isInit;
}

@property (nonatomic, weak) MASConstraint *leftConstraint;

@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, strong) NSMutableArray *deleteBtns;

@property (nonatomic, weak) UIButton *addBtn;

@end

@implementation HPAddPhotoView

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
        _isInit = YES;
        _maxNum = 4;
        _photos = [[NSMutableArray alloc] init];
        _imageViews = [[NSMutableArray alloc] init];
        _deleteBtns = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_isInit) {
        _isInit = NO;
        [self setupUI];
    }
}

- (void)setupUI {
    [self setBackgroundColor:UIColor.whiteColor];
//    shop_transfer_cancel
    //shop_transfer_plus
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn setImage:[UIImage imageNamed:@"shop_transfer_plus"] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:COLOR_GRAY_E6E6E6];
    [addBtn addTarget:self action:@selector(onClickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    _addBtn = addBtn;
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        self.leftConstraint = make.left.equalTo(self).with.offset(getWidth(20.f));
        make.top.equalTo(self).with.offset(getWidth(20.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(70.f), getWidth(70.f)));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:kFont_Medium(12.f)];
    [label setTextColor:COLOR_GRAY_878787];
    [label setText:@"只需上传四张照片即可"];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(getWidth(21.f));
        make.bottom.equalTo(self).with.offset(-getWidth(20.f));
        make.height.mas_equalTo(label.font.pointSize);
    }];
}

- (void)addPhoto:(UIImage *)image {
    if (_imageViews.count >= _maxNum) {
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.imageViews.count == 0) {
            make.left.equalTo(self).with.offset(getWidth(20.f));
        }
        else {
            UIImageView *lastImageView = self.imageViews.lastObject;
            make.left.equalTo(lastImageView.mas_right).with.offset(getWidth(15.f));
        }
        
        make.top.equalTo(self).with.offset(getWidth(20.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(70.f), getWidth(70.f)));
    }];
    
    [_addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.imageViews.count != self.maxNum - 1) {
            [self.leftConstraint uninstall];
            self.leftConstraint = make.left.equalTo(imageView.mas_right).with.offset(getWidth(15.f));
        }
    }];
    
    UIButton *deleteBtn = [[UIButton alloc] init];
    [deleteBtn setImage:[UIImage imageNamed:@"shop_transfer_cancel"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(onClickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView.mas_top);
        make.centerX.equalTo(imageView.mas_right);
        make.size.mas_equalTo(CGSizeMake(30.f, 30.f));
    }];
    
    [_imageViews addObject:imageView];
    [_deleteBtns addObject:deleteBtn];
    [_photos addObject:image];
}

- (void)onClickDeleteBtn:(UIButton *)btn {
    NSInteger index = [_deleteBtns indexOfObject:btn];
    UIImageView *imageView = _imageViews[index];
    
    [btn removeFromSuperview];
    [imageView removeFromSuperview];
    
    UIImageView *leftImageView = nil;
    if (index - 1 >= 0) {
        NSLog(@"++++++++++ left");
        leftImageView = _imageViews[index - 1];
    }
    
    UIImageView *rightImageView = nil;
    if (index + 1 < _imageViews.count) {
        NSLog(@"+++++++ right");
        rightImageView = _imageViews[index + 1];
    }
    
    if (leftImageView == nil && rightImageView == nil) {
        [_addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            [self.leftConstraint uninstall];
            self.leftConstraint = make.left.equalTo(self).with.offset(getWidth(20.f));
        }];
    }
    else if (leftImageView == nil) {
        [rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(getWidth(20.f));
        }];
    }
    else if (rightImageView == nil) {
        if (_imageViews.count == _maxNum) {
            UIImageView *lastImageView = _imageViews[_maxNum - 2];
            leftImageView = lastImageView;
        }
        
        [_addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            [self.leftConstraint uninstall];
            self.leftConstraint = make.left.equalTo(leftImageView.mas_right).with.offset(getWidth(15.f));
        }];
    }
    else {
        [rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImageView.mas_right).with.offset(getWidth(15.f));
        }];
        
        if (_imageViews.count == _maxNum) {
            UIImageView *lastImageView = _imageViews.lastObject;
            [_addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                [self.leftConstraint uninstall];
                self.leftConstraint = make.left.equalTo(lastImageView.mas_right).with.offset(getWidth(15.f));
            }];
        }
    }
    
    [_imageViews removeObjectAtIndex:index];
    [_deleteBtns removeObjectAtIndex:index];
    [_photos removeObjectAtIndex:index];
    
    if (_imageViews.count == 0) {
        [self setHidden:YES];
    }
}

- (void)onClickAddBtn:(UIButton *)btn {
    if (_addBtnCallBack) {
        _addBtnCallBack();
    }
}

@end
