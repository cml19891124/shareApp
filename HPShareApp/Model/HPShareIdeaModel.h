//
//  HPShareIdeaModel.h
//  HPShareApp
//
//  Created by Jay on 2018/12/19.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPShareIdeaModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, copy) NSString *firstPlace;

@property (nonatomic, copy) NSString *secondPlace;

@property (nonatomic, copy) NSString *beforeFirstDesc;

@property (nonatomic, copy) NSString *beforeSecondDesc;

@property (nonatomic, copy) NSString *afterFirstDesc;

@property (nonatomic, copy) NSString *afterSecondDesc;

@end

NS_ASSUME_NONNULL_END
