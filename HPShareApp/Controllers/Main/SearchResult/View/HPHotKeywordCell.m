//
//  HPHotKeywordCell.m
//  HPShareApp
//
//  Created by HP on 2019/2/23.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHotKeywordCell.h"

static const CGFloat kSearchHotSubViewHeight = 35.0f; // Item 高度
static const CGFloat kSearchHotSubViewTopSpace = 10.0f; // 上下间距

static  NSString *const kSearchHotRowKeyIden = @"kSearchHotRowKeyIden";

@implementation HPHotKeywordCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark -  高度
+ (CGFloat)hotCellHeightWithData:(NSArray *)historyArray {
    NSInteger countRow = 0; // 第几行数
    countRow = [[NSUserDefaults standardUserDefaults] integerForKey:kSearchHotRowKeyIden];
    countRow = (historyArray.count > 0) ? (countRow + 1) : 0;
    return countRow * (kSearchHotSubViewHeight + kSearchHotSubViewTopSpace) + kSearchHotSubViewTopSpace;
}

#pragma mark - Method
- (void)setHotViewWithArray:(NSArray *)hotSearchArray {
    self.hotSearchArray = hotSearchArray;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 计算位置
    CGFloat leftSpace = 15.0f;  // 左右空隙
    CGFloat topSpace = 10.f; // 上下空隙
    CGFloat margin = 15.0f;  // 两边的间距
    CGFloat currentX = margin; // X
    CGFloat currentY = 0; // Y
    NSInteger countRow = 0; // 第几行数
    CGFloat lastLabelWidth = 0; // 记录上一个宽度
    
    for (int i = 0; i < hotSearchArray.count; i++) {
        // 最多显示10个
        if (i > 9) {
            break;
        }
        /** 计算Frame */
        CGFloat nowWidth = [self textWidth:hotSearchArray[i]];
        if (i == 0) {
            currentX = currentX + lastLabelWidth;
        }
        else {
            currentX = currentX + leftSpace + lastLabelWidth;
        }
        currentY = countRow * kSearchHotSubViewHeight + (countRow + 1) * topSpace;
        // 换行
        if (currentX + leftSpace + margin + nowWidth >= kScreenWidth) {
            countRow++;
            currentY = currentY + kSearchHotSubViewHeight + topSpace;
            currentX = margin;
        }
        lastLabelWidth = nowWidth;
        // 文字内容
        UIButton *hotBtn = [[UIButton alloc] initWithFrame:CGRectMake(currentX, currentY, nowWidth, kSearchHotSubViewHeight)];
        hotBtn.backgroundColor = COLOR_GRAY_F6F6F6;
        hotBtn.layer.cornerRadius = 5.f;
        hotBtn.layer.masksToBounds = YES;
        /** hotBtn 具体显示 */
        [hotBtn setTitle:hotSearchArray[i] forState:UIControlStateNormal];
        [hotBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];;
        hotBtn.titleLabel.font = kFont_Medium(12.f);
        hotBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [hotBtn addTarget:self action:@selector(tagDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:hotBtn];
    }
    [kUserDefaults setInteger:countRow forKey:kSearchHotRowKeyIden];
    [kUserDefaults synchronize];
}

- (CGFloat)textWidth:(NSString *)text {
    CGFloat width = [text boundingRectWithSize:CGSizeMake(kScreenWidth - getWidth(30.f), kSearchHotSubViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.width + 20;
    // 防止 宽度过大
    if (width > kScreenWidth - 30) {
        width = kScreenWidth - 30;
    }
    return width;
}

#pragma mark - Private Method
- (void)tagDidClick:(UIButton *)button {
    
    if (self.hotSearchBlock) {
        self.hotSearchBlock(button.currentTitle);
    }
}

@end
