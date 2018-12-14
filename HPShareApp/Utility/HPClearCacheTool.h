//
//  HPClearCacheTool.h
//  HPShareApp
//
//  Created by HP on 2018/12/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPClearCacheTool : NSObject
//1. 获取缓存文件的大小
+( float )readCacheSize;
//2. 清除缓存
- (void)clearFile;
@end

NS_ASSUME_NONNULL_END
