//
//  HPIdeaExampleItem.h
//  HPShareApp
//
//  Created by HP on 2018/11/26.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPIdeaExampleItem : HPBaseView

@property (nonatomic, weak, readonly) UIButton *detailBtn;

- (void)setTitle:(NSString *)title;

- (void)setType:(NSString *)type;

- (void)setDesc:(NSString *)desc;

- (void)loadPhotoWithImages:(NSArray *)images;

@end

NS_ASSUME_NONNULL_END
