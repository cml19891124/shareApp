//
//  HPAlertAction.m
//  HPShareApp
//
//  Created by HP on 2018/11/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAlertAction.h"

@implementation HPAlertAction

- (instancetype)initWithTitle:(NSString *)title completion:(Completion)completion {
    self = [self init];
    if (self) {
        _title = title;
        _completion = completion;
    }
    return self;
}

@end
