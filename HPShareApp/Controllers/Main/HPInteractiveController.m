//
//  HPInteractiveController.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPInteractiveController.h"
#import "HPPageView.h"

@interface HPInteractiveController () <HPPageViewDelegate>

@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation HPInteractiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageArray = @[[UIImage imageNamed:@"banner_share_space_red"],
                    [UIImage imageNamed:@"banner_share_space_purple"],
                    [UIImage imageNamed:@"banner_share_good_red"],
                    [UIImage imageNamed:@"banner_share_good_purple"],
                    [UIImage imageNamed:@"banner_share_shop_red"],
                    [UIImage imageNamed:@"banner_share_shop_purple"]];    
    [self setupUI];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupUI {
    HPPageView *pageView = [[HPPageView alloc] init];
    [pageView setBackgroundColor:UIColor.grayColor];
    [pageView setDelegate:self];
    [self.view addSubview:pageView];
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.height.mas_equalTo(130.f * g_rateWidth);
        make.centerY.equalTo(self.view);
    }];
}

#pragma mark - HPPageViewDelegate

- (NSInteger)pageNumberOfPageView:(HPPageView *)pageView {
    return _imageArray.count;
}

- (UIView *)pageView:(HPPageView *)pageView viewAtPageIndex:(NSInteger)index {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeCenter];
    [imageView setImage:_imageArray[index]];
    return imageView;
}

@end
