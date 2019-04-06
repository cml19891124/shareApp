

#import <UIKit/UIKit.h>

@interface MyTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, strong) UIFont *placeholderFont;

@property (nonatomic, strong) UIFont *textFont;

@end
