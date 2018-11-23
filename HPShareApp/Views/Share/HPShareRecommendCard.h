//
//  HPShareRecommendCard.h
//  HPShareApp
//
//  Created by HP on 2018/11/16.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseControl.h"

typedef NS_ENUM(NSInteger, HPShareRecommendCardType) {
    HPShareRecommendCardTypeStartup = 0,
    HPShareRecommendCardTypeOwner
};

NS_ASSUME_NONNULL_BEGIN

@interface HPShareRecommendCard : HPBaseControl

- (void)setTitle:(NSString *)title;

- (void)setTrade:(NSString *)trade;

- (void)setRentTime:(NSString *)rentTime;

- (void)setArea:(NSString *)area;

- (void)setPrice:(NSString *)price;

- (void)setTagType:(HPShareRecommendCardType)type;

@end

NS_ASSUME_NONNULL_END
