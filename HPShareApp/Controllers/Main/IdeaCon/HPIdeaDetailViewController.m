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

@interface HPIdeaDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) HPIdeaDetailModel *model;

@property (nonatomic, strong) UIView *navTitleView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *contentView;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UILabel *readNumLabel;

@end

@implementation HPIdeaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_GRAY_FFFFFF;
    if (IPHONE_HAS_NOTCH) {//iPhone X出现后，除了对屏幕做各种适配，在跳转到webview的过程中发现底部出现一个黑色区域，其他机型则没有---在iphoneX的时候设置webview.scrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;这个方法目前我感觉是最靠谱，直接让webview放弃适配安全区域，当然写上了这个，在webview滑到底部的时候就不会顶上来了
        
       if (@available(iOS 11.0, *)) {
            
       self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
           
           } else {

               }
    }

    _navTitleView = [self setupNavigationBarWithTitle:@"合店头条"];
    
    [self setUpSubviewsUI];
    [self setUpSubviewsUIMasonry];
    
    [HPProgressHUD alertWithLoadingText:@"加载数据中..."];

    //获取文章详情信息
    [self richQueryDetailInfo];

}

- (void)setUpSubviewsUI
{
    [self.view addSubview:self.webView];
    
    self.webView.backgroundColor = COLOR_GRAY_FFFFFF;
    
    float bottomHeight = 0;
    if (IPHONE_HAS_NOTCH) {
        bottomHeight = g_bottomSafeAreaHeight;
    }else{
        bottomHeight = getWidth(30.f);
    }
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0,bottomHeight, 0);
    
    self.webView.scrollView.backgroundColor = COLOR_GRAY_FFFFFF;

    [self.webView.scrollView addSubview:self.readNumLabel];
    //设置是否透明属性来去掉加载webview时底部的g_bottomSafeAreaHeight高度的黑色
    _webView.opaque = NO;
    
    //自动对页面进行缩放以适应屏幕
    self.webView.scalesPageToFit = NO;
}

- (void)setUpSubviewsUIMasonry
{
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navTitleView.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
    
    [self.readNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.webView.scrollView).offset(getWidth(15.f));
        make.right.mas_equalTo(self.webView.scrollView.mas_right).offset(getWidth(-15.f));
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(getWidth(30.f));
        make.bottom.mas_equalTo(self.webView.scrollView);
    }];
    
}

#pragma mark - 获取文章详情信息
- (void)richQueryDetailInfo
{
    HPIdeaListModel *model = self.param[@"model"];
    self.titleLabel.text = model.title;
    [HPHTTPSever HPGETServerWithMethod:@"/v1/rich/queryDetail" isNeedToken:YES paraments:@{@"articleId":model.articleId?model.articleId:@"1"} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            self.model = [HPIdeaDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            [self.webView loadHTMLString:[self adaptWebViewForHtml:self.model.context] baseURL:nil];
            
            self.readNumLabel.text = [NSString stringWithFormat:@"阅读量 %@",self.model.readingQuantity];
            
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
            
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
        //是识别webview中的类型，例如 当webview中有电话号码，点击号码就能直接打电话
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
//        _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
        _webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
        //取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
        for (UIView *_aView in [_webView subviews])
        {
            if ([_aView isKindOfClass:[UIScrollView class]])
            {
                [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
                //右侧的滚动条
                
                [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
                //下侧的滚动条
                
                for (UIView *_inScrollview in _aView.subviews)
                {
                    if ([_inScrollview isKindOfClass:[UIImageView class]])
                    {
                        _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                    }
                }
            }
        }
    }
    return _webView;
}

- (UILabel *)readNumLabel
{
    if (!_readNumLabel) {
        _readNumLabel = [UILabel new];
        _readNumLabel.textColor = COLOR_GRAY_BBBBBB;
        _readNumLabel.textAlignment = NSTextAlignmentLeft;
        _readNumLabel.font = kFont_Medium(15.f);
    }
    return _readNumLabel;
}

//HTML适配图片文字
- (NSString *)adaptWebViewForHtml:(NSString *) htmlStr
{
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size:15px;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>"
                            "<script type='text/javascript'>"
                            "window.onload = function(){\n"
                            "var $img = document.getElementsByTagName('img');\n"
                            "for(var p in  $img){\n"
                            " $img[p].style.width = '100%%';\n"
                            "$img[p].style.height ='auto'\n"
                            "}\n"
                            "}"
                            "</script>%@"
                            "</body>"
                            "</html>", htmlStr];

    return htmlString;
    
}

//注意：使用这个方法时要把UIWebView的scalesPageToFit设成NO
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];

    [self.readNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(webViewHeight + getWidth(16.f));
    }];
    self.readNumLabel.backgroundColor = COLOR_GRAY_FFFFFF;
//    [self.view layoutIfNeeded];
    [HPProgressHUD alertWithFinishText:@"加载完成"];

}
@end
