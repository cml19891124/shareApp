//
//  HPLabel.m
//  HPShareApp
//
//  Created by HP on 2019/2/23.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPLabel.h"

@implementation HPLabel
@synthesize verticalAlignment;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _verticalAlignment = VerticalAlignmentTop;
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}
- (VerticalAlignment)verticalAlignment
{
    return _verticalAlignment;
}
- (void)setVerticalAlignment:(VerticalAlignment)align
{
    _verticalAlignment = align;
    [self setNeedsDisplay];
}
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect rc = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (_verticalAlignment) {
        case VerticalAlignmentTop:
            rc.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            rc.origin.y = bounds.origin.y + bounds.size.height - rc.size.height;
            break;
        case VerticalAlignmentMidele:
        default:
            rc.origin.y = bounds.origin.y + (bounds.size.height - rc.size.height)/2;
            break;
    }
    return rc;
}
- (void)drawTextInRect:(CGRect)rect
{
    CGRect rc = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:rc];
}

@end
