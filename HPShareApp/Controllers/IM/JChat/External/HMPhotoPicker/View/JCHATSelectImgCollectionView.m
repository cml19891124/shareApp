//
//  JCHATSelectImgCollectionView.m
//  JChat
//
//  Created by oshumini on 15/12/22.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATSelectImgCollectionView.h"

@implementation JCHATSelectImgCollectionView

- (void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(self.contentSize, CGSizeZero))
    {
      if (contentSize.height > self.contentSize.height)
      {
        CGPoint offset = self.contentOffset;
        offset.y += (contentSize.height - self.contentSize.height);
        self.contentOffset = offset;
      }
    }
  [super setContentSize:contentSize];
}

@end
