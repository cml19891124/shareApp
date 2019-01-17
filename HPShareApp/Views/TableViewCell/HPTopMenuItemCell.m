//
//  HPTopMenuItemCell.m
//  HPShareApp
//
//  Created by HP on 2018/12/25.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTopMenuItemCell.h"
#import "HPMenuCellbutton.h"
#import "HPHomeBannerModel.h"
#import "HPCommonBannerData.h"
#import "HPSingleton.h"

@implementation HPTopMenuItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bannerImageArr = [NSMutableArray array];

        [self getHomeBannerDataList];

    }
    return self;
}


- (void)setUpTopMenuSubviews
{
    [self.contentView addSubview:self.iCarousel];

    [self.contentView addSubview:self.pageControl];
    
    [self setUpMenuButtonViews];
}

- (void)setUpCellSubviewsFrame
{
    
    [self.iCarousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self);
        make.top.mas_equalTo(getWidth(10.f));
        make.height.mas_equalTo(getWidth(120.f));
    }];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.iCarousel).with.offset(-18.f * g_rateWidth);
    }];
}

- (UIView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [UIView new];
        _bannerView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.001];;
        _bannerView.layer.cornerRadius = 8.f;
        _bannerView.layer.masksToBounds = YES;
        _bannerView.layer.shadowColor = COLOR_GRAY_BBBBBB.CGColor;
        _bannerView.layer.shadowOffset = CGSizeMake(0, 1);
        _bannerView.layer.shadowOpacity = 0.7;
    }
    return _bannerView;
}

- (HPBannerView *)iCarousel
{
    if (!_iCarousel) {
        _iCarousel = [[HPBannerView alloc] init];
        if (self.bannerImageArr && self.bannerImageArr.count) {
            [_iCarousel setImages:self.bannerImageArr];

        }else{
            NSArray *bannerImageArr = @[ImageNamed(@"home_page_banner"),ImageNamed(@"home_page_banner"),ImageNamed(@"home_page_banner")];

            [_iCarousel setImages:bannerImageArr];

        }
        
        [_iCarousel setImageContentMode:UIViewContentModeScaleToFill];
        [_iCarousel setPageSpace:getWidth(15.f)];//space + width = 每次滑动到距离
        [_iCarousel setPageMarginLeft:getWidth(25.f)];//距离屏幕左边的宽度
        [_iCarousel setPageWidth:getWidth(325.f)];
        [_iCarousel setPageItemSize:CGSizeMake(getWidth(325.f), getWidth(120.f))];//轮播里面卡片控件的大小。默认与width相等
        [_iCarousel setBannerViewDelegate:self];
        [_iCarousel startAutoScrollWithInterval:2];
        _iCarousel.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.001];
    }
    return _iCarousel;
}

- (HPPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [HPPageControlFactory createPageControlByStyle:HPPageControlStyleRoundedRect];
        [_pageControl setNumberOfPages:self.bannerImageArr.count];
        [_pageControl setCurrentPage:0];
    }
    return _pageControl;
}

-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    
    return result;
    
}

- (void)setUpMenuButtonViews
{
    NSArray *menuImageArr = @[@"home_page_store_ sharing",@"home_page_lobby_ sharing",@"home_page_other_sharing",@"home_page_map",@"home_page_stock_purchase",@"home_page_shelf_rental",@"home_page_used_shelves",@"home_page_new_store_opens"];
    NSArray *menuTitleArr = @[@"店铺共享",@"大堂共享",@"其他共享",@"地图找店",@"进货",@"货架出租",@"二手货架",@"新店合开"];
    for (int i = 0; i < menuImageArr.count; i++) {
        HPMenuCellbutton *menuBtn = [HPMenuCellbutton new];
        [menuBtn setImage:ImageNamed(menuImageArr[i]) forState:UIControlStateNormal];
        [menuBtn setTitle:menuTitleArr[i] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(clickMenuItem:) forControlEvents:UIControlEventTouchUpInside];
        menuBtn.tag = 50 + i;
        CGFloat row = i/4;
        CGFloat col = i%4;
        [self addSubview:menuBtn];
        CGFloat margin = (kScreenWidth - getWidth(52.f) * 4 - getWidth(26.f) * 2)/3;
        [menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(26.f) + (getWidth(52.f) + margin) * col);
            make.top.mas_equalTo(self.iCarousel.mas_bottom).offset(getWidth(25.f) + (getWidth(77.f) + getWidth(21.f)) * row);
            make.size.mas_equalTo(CGSizeMake(getWidth(52.f), getWidth(77.f)));
        }];
    }

}

- (void)clickMenuItem:(UIButton *)button
{
    if (self.clickMenuItemBlock) {
        self.clickMenuItemBlock(button.tag);
    }
}
#pragma mark - HPBannerViewDelegate

- (void)bannerView:(HPBannerView *)bannerView didScrollAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
}



- (void)getHomeBannerDataList
{
    [HPHTTPSever HPGETServerWithMethod:@"/v1/banner/list" isNeedToken:YES paraments:@{@"size":@(5)} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSArray *bannerImageArr = [HPHomeBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            for (int i = 0;i < bannerImageArr.count;i++) {
                HPHomeBannerModel *model = bannerImageArr[i];
                if ([model.imgUrl containsString:@"http"]) {
                    UIImage *image = [self getImageFromURL:model.imgUrl];
                    if (image) {
                        [self.bannerImageArr addObject:image];
                    }else{
                        [self.bannerImageArr addObject:ImageNamed(@"home_page_banner")];
                    }

                }else{//用本地图片 替换并填充
                    [self.bannerImageArr addObject:ImageNamed(@"home_page_banner")];

                }
                if (self.bannerImageArr.count <= 1) {//用本地图片填充两张
                    [self.bannerImageArr addObject:ImageNamed(@"home_page_banner")];
                    [self.bannerImageArr addObject:ImageNamed(@"home_page_banner")];

                }
            }
            
            [self setUpTopMenuSubviews];
            [self setUpCellSubviewsFrame];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
    
}

@end
