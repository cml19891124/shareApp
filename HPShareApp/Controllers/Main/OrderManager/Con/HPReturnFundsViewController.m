//
//  HPReturnFundsViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/12.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPReturnFundsViewController.h"

#import "HPReturnModel.h"

@interface HPReturnFundsViewController ()

@property (nonatomic, strong) HPReturnModel *model;

@end

@implementation HPReturnFundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor: COLOR_GRAY_FFFFFF];

    [self setupNavigationBarWithTitle:@"退款详情"];
    
    [self getReturnFundsinfo];
    
    [self setUpReturnFundsSubviews];
}

- (void)setUpReturnFundsSubviews
{
    
}

- (void)getReturnFundsinfo
{
    [HPHTTPSever HPPostServerWithMethod:@"/v1/wxpay/refund" paraments:@{} needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            self.model = [HPReturnModel mj_objectWithKeyValues:DATA];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
@end
