//
//  HPIdeaListModel.m
//  HPShareApp
//
//  Created by HP on 2019/1/12.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPIdeaListModel.h"
#import "MJExtension.h"

@implementation HPIdeaListModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"pictures":HPIdeaPicturesModel.class};
}
@end

@implementation HPIdeaPicturesModel : NSObject


@end
