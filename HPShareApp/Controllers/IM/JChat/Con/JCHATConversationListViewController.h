//
//  JCHATChatViewController.h
//  JPush IM
//
//  Created by Apple on 14/12/24.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
#import "JCHATChatTable.h"
#import "HPBaseViewController.h"
@interface JCHATConversationListViewController : HPBaseViewController<UISearchBarDelegate,UISearchControllerDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,TouchTableViewDelegate,UIGestureRecognizerDelegate,JMessageDelegate,JMSGConversationDelegate>{
    
    UIAlertView *myAlertView;
    NSInteger cacheCount;
    BOOL isGetingAllConversation;
}
@property (nonatomic, strong) UIImageView *addBgView;
@property (weak, nonatomic) IBOutlet JCHATChatTable *chatTableView;
@property (assign, nonatomic)BOOL isDBMigrating;

@end
