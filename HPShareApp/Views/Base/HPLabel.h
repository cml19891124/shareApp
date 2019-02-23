//
//  HPLabel.h
//  HPShareApp
//
//  Created by HP on 2019/2/23.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    VerticalAlignmentTop = 0,
    VerticalAlignmentMidele,
    VerticalAlignmentBottom,
    VerticalAlignmentMax
}VerticalAlignment;
NS_ASSUME_NONNULL_BEGIN

@interface HPLabel : UILabel
{
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic, assign)VerticalAlignment verticalAlignment;
@end

NS_ASSUME_NONNULL_END
