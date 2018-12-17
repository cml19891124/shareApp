//
//  HPHeaderTableView.h
//  HPShareApp
//
//  Created by Jay on 2018/12/16.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HPScrollViewDirection) {
    HPScrollViewDirectionUnknown = 0,
    HPScrollViewDirectionUp,
    HPScrollViewDirectionDown
};

NS_ASSUME_NONNULL_BEGIN

@interface HPHeaderTableView : UITableView

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) BOOL isTouch;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, assign) HPScrollViewDirection direction;

@end

NS_ASSUME_NONNULL_END
