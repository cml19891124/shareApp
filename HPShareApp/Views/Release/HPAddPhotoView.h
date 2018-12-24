//
//  HPAddPhotoView.h
//  HPShareApp
//
//  Created by Jay on 2018/12/10.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseView.h"

typedef void(^AddBtnCallback)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HPAddPhotoView : HPBaseView

@property (nonatomic, assign) NSInteger maxNum;

@property (nonatomic, copy, readonly) NSMutableArray *photos;

@property (nonatomic, strong) AddBtnCallback addBtnCallBack;

- (void)addPhoto:(UIImage *)image;

- (void)addPhotoUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
