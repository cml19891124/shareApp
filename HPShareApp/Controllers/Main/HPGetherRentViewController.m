//
//  HPGetherRentViewController.m
//  HPShareApp
//
//  Created by HP on 2019/1/30.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPGetherRentViewController.h"
#import "HPImageUtil.h"

@interface HPGetherRentViewController ()

@property (nonatomic, strong) UIView *navTitleView;

@property (nonatomic, strong) UIImageView *rentImageView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HPGetherRentViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_GRAY_FFFFFF;
    _navTitleView = [self setupNavigationBarWithTitle:@"什么是店铺拼租"];

    [self.view addSubview:self.scrollView];
      
     [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.bottom.mas_equalTo(self.view);
         make.top.mas_equalTo(self.navTitleView.mas_bottom);
     }];
    
    [self.scrollView addSubview:self.rentImageView];
     
    [self.rentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(self.scrollView);
     }];
    
}

- (UIImageView *)rentImageView{
    if (!_rentImageView) {
        _rentImageView = [UIImageView new];
        _rentImageView.image = ImageNamed(@"rentImage");
    }
    return _rentImageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        
    }
    return _scrollView;
}
@end
