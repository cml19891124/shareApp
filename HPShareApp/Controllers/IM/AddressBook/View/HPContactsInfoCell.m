//
//  TLRContactsInfoCell.m
//  TLRProject
//
//  Created by caominglei on 2018/11/16.
//  Copyright © 2018 TLR. All rights reserved.
//

#import "HPContactsInfoCell.h"

@implementation HPContactsInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userIcon.layer.cornerRadius = self.userIcon.frame.size.height/4;
    self.userIcon.layer.masksToBounds = YES;
    self.inviteContantBtn.layer.cornerRadius = 4;
    self.inviteContantBtn.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)inviteContactClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectChooseInviteSomebody)]) {
        [self.delegate selectChooseInviteSomebody];
    }
}

@end
