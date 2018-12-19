//
//  HPHistoryListModel.m
//  HPShareApp
//
//  Created by Jay on 2018/12/18.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHistoryListData.h"

@implementation HPHistoryListData

- (instancetype)init {
    self = [super init];
    if (self) {
        _count = 0;
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSMutableArray<HPHistoryListData *> *)getHistroyListDataFromModels:(NSArray<HPBrowseModel *> *)models {
    if (models.count == 0) {
        return nil;
    }
    else if (models.count == 1) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        HPHistoryListData *data = [[HPHistoryListData alloc] init];
        [data.items addObject:models[0].shareSpaceDetail];
        NSString *str = [HPHistoryListData getDateYMDFromStr:models[0].updateTime];
        if (str) {
            [data setDateStr:str];
        }
        data.count = 1;
        [dataArray addObject:data];
        return dataArray;
    }
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    int splitIndex = 0;
    
    while (splitIndex != models.count - 1) {
        HPHistoryListData *data = [[HPHistoryListData alloc] init];
        
        for (int i = splitIndex; i < models.count; i ++) {
            HPBrowseModel *indexModel = models[i];
            NSString *indexDate = [HPHistoryListData getDateYMDFromStr:indexModel.updateTime];
            
            if (i == splitIndex) {
                [data.items addObject:indexModel.shareSpaceDetail];
                if (indexDate) {
                    [data setDateStr:indexDate];
                }
                data.count = 1;
            }
            else if (data.dateStr && indexDate && [indexDate isEqualToString:data.dateStr]) {
                [data.items addObject:indexModel.shareSpaceDetail];
                data.count ++;
            }
            else {
                [dataArray addObject:data];
                splitIndex = i;
                break;
            }
            
            if (i == models.count - 1) {
                [dataArray addObject:data];
                splitIndex = i;
            }
            
        }
    }
    
    return dataArray;
}

+ (NSString *)getDateYMDFromStr:(NSString *)str {
    if (str) {
        NSArray *strs = [str componentsSeparatedByString:@" "];
        if (strs.count > 1) {
            return strs[0];
        }
    }
    
    return nil;
}

@end
