

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GetCurrentViewcontroller : NSObject
+ (UIViewController *)getCurrentVC;


//获取当前页面显示的VC
+ (UIViewController *)topViewController;

@end
