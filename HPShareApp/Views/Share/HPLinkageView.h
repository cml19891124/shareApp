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

@property (nonatomic, weak) id <HPLinkageViewDelegate> delegate;

- (instancetype)initWithData:(HPLinkageData *)data;

- (void)selectCellAtParentIndex:(NSInteger)pIndex childIndex:(NSInteger)cIndex;

@end

NS_ASSUME_NONNULL_END
