//
//  HPPageControlFactory.h
//  HPShareApp
//
//  Created by HP on 2018/12/1.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPPageControl.h"

typedef NS_ENUM(NSInteger, HPPageControlStyle) {
    HPPageControlStyleCirlcle = 0,
    HPPageControlStyleRoundedRect
};

NS_ASSUME_NONNULL_BEGIN

@interface HPPageControlFactory : NSObject

+ (HPPageControl *)createPageControlByStyle:(HPPageControlStyle)style;

@end

NS_ASSUME_NONNULL_END
