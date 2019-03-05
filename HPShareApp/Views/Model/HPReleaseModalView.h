//
//  HPReleaseModalView.h
//  HPShareApp
//
//  Created by HP on 2018/11/20.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"
#import "HPPlusBtn.h"

typedef NS_ENUM(NSInteger, HPReleaseCardType) {
    HPReleaseCardTypeOwner = 0,
    HPReleaseCardTypeStartup,
    HPReleaseCardTypeGoods
};

typedef void(^HPReleaseCardCallBack)(HPReleaseCardType type);

NS_ASSUME_NONNULL_BEGIN

@interface HPReleaseModalView : HPBaseModalView

@property (nonatomic, strong) HPReleaseCardCallBack callBack;

@property (strong, nonatomic) HPPlusBtn *plusBtn;

@end

NS_ASSUME_NONNULL_END
