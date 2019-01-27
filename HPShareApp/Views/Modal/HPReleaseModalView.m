//
//  HPReleaseModalView.m
//  HPShareApp
//
//  Created by HP on 2018/11/20.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPReleaseModalView.h"

@implementation HPReleaseModalView


- (void)setupModalView:(UIView *)view {
    [self setBackgroundColor:[UIColor.whiteColor colorWithAlphaComponent:0.95f]];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:30.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:@"免费定制名片"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(50.f * g_rateHeight);
        make.left.equalTo(view).with.offset(33.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:20.f]];
    [descLabel setTextColor:COLOR_BLACK_333333];
    [descLabel setText:@"店铺拼租"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(getWidth(36.f));
        make.top.equalTo(titleLabel.mas_bottom).with.offset(35.f * g_rateWidth);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
    UIControl *ownerCard = [[UIControl alloc] init];
    [ownerCard.layer setCornerRadius:10.f];
    [ownerCard.layer setShadowColor:COLOR_RED_FF4260.CGColor];
    [ownerCard.layer setShadowOffset:CGSizeMake(0.f, 8.f)];
    [ownerCard.layer setShadowOpacity:0.3f];
    [ownerCard.layer setShadowRadius:10.f];
    [ownerCard setTag:0];
    [ownerCard addTarget:self action:@selector(onClickCardView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:ownerCard];
    [ownerCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(descLabel.mas_bottom).with.offset(10.f * g_rateHeight);
        make.size.mas_equalTo(CGSizeMake(324.f * g_rateWidth, 119.f * g_rateWidth));
    }];
    [self setupOwnerCard:ownerCard];
    
    UIControl *startupCard = [[UIControl alloc] init];
    [startupCard.layer setCornerRadius:10.f];
    [startupCard.layer setShadowColor:COLOR_BLUE_0E78f6.CGColor];
    [startupCard.layer setShadowOffset:CGSizeMake(0.f, 8.f)];
    [startupCard.layer setShadowOpacity:0.3f];
    [startupCard.layer setShadowRadius:10.f];
    [startupCard setTag:1];
    [startupCard addTarget:self action:@selector(onClickCardView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:startupCard];
    [startupCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ownerCard);
        make.top.equalTo(ownerCard.mas_bottom).with.offset(20.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(324.f * g_rateWidth, 119.f * g_rateWidth));
    }];
    [self setupStartupCard:startupCard];
    /*
    UILabel *goodsDescLabel = [[UILabel alloc] init];
    [goodsDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:20.f]];
    [goodsDescLabel setTextColor:COLOR_BLACK_333333];
    [goodsDescLabel setText:@"货品共享"];
    [view addSubview:goodsDescLabel];
    [goodsDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(getWidth(35.f));
        make.top.equalTo(startupCard.mas_bottom).with.offset(17.f * g_rateWidth);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
    UIControl *goodsCard = [[UIControl alloc] init];
    [goodsCard.layer setCornerRadius:10.f];
    [goodsCard.layer setShadowColor:COLOR_BLUE_0E78f6.CGColor];
    [goodsCard.layer setShadowOffset:CGSizeMake(0.f, 8.f)];
    [goodsCard.layer setShadowOpacity:0.3f];
    [goodsCard.layer setShadowRadius:10.f];
    [goodsCard setTag:2];
    [goodsCard addTarget:self action:@selector(onClickCardView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:goodsCard];
    [goodsCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ownerCard);
        make.top.equalTo(goodsDescLabel.mas_bottom).with.offset(9.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(324.f * g_rateWidth, 119.f * g_rateWidth));
    }];
    [self setupGoodsCard:goodsCard];*/
    
//    [self setUpDissmissBtn];
}

- (void)setUpDissmissBtn
{
    [self addSubview:self.plusBtn];
    [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(39.f), getWidth(39.f)));
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-g_bottomSafeAreaHeight - getWidth(5.f));
    }];
}

- (HPPlusBtn *)plusBtn
{
    if (!_plusBtn) {
        _plusBtn = [HPPlusBtn new];
        [_plusBtn setTitle:@"发布" forState:UIControlStateNormal];
        _plusBtn.titleLabel.font = kFont_Bold(10.f);
        [_plusBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        [_plusBtn setImage:[UIImage imageNamed:@"customizing_business_cards_close_button"] forState:UIControlStateNormal];
        [_plusBtn addTarget:self action:@selector(dissmissmodelView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusBtn;
}

- (void)dissmissmodelView
{
    [self show:NO];
}

- (void)setupGoodsCard:(UIView *)goodsView {
    UIView *view = [[UIView alloc] init];
    [view.layer setCornerRadius:10.f];
    [view.layer setMasksToBounds:YES];
    view.userInteractionEnabled = NO;
    [goodsView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(goodsView);
    }];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"release_i_have_goods"]];
    [view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20.f]];
    [titleLabel setTextColor:UIColor.whiteColor];
    [titleLabel setText:@"我有货"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(35.f * g_rateWidth);
        make.top.equalTo(view).with.offset(43.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
    [descLabel setTextColor:UIColor.whiteColor];
    [descLabel setText:@"我想发布商品信息>>"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(14.f * g_rateWidth);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [icon setImage:[UIImage imageNamed:@""]];
    [view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-33.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(82.f * g_rateWidth, 82.f * g_rateWidth));
    }];
}

- (void)setupOwnerCard:(UIView *)cardView {
    UIView *view = [[UIView alloc] init];
    [view.layer setCornerRadius:10.f];
    [view.layer setMasksToBounds:YES];
    view.userInteractionEnabled = NO;
    [cardView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(cardView);
    }];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"customizing_business_cards_pink_background"]];
    [view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20.f]];
    [titleLabel setTextColor:UIColor.whiteColor];
    [titleLabel setText:@"我有店"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(35.f * g_rateWidth);
        make.top.equalTo(view).with.offset(43.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
    [descLabel setTextColor:UIColor.whiteColor];
    [descLabel setText:@"我想发布拼租信息>>"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(14.f * g_rateWidth);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
//    UIImageView *icon = [[UIImageView alloc] init];
//    [icon setImage:[UIImage imageNamed:@"customizing_business_cards_owner's_head_portrait"]];
//    [view addSubview:icon];
//    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(view).with.offset(-33.f * g_rateWidth);
//        make.centerY.equalTo(view);
//        make.size.mas_equalTo(CGSizeMake(82.f * g_rateWidth, 82.f * g_rateWidth));
//    }];
}

- (void)setupStartupCard:(UIView *)cardView {
    UIView *view = [[UIView alloc] init];
    [view.layer setCornerRadius:10.f];
    [view.layer setMasksToBounds:YES];
    view.userInteractionEnabled = NO;
    [cardView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(cardView);
    }];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"customizing_business_cards_blue_background"]];
    [view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20.f]];
    [titleLabel setTextColor:UIColor.whiteColor];
    [titleLabel setText:@"我租店"];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(35.f * g_rateWidth);
        make.top.equalTo(view).with.offset(43.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13.f]];
    [descLabel setTextColor:UIColor.whiteColor];
    [descLabel setText:@"我想发布租店需求>>"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(14.f * g_rateWidth);
        make.height.mas_equalTo(descLabel.font.pointSize);
    }];
    
//    UIImageView *icon = [[UIImageView alloc] init];
//    [icon setImage:[UIImage imageNamed:@"customizing_business_cards_entrepreneur's_head_portrait"]];
//    [view addSubview:icon];
//    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(view).with.offset(-33.f * g_rateWidth);
//        make.centerY.equalTo(view);
//        make.size.mas_equalTo(CGSizeMake(82.f * g_rateWidth, 82.f * g_rateWidth));
//    }];
}

- (void)onClickCardView:(UIView *)view {
    [self show:NO];
    
    if (_callBack) {
        _callBack(view.tag);
    }
}

@end
