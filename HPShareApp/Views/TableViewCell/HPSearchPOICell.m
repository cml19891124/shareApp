//
//  HPSearchPOICell.m
//  HPShareApp
//
//  Created by Jay on 2018/12/12.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSearchPOICell.h"

@interface HPSearchPOICell ()

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *addressLabel;

@end

@implementation HPSearchPOICell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self setBackgroundColor:UIColor.whiteColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIView *centerView = [[UIView alloc] init];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:kFont_Medium(13.f)];
    [nameLabel setTextColor:COLOR_BLACK_333333];
    [centerView addSubview:nameLabel];
    _nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView).with.offset(getWidth(17.f));
        make.top.equalTo(centerView);
        make.height.mas_equalTo(nameLabel.font.pointSize);
    }];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    [addressLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [addressLabel setTextColor:COLOR_GRAY_999999];
    [centerView addSubview:addressLabel];
    _addressLabel = addressLabel;
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(getWidth(7.f));
        make.height.mas_equalTo(addressLabel.font.pointSize);
        make.bottom.equalTo(centerView);
    }];
}

- (void)setName:(NSString *)name {
    [_nameLabel setText:name];
}

- (void)setAddress:(NSString *)address {
    [_addressLabel setText:address];
}

@end
