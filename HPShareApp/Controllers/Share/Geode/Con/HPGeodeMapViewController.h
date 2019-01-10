//
//  HPGeodeMapViewController.h
//  HPShareApp
//
//  Created by HP on 2019/1/7.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseViewController.h"
typedef NS_ENUM(NSInteger, HPRouteType) {
    HPRouteTypeWalking = 200,
    HPRouteTypeRiding,
    HPRouteTypeDriving,
    HPRouteTypeBus,
    HPRouteTypeRailway
};
NS_ASSUME_NONNULL_BEGIN

@interface HPGeodeMapViewController : HPBaseViewController

@end

NS_ASSUME_NONNULL_END
