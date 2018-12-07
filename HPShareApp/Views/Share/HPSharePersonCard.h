//
//  HPSharePersonCard.h
//  HPShareApp
//
//  Created by HP on 2018/11/23.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HPSharePersonCardDelegate <NSObject>

/**
 点击关注某人
 */
- (void)clickFollowBtnToFocusSB;

@end
@interface HPSharePersonCard : HPBaseView

@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, weak) id<HPSharePersonCardDelegate> delegate;
- (void)setPortrait:(UIImage *)image;

- (void)setUserName:(NSString *)userName;

- (void)setSignature:(NSString *)signature;

- (void)setDescription:(NSString *)desc;

- (void)setCompany:(NSString *)company;

@end

NS_ASSUME_NONNULL_END
