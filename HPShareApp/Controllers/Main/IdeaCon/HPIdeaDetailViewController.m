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
    
    [self.view addSubview:self.readNumLabel];
//    _readNumLabel.hidden = YES;

}

- (void)setUpSubviewsUIMasonry
{
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navTitleView.mas_bottom);
        make.height.mas_equalTo(kScreenHeight - g_statusBarHeight - 44.f - 49.f);
//        make.bottom.mas_equalTo(self.view);
    }];
    
    [self.readNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(self.webView.mas_bottom);
        make.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth/3);
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
            /*NSString *context = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto;}</style></head>%@",kScreenWidth/3,self.model.context];
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]
                                                   initWithData:[context dataUsingEncoding:
                                                                 NSUnicodeStringEncoding]
                                                   options:@{
                                                             NSDocumentTypeDocumentAttribute:
                                                                 NSHTMLTextDocumentType
                                                             }
                                                   documentAttributes:nil error:nil];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
            
            [attrStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrStr.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                if (value && [value isKindOfClass:[NSTextAttachment class]]) {
                    NSTextAttachment *textAttachment = value;
                    CGFloat width = CGRectGetWidth(textAttachment.bounds);
                    CGFloat height = CGRectGetHeight(textAttachment.bounds);
                    if (width > kScreenWidth) {// 大于屏幕宽度时，缩小bounds宽度，高度
                        height = (kScreenWidth - 20) / width * height;
                        width = kScreenWidth - 20;
                        textAttachment.bounds = CGRectMake((kScreenWidth - width)/2, 0, width, height);
                    }
                    
                }
            }];
            
//            HPLog(@"员额还给你-----:%@",self.model.context);
//            HPLog(@"string-----:%@",attrStr.string);

            self.contentView.attributedText = attrStr;*/
            [self.webView loadHTMLString:[self adaptWebViewForHtml:self.model.context] baseURL:nil];
            self.readNumLabel.text = [NSString stringWithFormat:@"阅读 %@",self.model.readingQuantity];
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
        [_contentView setTextAlignment: NSTextAlignmentCenter];
        //高度自适应，前提不设置宽度，高度自适应
        [_contentView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _contentView.dataDetectorTypes = UIDataDetectorTypeLink;

    }
    return _contentView;
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
{/*
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html>" ];
    
    [headHtml appendString : @"<head>" ];
    
    [headHtml appendString : @"<meta charset=\"utf-8\">" ];
    
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];
    
    //适配图片宽度，让图片宽度等于屏幕宽度
    //[headHtml appendString : @"<style>img{width:100%;}</style>" ];
    //[headHtml appendString : @"<style>img{height:auto;}</style>" ];
    
    //适配图片宽度，让图片宽度最大等于屏幕宽度
    //    [headHtml appendString : @"<style>img{max-width:100%;width:auto;height:auto;}</style>"];
    
    
    //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '100%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    
    [headHtml appendString : @"<style>table{width:100%;}</style>" ];
    [headHtml appendString : @"<title>webview</title>" ];
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];*/
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(webViewHeight * 0.5);
//        [make.bottom uninstall];
//    }];
//
//    [self.readNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.webView.mas_bottom);
//        make.height.mas_equalTo(49.f);
//
//    }];
//    self.readNumLabel.backgroundColor = COLOR_GRAY_FFFFFF;
//    self.readNumLabel.hidden = NO;
//    [self.view layoutIfNeeded];
}
@end
