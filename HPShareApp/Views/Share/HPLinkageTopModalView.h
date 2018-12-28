//
//  HPLinkageTopModalView.h
//  HPShareApp
//
//  Created by Jay on 2018/12/27.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"
#import "HPLinkageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPLinkageTopModalView : HPBaseModalView

@property (nonatomic, weak) id <HPLinkageViewDelegate> delegate;

- (instancetype)initWithData:(HPLinkageData *)data;

- (void)selectCellAtParentIndex:(NSInteger)pIndex childIndex:(NSInteger)cIndex;

@end

NS_ASSUME_NONNULL_END
