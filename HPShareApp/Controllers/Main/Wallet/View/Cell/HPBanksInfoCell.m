//
//  HPBanksInfoCell.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBanksInfoCell.h"

@implementation HPBanksInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpSubviews];
        
        [self setUpSubviewsMasonry];
        
    }
    return self;
}

- (void)setUpSubviewsMasonry
{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.width.height.mas_equalTo(getWidth(25.f));
        make.centerY.mas_equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(getWidth(10.f));
        make.height.mas_equalTo(self.nameLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/2);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(getWidth(-15.f));
        make.width.height.mas_equalTo(getWidth(15.f));
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (void)setUpSubviews
{
    [self.contentView addSubview:self.iconView];
    
    [self.contentView addSubview:self.nameLabel];
    
    [self.contentView addSubview:self.selectedButton];

}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.image = ImageNamed(@"mingxi");
    }
    return _iconView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = COLOR_BLACK_333333;
        _nameLabel.font = kFont_Medium(16.f);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}


- (UIButton *)selectedButton
{
    if (!_selectedButton) {
        _selectedButton = [UIButton new];
        [_selectedButton setBackgroundImage:[UIImage imageNamed:@"pay_unselected"] forState:UIControlStateNormal];
        [_selectedButton setBackgroundImage:[UIImage imageNamed:@"pay_selected"] forState:UIControlStateSelected];
        [_selectedButton addTarget:self action:@selector(clickToSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
}

-(void)clickToSelectedButton:(UIButton *)button
{
    if (self.selectBlock) {
        self.selectBlock();
    }
}

- (void)setModel:(HPCardsInfoModel *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.logUrl] placeholderImage:ImageNamed(@"")];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",model.bankName,[model.accountNo substringFromIndex:model.accountNo.length - 4]];
}
@end
