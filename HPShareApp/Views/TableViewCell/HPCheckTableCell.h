//
//  HPCheckTableCell.h
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPCheckTableCell : HPBaseTableViewCell

@property (nonatomic) BOOL isSingle;

@property (nonatomic, readonly) BOOL isCheck;

@property (nonatomic, strong) NSString *title;

- (void)setCheck:(BOOL)isCheck;

@end

NS_ASSUME_NONNULL_END
