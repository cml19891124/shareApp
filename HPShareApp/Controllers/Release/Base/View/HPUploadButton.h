//
//  HPUploadButton.h
//  HPShareApp
//
//  Created by HP on 2018/12/27.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "HPGlobalVariable.h"
#import "Masonry.h"
typedef void (^ClickDeleteBtnblock) (NSInteger deleteIndex);

NS_ASSUME_NONNULL_BEGIN

@interface HPUploadButton : UIButton

/**
 删除图片按钮
 */
//@property (nonatomic, strong) UIButton *deleteBtn;

/**
 封面label
 */
@property (nonatomic, strong) UILabel *faceLabel;

@property (nonatomic, copy) ClickDeleteBtnblock clickDeleteBtnblock;
@end

NS_ASSUME_NONNULL_END
