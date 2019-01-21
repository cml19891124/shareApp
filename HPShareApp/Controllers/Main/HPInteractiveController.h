//
//  HPInteractiveController.h
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseShareListController.h"
#import "JCHATChatTable.h"


NS_ASSUME_NONNULL_BEGIN

@interface HPInteractiveController : HPBaseViewController
{
    
    NSInteger cacheCount;
    BOOL isGetingAllConversation;
}
@property (nonatomic, strong) UIImageView *addBgView;

@end

NS_ASSUME_NONNULL_END
