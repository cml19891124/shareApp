//
//  HPCommentViewController.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/4.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCommentViewController.h"

#import "MyTextView.h"

#import "HOOrderListModel.h"

#import "HPSingleton.h"

@interface HPCommentViewController ()

@property (strong, nonatomic) HOOrderListModel *model;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic) UIView *starView;

@property (strong, nonatomic) UILabel *scoreLabel;

@property (strong, nonatomic) UIView *commentView;

@property (strong, nonatomic) UILabel *dealLabel;

@property (nonatomic, strong) MyTextView *textView;

@property (strong, nonatomic) UIButton *releaseBtn;

@property (strong, nonatomic) NSNumber *currentStar;
@end

@implementation HPCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_GRAY_FFFFFF;
    
    self.model = self.param[@"model"];
    
    if (self.model.order.status.integerValue == 11) {
        self.textView.userInteractionEnabled = NO;
    }
    [self setUpCommentSubviews];
    
    [self setUpCommentSubviewsMasonry];

}


- (void)setUpCommentSubviews
{
    [self.view addSubview:self.headerView];
    
    [self.headerView addSubview:self.backBtn];
    
    [self.headerView addSubview:self.titleLabel];
    
    [self.view addSubview:self.starView];
    
    [self.starView addSubview:self.scoreLabel];
    
    for (NSInteger j = 0; j < 5; j++) {
        CGFloat starWH = 16;
        
        CGFloat margin = 14;
        UIButton *star = [UIButton buttonWithType:UIButtonTypeCustom];

        star.tag = j;
        [star setBackgroundImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
        [star setBackgroundImage:[UIImage imageNamed:@"full"] forState:UIControlStateSelected];
        star.adjustsImageWhenHighlighted = NO;
        [star addTarget:self action:@selector(changeState: with:) forControlEvents:UIControlEventTouchDown];
        star.tag = 5000+j;
        [self.starView addSubview:star];
        
        [star mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(starWH);
            make.left.mas_equalTo(self.scoreLabel.mas_right).offset(getWidth(25.f) + j * (starWH + margin));
            make.centerY.mas_equalTo(self.starView);
        }];
    }
    
    [self.view addSubview:self.commentView];

    [self.commentView addSubview:self.dealLabel];

    [self.commentView addSubview:self.textView];
    
    if ([HPSingleton sharedSingleton].identifyTag == 0) {
        
        if (_model.order.status.integerValue == 11) {
            self.textView.userInteractionEnabled = YES;
        }
        self.textView.placeholder = @"    请发表一下此次合作的感受吧...";
    }else{
        if (_model.order.status.integerValue == 11) {
            self.textView.userInteractionEnabled = NO;
        }
        self.textView.placeholder = @"    这是一次比较满意的合作，总体合作下来就一句话，和您合作真实太愉快啦";
    }

    [self.view addSubview:self.releaseBtn];

    UIButton *btn = [self.view viewWithTag:5004];
    [self changeState:btn with:5];
}

- (void)setUpCommentSubviewsMasonry
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(g_statusBarHeight + 44);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.width.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(g_statusBarHeight + 13.f);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(48.f));
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(g_statusBarHeight + 44 + 15.f);
        make.right.mas_equalTo(getWidth(-15.f));
    }];
    
    CGFloat scoreW = BoundWithSize(self.scoreLabel.text, kScreenWidth, 16.f).size.width;
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.scoreLabel.font.pointSize);
        make.left.mas_equalTo(getWidth(15.f));
        make.centerY.mas_equalTo(self.starView);
        make.width.mas_equalTo(scoreW);
    }];
    
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(200.f));
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(self.starView.mas_bottom).offset(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
    }];
    
    [self.dealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.height.mas_equalTo(self.dealLabel.font.pointSize);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.commentView);
        make.top.mas_equalTo(self.dealLabel.mas_bottom).offset(getWidth(15.f));
    }];
    
    [self.releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(44.f));
        make.left.width.mas_equalTo(self.starView);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(getWidth(-15.f));
    }];
}

- (UILabel *)dealLabel
{
    if (!_dealLabel) {
        _dealLabel = [UILabel new];
        _dealLabel.text = @"交易评价";
        _dealLabel.textColor = COLOR_BLACK_333333;
        _dealLabel.textAlignment = NSTextAlignmentLeft;
        _dealLabel.font = kFont_Medium(16.f);
    }
    return _dealLabel;
}

- (UIButton *)releaseBtn
{
    if (!_releaseBtn) {
        _releaseBtn = [UIButton new];
        _releaseBtn.backgroundColor = COLOR_RED_EA0000;
        _releaseBtn.layer.cornerRadius = 2.f;
        _releaseBtn.layer.masksToBounds = YES;
        [_releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
        _releaseBtn.titleLabel.font = kFont_Medium(16.f);
        [_releaseBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        _releaseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_releaseBtn addTarget:self action:@selector(releaseCommentWords:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _releaseBtn;
}
- (UIView *)commentView
{
    if (!_commentView) {
        _commentView = [UIView new];
        _commentView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _commentView;
}

- (MyTextView *)textView
{
    if (!_textView) {
        _textView = [MyTextView new];
        _textView.backgroundColor = COLOR_GRAY_F9FAFD;
        _textView.textColor = COLOR_GRAY_666666;
        _textView.placeholderColor = COLOR_GRAY_999999;
        _textView.font = kFont_Regular(14.f);
        _textView.textContainerInset = UIEdgeInsetsMake(7, 16, 0, 16);
        _textView.tintColor = COLOR_RED_EA0000;
    }
    return _textView;
}

- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [UILabel new];
        _scoreLabel.text = @"交易评分";
        _scoreLabel.textColor = COLOR_BLACK_333333;
        _scoreLabel.textAlignment = NSTextAlignmentLeft;
        _scoreLabel.font = kFont_Medium(16.f);
        
    }
    return _scoreLabel;
}

- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [UIImageView new];
        _headerView.image = ImageNamed(@"order_head");
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:ImageNamed(@"fanhui_wh") forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(18.f), getWidth(15.f), getWidth(18.f), 0)];
        [_backBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = COLOR_GRAY_FFFFFF;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kFont_Bold(18.f);
        _titleLabel.text = @"订单评价";
    }
    return _titleLabel;
}

- (UIView *)starView
{
    if (!_starView) {
        _starView = [UIView new];
        _starView.backgroundColor = COLOR_GRAY_F9FAFD;
    }
    return _starView;
}

- (void)changeState:(UIButton *)star with:(NSInteger)j
{
    [self.view endEditing:YES];
    NSInteger i = (star.tag)/5000;
    self.currentStar = @(j);
    for (NSInteger j=0; j<5; j++) {
        if (j<=star.tag-5000*i) {
            ((UIButton*)[self.view viewWithTag:5000*i+j]).selected = YES;
        }
        else
        {
            ((UIButton*)[self.view viewWithTag:5000*i+j]).selected = NO;
        }
    }
    
}

- (void)releaseCommentWords:(UIButton *)button
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"context"] = self.textView.text;
    dic[@"orderId"] = self.model.order.orderId;
    dic[@"star"] = self.currentStar.stringValue;

    [HPHTTPSever HPGETServerWithMethod:@"/v1/orderReview/orderReview" isNeedToken:YES paraments:dic complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [HPProgressHUD alertMessage:MSG];

        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}
@end
