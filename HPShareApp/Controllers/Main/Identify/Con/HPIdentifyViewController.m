//
//  HPIdentifyViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//
#import "HPPassportModel.h"

#import "HPIdentifyViewController.h"

#import "HPRightImageButton.h"

#import "HPGradientUtil.h"

#import "HPIdentifyModel.h"

@interface HPIdentifyViewController ()

@property (strong, nonatomic) UILabel *boardSubLabel;

@property (strong, nonatomic) HPPassportModel *portModel;

@property (nonatomic, strong) UIImageView *headView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *colorBtn;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *nameSubLabel;

@property (strong, nonatomic) UILabel *nameidenLabel;

@property (strong, nonatomic) HPRightImageButton *realNameBtn;

@property (strong, nonatomic) HPRightImageButton *boardBtn;

@property (strong, nonatomic) UILabel *idLabel;

@property (nonatomic, strong) UIView *bgview;

@property (strong, nonatomic) UIButton *identifyBtn;

@property (strong, nonatomic) UIButton *passportBtn;

@property (strong, nonatomic) HPIdentifyModel *model;

@property (strong, nonatomic) UIView *nameRow;

@property (strong, nonatomic) UILabel *portLabel;

@end

@implementation HPIdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubviews];
    
    [self setUpSubviewsMasonry];

    [self getIdentifyApi];
    
    [self getPassportIdentifyApi];
}

#pragma mark - 查询营业执照认证信息 auditStatus: 0审核未通过，1通过，2审核中
- (void)getPassportIdentifyApi
{
    [HPHTTPSever HPPostServerWithMethod:@"/v1/business/queyBusinessLicense" paraments:@{} needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            self.portModel = [HPPassportModel mj_objectWithKeyValues:responseObject[@"data"]];
            [HPProgressHUD alertMessage:MSG];
            if (self.portModel) {
                [self setPassPortInfo];

            }else{
                [self setPassPortInfo];
            }
        }else{
            [HPProgressHUD alertMessage:MSG];
            [self setPassPortInfo];

        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)setPassPortInfo
{
    
    if (self.portModel.auditStatus.integerValue == 0) {
        self.boardBtn.text = @"审核未通过";
        self.portLabel.hidden = YES;
        
        self.passportBtn.hidden = YES;
        self.boardBtn.image = ImageNamed(@"shouye_gengduo");
    }else if (self.portModel.auditStatus.integerValue == 1){
        self.portLabel.text = @"已认证";

        self.boardBtn.text =  @"已认证";
        
        self.boardBtn.image = ImageNamed(@"");

        NSString *portNumber = [self.portModel.number stringByReplacingCharactersInRange:NSMakeRange(3, self.portModel.number.length - 6) withString:@"********"];
        
        self.boardSubLabel.text = [NSString stringWithFormat:@"营业执照代码：%@",portNumber];
    }else{
        self.portLabel.text = @"待认证";

        self.boardBtn.text =  @"审核中";
        
        self.boardBtn.image = ImageNamed(@"shouye_gengduo");
    }
}

- (void)setUserIdentifyInfo
{
    if (self.model) {
        self.nameLabel.text = @"身份信息";
        NSString *name = self.model.realName?self.model.realName:@"--";
        self.idLabel.text = [NSString stringWithFormat:@"姓名：%@",name];
        self.nameSubLabel.text = [NSString stringWithFormat:@"身份证号：%@",self.model.idCard?self.model.idCard:@"--"];
        self.identifyBtn.hidden = NO;
        self.nameidenLabel.text = @"已认证";
        self.realNameBtn.text = @"已认证";
        self.realNameBtn.image = ImageNamed(@"");
        [self.nameRow mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(getWidth(125.f));
        }];
    }else{
        self.nameLabel.text = @"实名认证";
        self.nameSubLabel.text = [NSString stringWithFormat:@"认证信息将严格保密"];
        self.identifyBtn.hidden = YES;
        self.nameidenLabel.hidden = YES;
        [self.idLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(getWidth(0));
        }];
        
        [self.nameSubLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.idLabel.mas_bottom).offset(getWidth(-10));
        }];
        
        [self.nameRow mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(getWidth(80));
        }];
        
        self.realNameBtn.text = @"去认证";
        self.realNameBtn.image = ImageNamed(@"shouye_gengduo");
    }
}

- (void)getIdentifyApi
{
    [HPHTTPSever HPPostServerWithMethod:@"/v1/IdCard/queryIdCard" paraments:@{} needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            self.model = [HPIdentifyModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (self.model) {
                [self setUserIdentifyInfo];
            }else{
                [self setUserIdentifyInfo];
            }
        }else{
            [self setUserIdentifyInfo];

            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpSubviews
{
    UIButton *backBtn = [UIButton new];
    [backBtn setImage:ImageNamed(@"fanhui_wh") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
    [self.view addSubview:self.headView];
    
    [self.headView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headView);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.headView addSubview:self.titleLabel];
    
    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));
    UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(0.f,0.f) endPoint:CGPointMake(btnSize.width, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR(255, 255, 255, 1) endColor:COLOR(255, 255, 255, 0)];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.headView addSubview:self.colorBtn];
    [_colorBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    [self.headView addSubview:self.subTitleLabel];
    
    [self.view addSubview:self.bgview];

    [self setUpIdentifyView:self.bgview];
}

- (void)setUpSubviewsMasonry
{
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(167.f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headView);
        make.top.mas_equalTo(g_statusBarHeight + 44.f);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(self.titleLabel.font.pointSize);
    }];
    
    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));
    
    [self.colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(getWidth(15.f));
        make.size.mas_equalTo(btnSize);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headView);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.colorBtn.mas_bottom).offset(getWidth(10.f));
        make.height.mas_equalTo(self.subTitleLabel.font.pointSize);
        
    }];
    
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(getWidth(162.f));
        make.top.mas_equalTo(self.headView.mas_bottom);
    }];
}

- (UIView *)bgview
{
    if (!_bgview) {
        _bgview = [UIView new];
        [_bgview setBackgroundColor:COLOR_GRAY_FFFFFF];
    }
    return _bgview;
}

- (UIButton *)identifyBtn
{
    if (!_identifyBtn) {
        _identifyBtn = [UIButton new];
        _identifyBtn.backgroundColor = UIColor.clearColor;
        [_identifyBtn setBackgroundImage:ImageNamed(@"identity") forState:UIControlStateNormal];
        _identifyBtn.hidden = YES;
    }
    return _identifyBtn;
}

- (UIButton *)passportBtn
{
    if (!_passportBtn) {
        _passportBtn = [UIButton new];
        _passportBtn.backgroundColor = UIColor.clearColor;
        [_passportBtn setBackgroundImage:ImageNamed(@"zhizhao") forState:UIControlStateNormal];
        _passportBtn.hidden = YES;
    }
    return _passportBtn;
}

- (UIImageView *)headView
{
    if (!_headView) {
        _headView = [UIImageView new];
        _headView.userInteractionEnabled = YES;
        _headView.image = ImageNamed(@"BG");
    }
    return _headView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:kFont_Bold(24.f)];
        [_titleLabel setTextColor:COLOR_GRAY_FFFFFF];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setText:@"资格认证"];
        
    }
    return _titleLabel;
}

- (UIButton *)colorBtn
{
    if (!_colorBtn) {
        _colorBtn = [[UIButton alloc] init];
        [_colorBtn.layer setCornerRadius:2.f];
        [_colorBtn.layer setMasksToBounds:YES];
    }
    return _colorBtn;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        [_subTitleLabel setFont:kFont_Medium(14.f)];
        [_subTitleLabel setTextColor:COLOR_GRAY_FFFFFF];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_subTitleLabel setText:@"证照信息认证，交易保障全面升级"];
    }
    return _subTitleLabel;
}

- (void)setUpIdentifyView:(UIView *)bgview
{

    UIView *nameRow = [self addRowOfParentView:bgview withHeight:getWidth(125.f) margin:0.f isEnd:NO];
    
    self.nameRow = nameRow;

    [self hasIdentifySelf:nameRow];

    //营业执照
    UIView *passportRow = [self addRowOfParentView:bgview withHeight:getWidth(80.f) margin:0.f isEnd:NO];
    
    UILabel *boardLabel = [self setupTitleLabelWithTitle:@"营业执照认证"];
    boardLabel.textColor = COLOR_BLACK_333333;
    boardLabel.font = kFont_Bold(16.f);
    [passportRow addSubview:boardLabel];
    
    [passportRow addSubview:self.passportBtn];
    
    self.passportBtn.hidden = NO;
    
    [boardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passportRow).with.offset(18.f * g_rateWidth);
        make.top.mas_equalTo(getWidth(10.f));
    }];
    
    [self.passportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boardLabel.mas_right).with.offset(getWidth(5.f));
        make.centerY.mas_equalTo(boardLabel);
    }];
    
    UILabel *idenLabel = [self setupTitleLabelWithTitle:@"已认证"];
    idenLabel.textColor = COLOR_GRAY_999999;
    idenLabel.font = kFont_Medium(14.f);
    [passportRow addSubview:idenLabel];
    self.portLabel = idenLabel;
    
    [idenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passportBtn.mas_right).with.offset(getWidth(5.f));
        make.centerY.mas_equalTo(boardLabel);
    }];
    
    UILabel *boardSubLabel = [self setupTitleLabelWithTitle:@"上传营业执照交易更有保障"];
    boardSubLabel.font = kFont_Medium(14.f);
    [passportRow addSubview:boardSubLabel];
    self.boardSubLabel = boardSubLabel;
    [boardSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passportRow).with.offset(18.f * g_rateWidth);
        make.bottom.mas_equalTo(passportRow.mas_bottom).offset(getWidth(-10.f));
    }];
    
    HPRightImageButton *boardBtn = [self setupGotoBtnWithTitle:@"去认证"];
    [boardBtn setTag:4701];
    [passportRow addSubview:boardBtn];
    self.boardBtn = boardBtn;
    
    [boardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(passportRow).with.offset(-15.f * g_rateWidth);
        make.centerY.equalTo(passportRow);
    }];
    
    UIView *lineBoardV = [UIView new];
    lineBoardV.backgroundColor = COLOR_GRAY_EEEEEE;
    [nameRow addSubview:lineBoardV];
    [lineBoardV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(passportRow);
        make.height.mas_equalTo(1);
    }];
}

- (void)hasIdentifySelf:(UIView *)nameRow
{
    _nameLabel = [self setupTitleLabelWithTitle:@"身份信息"];
    _nameLabel.textColor = COLOR_BLACK_333333;
    _nameLabel.font = kFont_Bold(16.f);
    [nameRow addSubview:self.nameLabel];
    
    [nameRow addSubview:self.identifyBtn];
    
    self.identifyBtn.hidden = NO;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameRow).with.offset(18.f * g_rateWidth);
        make.top.mas_equalTo(getWidth(18.f));
    }];
    
    [self.identifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(getWidth(5.f));
        make.centerY.mas_equalTo(self.nameLabel);
    }];
    
    UILabel *nameidenLabel = [self setupTitleLabelWithTitle:@"已认证"];
    nameidenLabel.textColor = COLOR_GRAY_999999;
    nameidenLabel.font = kFont_Medium(12.f);
    [nameRow addSubview:nameidenLabel];
    self.nameidenLabel = nameidenLabel;
    
    [nameidenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.identifyBtn.mas_right).with.offset(getWidth(5.f));
        make.centerY.mas_equalTo(self.nameLabel);
    }];
    
    NSString *realName = [self.model.realName stringByReplacingCharactersInRange:NSMakeRange(1, self.model.realName.length - 1) withString:@"***"];
    UILabel *idLabel = [self setupTitleLabelWithTitle:[NSString stringWithFormat:@"姓名：%@", realName]];
    idLabel.textColor = COLOR_GRAY_999999;
    idLabel.font = kFont_Medium(14.f);
    [nameRow addSubview:idLabel];
    self.idLabel = idLabel;
    
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(getWidth(20.f));
    }];
    
    _nameSubLabel = [self setupTitleLabelWithTitle:[NSString stringWithFormat:@"身份证号：%@",self.model.idCard]];
    _nameSubLabel.font = kFont_Medium(14.f);

    [nameRow addSubview:self.nameSubLabel];
    [self.nameSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameRow).with.offset(18.f * g_rateWidth);
        make.top.mas_equalTo(idLabel.mas_bottom).offset(getWidth(15.f));
    }];
    
    HPRightImageButton *realNameBtn = [self setupGotoBtnWithTitle:@"已认证"];
    [realNameBtn setTag:4700];
    realNameBtn.image = ImageNamed(@"");
    [nameRow addSubview:realNameBtn];
    self.realNameBtn = realNameBtn;
    
    [realNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nameRow).with.offset(-15.f * g_rateWidth);
        make.centerY.equalTo(nameRow);
    }];
    
    UIView *lineNameV = [UIView new];
    lineNameV.backgroundColor = COLOR_GRAY_EEEEEE;
    [nameRow addSubview:lineNameV];
    [lineNameV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(nameRow);
        make.height.mas_equalTo(1);
    }];
}


- (UIView *)addRowOfParentView:(UIView *)view withHeight:(CGFloat)height margin:(CGFloat)margin isEnd:(BOOL)isEnd {
    UIView *row = [[UIView alloc] init];
    [view addSubview:row];
    [row mas_makeConstraints:^(MASConstraintMaker *make) {
        if (view.subviews.count == 1) {
            make.top.equalTo(view).with.offset(margin);
        }
        else {
            UIView *lastRow = view.subviews[view.subviews.count - 2];
            make.top.equalTo(lastRow.mas_bottom);
        }
        
        if (isEnd) {
            make.bottom.equalTo(view).with.offset(-margin);
        }
        
        make.left.and.width.equalTo(view);
        make.height.mas_equalTo(height);
    }];
    
    return row;
}

- (UILabel *)setupTitleLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [label setTextColor:COLOR_GRAY_888888];
    [label setText:title];
    return label;
}

- (HPRightImageButton *)setupGotoBtnWithTitle:(NSString *)title {
    HPRightImageButton *btn = [[HPRightImageButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"shouye_gengduo"]];
    [btn setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [btn setText:title];
    [btn setSpace:10.f];
    [btn setColor:COLOR_GRAY_999999];
    [btn setSelectedColor:COLOR_BLACK_333333];
    [btn addTarget:self action:@selector(onClickGotoCtrl:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)onClickGotoCtrl:(HPRightImageButton *)button
{
    if (button.tag == 4700) {
        [self pushVCByClassName:@"HPRealNameViewController"];
    }else if (button.tag == 4701){
        [self pushVCByClassName:@"HPManagerBoardViewController"];

    }
}
@end
