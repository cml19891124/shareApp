//
//  HPUpdateVersionView.h
//  HPShareApp
//
//  Created by HP on 2019/2/21.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseDialogView.h"
typedef void (^UpdateVersionBlock)(void);
typedef void (^CloseVersionViewBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HPUpdateVersionView : HPBaseDialogView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *desLabel;

@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) UIButton *updateBtn;

@property (nonatomic, copy) UpdateVersionBlock updateBlock;

@property (nonatomic, copy) CloseVersionViewBlock closeBlcok;

@property (nonatomic, strong) UIView *whiteLine;

@property (nonatomic, strong) UIButton *deleteBtn;

@end

NS_ASSUME_NONNULL_END
