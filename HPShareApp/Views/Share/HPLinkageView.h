//
//  HPLinkageView.h
//  HPShareApp
//
//  Created by Jay on 2018/12/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"
#import "HPLinkageData.h"

@class HPLinkageView;
@protocol HPLinkageViewDelegate <NSObject>

@optional
- (void)linkageView:(HPLinkageView *)linkageView didSelectParentIndex:(NSInteger)pIndex childIndex:(NSInteger)cIndex withChildModel:(NSObject *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HPLinkageView : HPBaseView

@property (nonatomic, assign) CGFloat leftTableWidth;

@property (nonatomic, strong) UIColor *leftTableColor;

@property (nonatomic, assign) CGFloat leftHeaderHeight;

@property (nonatomic, assign) CGFloat leftFooterHeight;

@property (nonatomic, assign) CGFloat leftCellHeight;

@property (nonatomic, assign) CGFloat leftTextMarginLeft;

@property (nonatomic, strong) UIFont *leftTextFont;

@property (nonatomic, strong) UIColor *leftTextColor;

@property (nonatomic, strong) UIColor *leftTextSelectedColor;

@property (nonatomic, strong) UIColor *rightTableColor;

@property (nonatomic, assign) CGFloat rightHeaderHeight;

@property (nonatomic, assign) CGFloat rightFooterHeight;

@property (nonatomic, assign) CGFloat rightCellHeight;

@property (nonatomic, assign) CGFloat rightTextMarginLeft;

@property (nonatomic, strong) UIFont *rightTextFont;

@property (nonatomic, strong) UIColor *rightTextColor;

@property (nonatomic, strong) UIColor *rightTextSelectedColor;

@property (nonatomic, strong) UIImage *selectedIcon;

@property (nonatomic, assign) CGFloat selectedIconMarginRight;

@property (nonatomic, weak) id <HPLinkageViewDelegate> delegate;

- (instancetype)initWithData:(HPLinkageData *)data;

- (void)selectCellAtParentIndex:(NSInteger)pIndex childIndex:(NSInteger)cIndex;

@end

NS_ASSUME_NONNULL_END
