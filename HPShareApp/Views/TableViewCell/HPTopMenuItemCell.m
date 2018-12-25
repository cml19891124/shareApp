//
//  HPTopMenuItemCell.m
//  HPShareApp
//
//  Created by HP on 2018/12/25.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTopMenuItemCell.h"
#import "HPMenuCellbutton.h"

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
        self.bannerImageArr = @[ImageNamed(@"boot_page_1"),ImageNamed(@"boot_page_2"),ImageNamed(@"boot_page_3")];
        [self setUpTopMenuSubviews];
        [self setUpCellSubviewsFrame];
    }
    return self;
}

- (void)setUpTopMenuSubviews
{
    [self.contentView addSubview:self.bannerView];
    [self.bannerView addSubview:self.iCarousel];
    [self setupCarouseViewPlus];
    [self setUpMenuButtonViews];
}

#pragma mark - 轮播图2设置
- (void)setupCarouseViewPlus
{
    // 图片数组，可以是其他的资源，设置到轮播图上就可以
    NSMutableArray *imagerray = [NSMutableArray array];
    for (int i = 0; i < self.bannerImageArr.count; i++)
    {
        // 先用空白页测试
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]];
        [imagerray addObject:image];
    }
    
    [self.iCarousel setupSubviewPages:imagerray withCallbackBlock:^(NSInteger pageIndex) {

    }];
}
- (void)setUpCellSubviewsFrame
{
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(325.f), getWidth(140.f)));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(getWidth(5.f));
    }];
    
    [self.iCarousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.bannerView);
    }];
}

- (UIView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [UIView new];
        _bannerView.backgroundColor = COLOR_GRAY_FFFFFF;
        _bannerView.layer.cornerRadius = 8.f;
        _bannerView.layer.masksToBounds = YES;
        //        view.layer.masksToBounds = YES;
        _bannerView.layer.shadowColor = COLOR_GRAY_BBBBBB.CGColor;
        _bannerView.layer.shadowOffset = CGSizeMake(0, 1);
        _bannerView.layer.shadowOpacity = 0.7;
    }
    return _bannerView;
}

- (CarouseViewPlus *)iCarousel
{
    if (!_iCarousel) {
        _iCarousel = [CarouseViewPlus new];
    }
    return _iCarousel;
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
            make.top.mas_equalTo(self.bannerView.mas_bottom).offset(getWidth(12.f) + (getWidth(77.f) + getWidth(21.f)) * row);
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
/*
#pragma mark - iCarouselDataSouce

-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.bannerImageArr.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - getWidth(50.f), getWidth(150.f))];
        view.backgroundColor = COLOR_GRAY_FFFFFF;
        view.contentMode = UIViewContentModeCenter;
        view.layer.cornerRadius = 8.f;
//        view.layer.masksToBounds = YES;
        view.layer.shadowColor = COLOR_GRAY_BBBBBB.CGColor;
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowOpacity = 0.7;
        UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:view.bounds];
        bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        bannerImageView.image = self.bannerImageArr[index];
        bannerImageView.layer.cornerRadius = 8.f;
        bannerImageView.layer.masksToBounds = YES;
        [view addSubview:bannerImageView];
    }
    
    // 支持循环的 可用（最后一个的下一个是第0个）
    if (index == [self.bannerImageArr count] - 1) {
        [carousel scrollToItemAtIndex:0 animated:YES];
    } else {
        [carousel scrollToItemAtIndex:index+1 animated:YES];
    }
    
    return view;
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.03;
    }
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (self.selectItemInICarouselBlock) {
        self.selectItemInICarouselBlock(self.bannerImageArr[index]);
    }
}*/
@end
