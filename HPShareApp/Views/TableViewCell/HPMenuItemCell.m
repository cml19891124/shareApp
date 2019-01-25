//
//  HPMenuItemCell.m
//  HPShareApp
//
//  Created by HP on 2019/1/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPMenuItemCell.h"

@implementation HPMenuItemCell

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
        [self setUpMenuItemSubviews];
    }
    return self;
}


- (void)setUpMenuItemSubviews
{
    [self setUpMenuButtonViews];
}

- (void)setUpMenuButtonViews
{
    NSArray *menuImageArr = @[@"home_page_store_ sharing",@"home_page_lobby_ sharing",@"home_page_other_sharing",@"home_page_map"//,@"home_page_stock_purchase",@"home_page_shelf_rental",@"home_page_used_shelves",@"home_page_new_store_opens"
                              ];
    NSArray *menuTitleArr = @[@"店铺拼租",@"大堂拼租",@"空间短租",@"地图找店"];//,@"进货",@"货架出租",@"二手货架",@"新店合开"];
    for (int i = 0; i < menuImageArr.count; i++) {
        HPMenuCellbutton *menuBtn = [HPMenuCellbutton new];
        [menuBtn setImage:ImageNamed(menuImageArr[i]) forState:UIControlStateNormal];
        [menuBtn setTitle:menuTitleArr[i] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(clickMenuItem:) forControlEvents:UIControlEventTouchUpInside];
        menuBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        menuBtn.tag = 50 + i;
        CGFloat row = i/4;
        CGFloat col = i%4;
        [self addSubview:menuBtn];
        self.menuBtn = menuBtn;
        CGFloat margin = (kScreenWidth - getWidth(52.f) * 4 - getWidth(26.f) * 2)/3;
        [menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(26.f) + (getWidth(52.f) + margin) * col);
            make.top.mas_equalTo(getWidth(25.f) + (getWidth(77.f) + getWidth(21.f)) * row);
            make.size.mas_equalTo(CGSizeMake(getWidth(52.f), getWidth(77.f)));
        }];
    }
    
}

- (void)clickMenuItem:(UIButton *)button
{
    if (self.clickMenuItemBlock) {
        self.clickMenuItemBlock(button.tag,button.currentTitle);
    }
}
@end
