
#import "HPBaseTableViewCell.h"
#import <UIKit/UIKit.h>

typedef void (^ClickBtnPayBlcok)(void);

@interface HPPayStyleCell : HPBaseTableViewCell

@property (nonatomic, strong) UIImageView *imaV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, copy) ClickBtnPayBlcok payBlcok;
@end
