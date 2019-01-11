//
//  HPShareMapAnnotationView.m
//  HPShareApp
//
//  Created by HP on 2019/1/7.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareMapAnnotationView.h"
#import "HPImageUtil.h"
#import "Macro.h"
#import "Masonry.h"
#import "HPGlobalVariable.h"

@interface HPShareMapAnnotationView ()

@property (nonatomic, strong) MACustomCalloutView *callOutView;

@end

@implementation HPShareMapAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self setUpMapSubviewsMasonry];
    }
    return self;
}

- (void)setUpMapSubviewsMasonry
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.imageView);
        make.top.equalTo(self.imageView).with.offset(41.f);
        make.height.mas_equalTo(self.titleLabel.font.pointSize + 50.f);
    }];
    
    [self.customCalloutView setFrame:CGRectMake(0.f, 0.f, getWidth(243.f), getWidth(60.f))];
    self.customCalloutView.center = CGPointMake(self.center.x + getWidth(10.f), getWidth(-35.f));
    [self.loc_imageView setFrame:CGRectMake(0.f, 0.f, getWidth(243.f), getWidth(70.f))];
    
}

- (void)setCallOutOffset:(CGPoint)callOutOffset{
    self.calloutOffset = callOutOffset;
}

- (void)setupUI {
    [self.imageView addSubview:self.titleLabel];
    self.customCalloutView = [self calloutView];
    [self.customerCallOutView addSubview:self.loc_imageView];
    self.loc_imageView.image = ImageNamed(@"address_loc");
    [self.imageView addSubview:self.customCalloutView];
    [self.customerCallOutView addSubview:self.title];

}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        
        _titleLabel.hidden = YES;
    }
    else {
        _titleLabel.hidden = NO;
    }
}

#pragma mark - 初始化子控件
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
        [titleLabel setTextColor:COLOR_BLACK_333333];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:self.annotation.title];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (MACustomCalloutView *)calloutView
{
    if (!_callOutView) {
        _callOutView = [[MACustomCalloutView alloc] initWithCustomView:self.customerCallOutView];
    }
    return _callOutView;
}

- (UIView *)customerCallOutView
{
    if (!_customerCallOutView) {
        _customerCallOutView = [UIView new];
    }
    return _customerCallOutView;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, getWidth(243.f), getWidth(60.f))];
        _title.numberOfLines = 0;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = COLOR_BLACK_333333;
    }
    return _title;
}

- (UIImageView *)loc_imageView
{
    if (!_loc_imageView) {
        _loc_imageView = [UIImageView new];
    }
    return _loc_imageView;
}
@end
