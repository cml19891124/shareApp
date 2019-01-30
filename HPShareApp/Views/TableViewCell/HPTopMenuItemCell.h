//
//  HPTopMenuItemCell.h
//  HPShareApp
//
//  Created by HP on 2018/12/25.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
#import "HPHomeBannerView.h"
#import "HPPageControl.h"
#import "HPPageControlFactory.h"
#import "HPHomeBannerModel.h"
#import "HPMenuCellbutton.h"

typedef void (^SelectItemInICarouselBlock)(NSString * _Nullable model);

typedef void (^BannerClickTypeBlock)(HPHomeBannerModel *model,NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface HPTopMenuItemCell : HPBaseTableViewCell<HPHomeBannerViewDelegate>

@property (nonatomic, strong) UIView *bannerView;

@property (nonatomic, copy) SelectItemInICarouselBlock selectItemInICarouselBlock;

@property (strong, nonatomic) HPHomeBannerView *pageView;
@property (nonatomic, strong) HPPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *bannerImageArr;

@property (strong, nonatomic) NSMutableArray *bannerModelsArr;

@property (nonatomic, strong) HPMenuCellbutton * menuBtn;

@property (nonatomic, copy) BannerClickTypeBlock bannerClickTypeBlock;
@end

NS_ASSUME_NONNULL_END
