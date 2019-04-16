

#import "HPPayStyleCell.h"

#import "Macro.h"

#import "Masonry.h"

@interface HPPayStyleCell ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;

@end
@implementation HPPayStyleCell

- (void)createCustomSubviews
{
    
    self.imageArr = @[@"wechatPay"];//,@"alipay"
    self.titleArr = @[@"微信支付"];//,@"支付宝支付"
    
    [self.contentView addSubview:self.imaV];

    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.selectedButton];
    
}

#pragma mark - 初始化控件

- (UIImageView *)imaV
{
    if (!_imaV) {
        _imaV = [UIImageView new];
    }
    return _imaV;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = COLOR_BLACK_333333;
        _titleLabel.font = kFont_Medium(14.f);
    }
    return _titleLabel;
}

- (UIButton *)selectedButton
{
    if (!_selectedButton) {
        _selectedButton = [UIButton new];
        [_selectedButton setBackgroundImage:[UIImage imageNamed:@"pay_unselected"] forState:UIControlStateNormal];
        [_selectedButton setBackgroundImage:[UIImage imageNamed:@"pay_selected"] forState:UIControlStateSelected];
        [_selectedButton addTarget:self action:@selector(clickToSelectedPay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
}

- (void)createCustomSubviewsMasonry
{
    [self.imaV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.width.height.mas_equalTo(getWidth(20.f));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imaV.mas_right).offset(getWidth(15.f));
        make.width.mas_equalTo(getWidth(kScreenWidth/3));
        make.height.mas_equalTo(self.contentView);
    }];
    
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(getWidth(-20.f));
        make.width.height.mas_equalTo(getWidth(20.f));
        make.centerY.mas_equalTo(self.contentView);
    }];
}

// 重写构造方法 -- 只调用一次嘛 （套路来的！务必记住！）
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createCustomSubviews];
        
        [self createCustomSubviewsMasonry];

    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clickToSelectedPay:(UIButton *)button
{
    if (self.payBlcok) {
        self.payBlcok();
    }
}
@end
