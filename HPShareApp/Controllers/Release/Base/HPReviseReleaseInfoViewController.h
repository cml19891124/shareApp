//
//  HPReviseReleaseInfoViewController.h
//  HPShareApp
//
//  Created by HP on 2018/12/21.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseReleaseController.h"
@class HPReviseReleaseInfoViewController;
@protocol HPShareSpaceInfoDelegate <NSObject>

- (void)backvcIn:(HPReviseReleaseInfoViewController *)vc andShareInfo:(NSString *)shareSpace andShareTime:(NSString *)shareTime andIndustry:(NSString *)industry andShareType:(NSString *)type andShareRent:(NSString *)rent andShareRentAmount:(NSString *)amount;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HPReviseReleaseInfoViewController : HPBaseReleaseController
@property (nonatomic, weak) id<HPShareSpaceInfoDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
