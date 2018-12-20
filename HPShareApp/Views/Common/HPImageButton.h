//
//  HPImageButton.h
//  HPShareApp
//
//  Created by Jay on 2018/12/19.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 原UIButton的ImageView会根据Image大小确定size然后居中，无法满足随Button的大小改变ImageView大小的需求，该子类则根据UIButton的大小确定UIImageVIew大小，然后拉伸图片
 */
@interface HPImageButton : UIButton

@end

NS_ASSUME_NONNULL_END
