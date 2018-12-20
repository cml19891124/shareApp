//
//  HPIdeaExampleItem.m
//  HPShareApp
//
//  Created by HP on 2018/11/26.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPIdeaExampleItem.h"

@interface HPIdeaExampleItem ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *typeLabel;

@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UIView *photoView;

@property (nonatomic, weak) UIButton *detailBtn;

@end

@implementation HPIdeaExampleItem

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
    [self.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [self.layer setShadowOffset:CGSizeMake(0.f, 5.f)];
    [self.layer setShadowRadius:12.f];
    [self.layer setShadowOpacity:0.2f];
    [self setBackgroundColor:UIColor.whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(22.f * g_rateWidth);
        make.top.equalTo(self).with.offset(28.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UIView *typeView = [[UIView alloc] init];
    [typeView.layer setCornerRadius:2.f];
    [typeView setBackgroundColor:COLOR_GRAY_F7F7F7];
    [self addSubview:typeView];
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(10.f * g_rateWidth);
        make.left.equalTo(titleLabel);
        make.size.mas_equalTo(CGSizeMake(56.f, 20.f));
    }];
    
    UILabel *typeLabel = [[UILabel alloc] init];
    [typeLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [typeLabel setTextColor:COLOR_GRAY_999999];
    [typeView addSubview:typeLabel];
    _typeLabel = typeLabel;
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(typeView);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:14.f]];
    [descLabel setTextColor:COLOR_BLACK_666666];
    [descLabel setNumberOfLines:0];
    [self addSubview:descLabel];
    _descLabel =descLabel;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeView.mas_bottom).with.offset(11.f * g_rateWidth);
        make.left.equalTo(titleLabel);
        make.width.mas_equalTo(255.f * g_rateWidth);
    }];
    
    UIButton *detailBtn = [[UIButton alloc] init];
    [detailBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [detailBtn setTitleColor:COLOR_BLACK_666666 forState:UIControlStateNormal];
    [detailBtn setTitle:@"详细信息" forState:UIControlStateNormal];
    [detailBtn setImage:[UIImage imageNamed:@"icon_goto"] forState:UIControlStateNormal];
    [detailBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -10.f, 0.f, 10.f)];
    [detailBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, 49.f, 0.f, -49.f)];
    [detailBtn setUserInteractionEnabled:NO];
    [self addSubview:detailBtn];
    _detailBtn = detailBtn;
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(descLabel).with.offset(-5.f);;
        make.centerY.equalTo(titleLabel);
    }];
    
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(detailBtn.mas_left).with.offset(- 5.f * g_rateWidth);
    }];
    
    UIView *photoView = [[UIView alloc] init];
    [self addSubview:photoView];
    _photoView = photoView;
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.right.equalTo(self);
        make.top.equalTo(descLabel.mas_bottom).with.offset(25.f * g_rateWidth);
        make.bottom.equalTo(self).with.offset(-26.f * g_rateWidth);
        make.height.mas_equalTo(78.f * g_rateWidth);
    }];
}

- (void)setTitle:(NSString *)title {
    [_titleLabel setText:title];
}

- (void)setType:(NSString *)type {
    [_typeLabel setText:type];
}

- (void)setDesc:(NSString *)desc {
    [_descLabel setText:desc];
}

- (void)loadPhotoWithImages:(NSArray *)images {
    for (int i = 0; i < images.count; i ++) {
        UIImage *image = images[i];
        
        UIImageView *imageView;
        
        if (i < _photoView.subviews.count) {
            imageView = _photoView.subviews[i];
        }
        else {
            imageView = [[UIImageView alloc] init];
            [imageView.layer setCornerRadius:5.f];
            [imageView.layer setMasksToBounds:YES];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [_photoView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(self.photoView);
                }
                else {
                    UIView *lastImageView = self.photoView.subviews[i - 1];
                    make.left.equalTo(lastImageView.mas_right).with.offset(9.f * g_rateWidth);
                }
                
                make.top.equalTo(self.photoView);
                make.size.mas_equalTo(CGSizeMake(78.f * g_rateWidth, 78.f * g_rateWidth));
            }];
        }
        
        [imageView setImage:image];
    }
}

@end
