//
//  HPInviteSBGiftsController.m
//  HPShareApp
//
//  Created by HP on 2018/12/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPInviteSBGiftsController.h"

@interface HPInviteSBGiftsController ()

@end

@implementation HPInviteSBGiftsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"邀请礼包"];
    UIImageView *giftsView = [[UIImageView alloc] init];
    giftsView.image = ImageNamed(@"gifts");
    [self.view addSubview:giftsView];
    [giftsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(410.f), getWidth(298.f)));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(getWidth(260.f));
    }];
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.text = @"一大波优惠即将来袭~";
    tipsLabel.textColor = COLOR_BLACK_666666;
    tipsLabel.font = kFont_Medium(16.f);
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(24.f));
        make.width.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(giftsView.mas_top).offset(getWidth(244.f));
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
