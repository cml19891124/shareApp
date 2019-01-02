//
//  HPOwnnerReleaseViewController.h
//  HPShareApp
//
//  Created by HP on 2018/12/27.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseReleaseController.h"
@class HPOwnnerReleaseViewController;
@protocol HPReleasePhotoDelegate <NSObject>

/**
 要上传的牌子图片数组
 */
- (void)backvcIn:(HPOwnnerReleaseViewController *)vc andPhotosArray:(NSArray *)photosArray;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HPOwnnerReleaseViewController : HPBaseReleaseController
@property (nonatomic, weak) id<HPReleasePhotoDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
