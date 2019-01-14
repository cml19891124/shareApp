//
//  HPIdeaDetailViewController.m
//  HPShareApp
//
//  Created by caominglei on 2019/1/12.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPIdeaDetailViewController.h"
#import "HPIdeaListModel.h"
#import "HPIdeaDetailModel.h"

@interface HPIdeaDetailViewController ()

@property (nonatomic, strong) HPIdeaDetailModel *model;

@property (nonatomic, strong) UIView *navTitleView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *contentView;

@end

@implementation HPIdeaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_GRAY_FFFFFF;
    _navTitleView = [self setupNavigationBarWithTitle:@"文章详情"];
    [HPProgressHUD alertWithLoadingText:@"加载数据中..."];

    //获取文章详情信息
    [self richQueryDetailInfo];
    
    [self setUpSubviewsUI];
    [self setUpSubviewsUIMasonry];

}

- (void)setUpSubviewsUI
{
    [self.view addSubview:self.contentView];
}

- (void)setUpSubviewsUIMasonry
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navTitleView.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(kScreenHeight - g_statusBarHeight - 44.f);
    }];
}

#pragma mark - 获取文章详情信息
- (void)richQueryDetailInfo
{
    HPIdeaListModel *model = self.param[@"model"];
    self.titleLabel.text = model.title;
    [HPHTTPSever HPGETServerWithMethod:@"/v1/rich/queryDetail" isNeedToken:YES paraments:@{@"articleId":model.articleId} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            self.model = [HPIdeaDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            NSString *context = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",kScreenWidth/3,self.model.context];
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]
                                                   initWithData:[context dataUsingEncoding:
                                                                 NSUnicodeStringEncoding]
                                                   options:@{
                                                             NSDocumentTypeDocumentAttribute:
                                                                 NSHTMLTextDocumentType
                                                             }
                                                   documentAttributes:nil error:nil];
//            HPLog(@"员额还给你-----:%@",self.model.context);
            
//            HPLog(@"string-----:%@",attrStr.string);

            self.contentView.attributedText = attrStr;
            [HPProgressHUD alertWithFinishText:@"加载完成"];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
            
}

- (UITextView *)contentView
{
    if (!_contentView) {
        _contentView = [UITextView new];
        _contentView.textColor = COLOR_BLACK_333333;
        _contentView.font = kFont_Medium(16.f);
        _contentView.editable = NO;
        _contentView.textAlignment = NSTextAlignmentCenter;
        //高度自适应，前提不设置宽度，高度自适应
        [_contentView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
    }
    return _contentView;
}

@end
