//
//  AJSearchBar.m
//  准到-ipad
//
//  Created by zhundao on 2017/9/8.
//  Copyright © 2017年 zhundao. All rights reserved.
//

#import "AJSearchBar.h"
#import "UITextField+TextLeftOffset_ffset.h"
#import "Macro.h"
#import "Masonry.h"
#import "HPGlobalVariable.h"

/*! leftView 的宽度  */
static NSInteger leftViewWidth = 35 ;
/*! 图片和label的间距 */
static NSInteger space = 15;

@interface AJSearchBar()<UITextFieldDelegate>

/*! 默认文字 默认居中存在 */
@property(nonatomic,strong)UILabel *placeholderLabel;
/*! 方法镜图片 */
@property(nonatomic,strong)UIImageView *searchImage;

/*! label文字大小 */
@property(nonatomic,assign)CGSize size;

@end;

@implementation AJSearchBar

- (void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    [self layoutIfNeeded];
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        [make.right uninstall];
        make.right.mas_equalTo(self);
    }];
    self.lineView.hidden = YES;
    self.cancelButton.hidden = YES;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _historyArray = [NSMutableArray array];

        //读取数组NSArray类型的数据
        NSArray *myArray = [[NSArray alloc] initWithArray:[kUserDefaults arrayForKey:@"historyArray"]];
        // NSArray --> NSMutableArray
        [_historyArray addObjectsFromArray:[myArray mutableCopy]];
        
        [self addSubview:self.textField];
        [_textField addSubview:self.placeholderLabel];
        [_textField addSubview:self.searchImage];
        _textField.delegate = self;
        [self addSubview:self.cancelButton];
        [self addSubview:self.lineView];
        [self setAllFrame];

    }
    return self;
}

#pragma mark --- 懒加载

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        /*! 边框处理 */
        _textField.layer.borderColor = COLOR_GRAY_F4F4F4.CGColor;
        _textField.backgroundColor = COLOR_GRAY_F4F4F4;
        _textField.layer.borderWidth = 1;
        _textField.layer.cornerRadius = 2.f;
        _textField.layer.masksToBounds = YES;
        /*! 字体其他 */
        _textField.font = kFont_Regular(14.f);
        _textField.tintColor = COLOR_GRAY_F4F4F4;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.delegate =self;
        /*! 设置键盘return样式为搜索样式 */
        _textField.returnKeyType = UIReturnKeySearch;
        /*! 设置为无文字就灰色不可点 */
        _textField.enablesReturnKeyAutomatically = YES;
        /*! 开启系统清除样式 */
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        /*! 添加左边遮盖 */
        [_textField setTextOffsetWithLeftViewRect:CGRectMake(0, 0, leftViewWidth, self.frame.size.height) WithMode:UITextFieldViewModeAlways];
        /*! 编辑事件观察 */
        [_textField addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.text = @"输入店名/位置/行业精确搜索";
        _placeholderLabel.textColor = COLOR_GRAY_999999;
        _placeholderLabel.font = kFont_Regular(14.f);
    }
    return _placeholderLabel;
}

- (UIImageView *)searchImage{
    if (!_searchImage) {
        _searchImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _searchImage.image = ImageNamed(@"soiusuo_sou");
    }
    return _searchImage;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = kFont_Medium(16.f);
    }
    return _cancelButton;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_GRAY_EBEBEB;
    }
    return _lineView;
}

#pragma mark --- 设置尺寸
- (void)setAllFrame{
    _size = [_placeholderLabel.text boundingRectWithSize:CGSizeMake(600, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kFont_Medium(12.f)} context:nil].size;
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.size.width + 100, self.size.height));
        make.centerX.equalTo(self.textField).offset(getWidth(50.f));
        make.centerY.mas_equalTo(self.textField);
    }];
    
    [_searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerX.mas_equalTo(self.textField).offset(- space - self.size.width/2);
        make.centerY.mas_equalTo(self.textField);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self);
        make.height.mas_equalTo(getWidth(32.f));
        make.right.mas_equalTo(self).offset(getWidth(-55.f));
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField.mas_right);
        make.top.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.textField);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, getWidth(1.f)));
        make.bottom.mas_equalTo(self).offset(getWidth(1.f));
        make.centerX.mas_equalTo(self);
    }];
}
#pragma mark --- 取消按钮点击事件

- (void)cancelAction{
    HPLog(@"点击了取消");
    [self endEditing:YES];
    _placeholderLabel.hidden  = NO;
    _textField.text = @"";
    [_placeholderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.textField);
    }];
    /*! _searchImage移动到关标左边 */
    [_searchImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.textField).offset(-space-self.size.width/2);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        //        执行更新
        [self.textField layoutIfNeeded];
    }];
    
    if ([self.SearchDelegate respondsToSelector:@selector(clickPopToHomeVC)]) {
        [self.SearchDelegate clickPopToHomeVC];
    }
}

#pragma mark --- UITextFieldDelegate

/*! 当输入框开始编辑的时候 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    /*! _placeholderLabel移动到关标右边*/
    [_placeholderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.textField).offset(-self.textField.frame.size.width/2 + leftViewWidth + self.size.width/2 + 55);
    }];
    /*! _searchImage移动到关标左边 */
    [_searchImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.textField).offset(-self.textField.frame.size.width/2 - space + leftViewWidth);
    }];
    [UIView animateWithDuration:0.25 animations:^{
//        执行更新
        [self layoutIfNeeded];
    }];
    
}
/*! 输入框结束编辑 */
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        [HPProgressHUD alertMessage:@"请输入搜索内容"];
            }
    if (textField.text.length>0) {
        HPLog(@"进行搜索");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField resignFirstResponder];
    if (textField.text.length == 0) {
        [HPProgressHUD alertMessage:@"请输入搜索内容"];
    }
    [_SearchDelegate searchWithStr:textField.text];
    [self searchText:textField.text];
    HPLog(@"点击了搜索");
    return YES;
}

#pragma mark --- textFieldDidEditing: 
/*! 输入框编辑中 */

- (void)textFieldDidEditing:(UITextField *)textField{
    [self isHiddenLabel:textField];
}

- (void)isHiddenLabel:(UITextField *)textField{
    if (textField.text.length==0) {
        _placeholderLabel.hidden  = NO;
    }else{
        _placeholderLabel.hidden = YES;
    }
}
- (void)dealloc{
    HPLog(@"%@ 已经dealloc",NSStringFromClass(self.class));
}

//键盘搜索按钮或者搜索历史的按钮执行的方法.

-(void)searchText:(NSString *)seaTxt
{
    // 把键盘隐藏掉
    [self endEditing:YES];
    
    // 去除字符串两边的空格
    NSString *removeBlackStr = [seaTxt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //读取数组NSArray类型的数据
    NSArray *myArray = [[NSArray alloc] initWithArray:[kUserDefaults arrayForKey:@"historyArray"]];
    _historyArray = [myArray mutableCopy];
    
    BOOL isEqualTo1,isEqualTo2;
    isEqualTo1 = NO;
    isEqualTo2 = NO;
    
    if (_historyArray.count > 0) {
        isEqualTo2 = YES;
        //判断搜索内容是否存在，存在的话放到数组第一位，不存在的话添加。
        for (NSString * str in myArray) {
            if ([removeBlackStr isEqualToString:str]) {
                //获取指定对象的索引
                NSUInteger index = [myArray indexOfObject:removeBlackStr];
                [_historyArray removeObjectAtIndex:index];
                if (removeBlackStr != nil && ![removeBlackStr isEqualToString:@""]) {
                    [_historyArray insertObject:removeBlackStr atIndex:0];
                }
                isEqualTo1 = YES;
                break;
            }
        }
    }
    
    if (!isEqualTo1 || !isEqualTo2) {
        if (removeBlackStr != nil && ![removeBlackStr isEqualToString:@""]) {
            [_historyArray insertObject:removeBlackStr atIndex:0];
        }
    }
    //暂时不设置上限
//    if(_historyArray.count > 10)
//    {
//        [_historyArray removeObjectAtIndex:_historyArray.count - 1];
//    }
    //将上述数据全部存储到NSUserDefaults中
    [kUserDefaults setObject:_historyArray forKey:@"historyArray"];
    [kUserDefaults synchronize];
}

//清空搜索历史

- (void)clear{
    
    [_historyArray removeAllObjects];
    //将数据全部从NSUserDefaults中移除
    [kUserDefaults setObject:nil forKey:@"historyArray"];
    [kUserDefaults synchronize];
}

@end
