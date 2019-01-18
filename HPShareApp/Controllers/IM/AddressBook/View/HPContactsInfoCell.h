//
//  TLRContactsInfoCell.h
//  TLRProject
//
//  Created by caominglei on 2018/11/16.
//  Copyright © 2018 TLR. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HPContactsInfoCellDelegate  <NSObject>

/**
 邀请好友
 */
- (void)selectChooseInviteSomebody;
@end
NS_ASSUME_NONNULL_BEGIN

@interface HPContactsInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *inviteContantBtn;
@property (nonatomic, weak) id<HPContactsInfoCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
