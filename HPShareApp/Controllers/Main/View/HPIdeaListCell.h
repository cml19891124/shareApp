//
//  HPIdeaListCell.h
//  HPShareApp
//
//  Created by HP on 2019/1/12.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
#import "HPIdeaListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPIdeaListCell : HPBaseTableViewCell

@property (nonatomic, strong) UIImageView *ideaImageview;

@property (nonatomic, strong) UILabel *ideaTitle;

@property (nonatomic, strong) UILabel *ideaSubtitle;

@property (nonatomic, strong) HPIdeaListModel *model;

@property (nonatomic, strong) UIButton *readBtn;
@end

NS_ASSUME_NONNULL_END
