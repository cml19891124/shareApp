#import <UIKit/UIKit.h>
#import "HPShareListModel.h"
#import "HPCardDetailsModel.h"

@class HPCardHeaderView;
typedef NS_ENUM(NSInteger, HPMyCardType) {
    HPMyCardTypeEdit = 20,
    HPMyCardTypeFocus,
    HPMyCardTypeCancelFocus,
};

@protocol HPCardHeaderViewDelegate  <NSObject>

/**
 点击返回
 */
- (void)clickBackButtonBackToMyContoller;
/**
 点击关注事件
 */
- (void)clickButtonInCardHeaderView:(HPCardHeaderView *)CardHeaderView focusSBToFansList:(HPShareListModel *)model andCardType:(HPMyCardType)cardType;
@end
NS_ASSUME_NONNULL_BEGIN

@interface HPCardHeaderView : UIView
@property (nonatomic, weak) id<HPCardHeaderViewDelegate> delegate;

@property (strong, nonatomic) HPShareListModel *model;
@property (strong, nonatomic) UIView *cardPanel;
@property (strong, nonatomic) UIView *infoRegion;
@property (nonatomic, strong) UIButton *portraitView;
@property (strong, nonatomic) UILabel *phoneNumLabel;
@property (strong, nonatomic) UILabel *companyLabel;
@property (strong, nonatomic) UIButton *editBtn;
@property (nonatomic, strong) HPCardDetailsModel *cardDetailsModel;
@property (copy, nonatomic) NSString *userId;

@property (strong, nonatomic) UIControl *verifiedCtrl;
@property (strong, nonatomic) UIView *releaseRegion;
/**
 关注/取消关注
 */
@property (nonatomic, copy) NSString *method;
@property (nonatomic, weak) UILabel *signatureLabel;

@property (nonatomic, weak) UILabel *descLabel;
- (instancetype)initWithFrame:(CGRect)frame withUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END

