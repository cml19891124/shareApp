//
//  HPTopMenuItemCell.m
//  HPShareApp
//
//  Created by HP on 2018/12/25.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTopMenuItemCell.h"
#import "HPCommonBannerData.h"

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
        self.bannerModelsArr = [NSMutableArray array];
        
        [self getHomeBannerDataList];

    }
    return self;
}


- (void)setUpTopMenuSubviews
{
    [self.contentView addSubview:self.pageView];

    [self.contentView addSubview:self.pageControl];
}

- (void)setUpCellSubviewsFrame
{
    
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self);
        make.top.mas_equalTo(getWidth(10.f));
        make.height.mas_equalTo(getWidth(120.f));
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.pageView).with.offset(-18.f * g_rateWidth);
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

- (HPBannerView *)pageView
{
    if (!_pageView) {
        _pageView = [[HPBannerView alloc] init];
        if (self.bannerImageArr && self.bannerImageArr.count) {
            [_pageView setImages:self.bannerImageArr];

        }else{
            NSArray *bannerImageArr = @[ImageNamed(@"home_page_banner"),ImageNamed(@"home_page_banner"),ImageNamed(@"home_page_banner")];

            [_pageView setImages:bannerImageArr];

        }
        
        [_pageView setImageContentMode:UIViewContentModeScaleToFill];
        [_pageView setPageSpace:getWidth(15.f)];//space + width = 每次滑动到距离
        [_pageView setPageMarginLeft:getWidth(25.f)];//距离屏幕左边的宽度
        [_pageView setPageWidth:getWidth(325.f)];
        [_pageView setPageItemSize:CGSizeMake(getWidth(325.f), getWidth(120.f))];//轮播里面卡片控件的大小。默认与width相等
        [_pageView setBannerViewDelegate:self];
        [_pageView startAutoScrollWithInterval:2];
        _pageView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.001];
    }
    return _pageView;
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

#pragma mark - HPBannerViewDelegate

- (void)bannerView:(HPBannerView *)bannerView didScrollAtIndex:(NSInteger)index {
    [_pageControl setCurrentPage:index];
    _pageView.tag = 60 + index;
    
}

- (void)getHomeBannerDataList
{
    [HPHTTPSever HPGETServerWithMethod:@"/v1/banner/list" isNeedToken:YES paraments:@{@"size":@(5)} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSArray *bannerImageArr = [HPHomeBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.bannerModelsArr addObjectsFromArray:bannerImageArr];
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
