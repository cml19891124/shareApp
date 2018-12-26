//
//  HPHotImageView.h
//  HPShareApp
//
//  Created by HP on 2018/12/26.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

@interface HPHotImageView : UIImageView
@property (nonatomic, strong) UILabel *areaLabel;

/**
 区域标题
 */
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame andAreaString:(NSString *)areaString;
@end

NS_ASSUME_NONNULL_END
