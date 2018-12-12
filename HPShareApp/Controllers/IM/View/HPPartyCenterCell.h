//
//  HPPartyCenterCell.h
//  HPShareApp
//
//  Created by caominglei on 2018/12/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
#import "HPPartyCenterModel.h"
@protocol HPPartyCenterCellDelegate  <NSObject>
- (void)clickTocheckMoreInfo:(HPPartyCenterModel *)model;
@end
NS_ASSUME_NONNULL_BEGIN

@interface HPPartyCenterCell : HPBaseTableViewCell
@property (nonatomic, strong) HPPartyCenterModel *model;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *notiBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *notiLine;
@property (nonatomic, strong) UIButton *imageBtn;

@property (nonatomic, weak) id<HPPartyCenterCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
