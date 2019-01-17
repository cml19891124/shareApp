//
//  HPCommonBannerData.m
//  HPShareApp
//
//  Created by HP on 2019/1/17.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCommonBannerData.h"

@implementation HPCommonBannerData

static NSMutableArray<UIImage *> * _bannerModelsArray;


+ (NSArray<UIImage *> *)getHPHomeBannerData
{
    if (_bannerModelsArray == nil) {
        _bannerModelsArray = [NSMutableArray array];

        [HPCommonBannerData getHomeBannerDataList];
    }
    
    if (_bannerModelsArray) {
        return [[NSArray alloc] initWithArray:_bannerModelsArray copyItems:YES];
    }
    return _bannerModelsArray;
}

+ (void)getHomeBannerDataList
{
    [HPHTTPSever HPGETServerWithMethod:@"/v1/banner/list" isNeedToken:NO paraments:@{@"size":@(5)} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            NSArray *bannerModelsArray = [HPHomeBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            for (int i = 0;i < bannerModelsArray.count;i++) {
                HPHomeBannerModel *model = bannerModelsArray[i];
                if ([model.imgUrl containsString:@"http"]) {
                    UIImage *image = [self getImageFromURL:model.imgUrl];
                    if (image) {
                        [_bannerModelsArray addObject:image];
                    }else{
                        [_bannerModelsArray addObject:ImageNamed(@"home_page_banner")];
                    }
                    
                }else{//用本地图片 替换并填充
                    [_bannerModelsArray addObject:ImageNamed(@"home_page_banner")];
                    
                }
                if (bannerModelsArray.count <= 1) {//用本地图片填充两张
                    [_bannerModelsArray addObject:ImageNamed(@"home_page_banner")];
                    [_bannerModelsArray addObject:ImageNamed(@"home_page_banner")];
                    
                }

            }
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
    
}

+(UIImage *) getImageFromURL:(NSString *)fileURL
{
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    
    return result;
    
}
@end
