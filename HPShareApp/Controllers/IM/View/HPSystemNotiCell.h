//
//  HPSystemNotiCell.h
//  HPShareApp
//
//  Created by HP on 2018/12/12.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
#import "HPInterActiveModel.h"
@protocol HPSystemNotiCellDelegate <NSObject>

- (void)clickToCheckMoreNoti:(HPInterActiveModel *)model;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HPSystemNotiCell : HPBaseTableViewCell
@property (nonatomic, strong) HPInterActiveModel *model;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *notiBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *notiLine;
@property (nonatomic, weak) id<HPSystemNotiCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
