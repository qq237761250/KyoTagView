//
//  KyoTagView.m
//  XFLH
//
//  Created by Kyo on 7/23/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoTagView.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define KyoTagViewSizeWithFont(text, font) [text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero
#else
#define KyoTagViewSizeWithFont(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero
#endif

@interface KyoTagView()

- (void)setupDefault;

@end

@implementation KyoTagView

#pragma mark --------------------
#pragma mark - CycLife

- (id)initWithTitle:(NSString *)title withFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        [self setupDefault];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.image) {
        self.image = [self.image resizableImageWithCapInsets:UIEdgeInsetsMake(self.image.size.height/2 - 1, self.image.size.width/2 - 1, self.image.size.height/2 - 1, self.image.size.width/2 - 1)];
        [self.image drawInRect:rect];
    } else if (self.color) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context, self.color.CGColor);
        CGPathRef pathBorder = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.radius, self.radius)].CGPath;
        CGContextAddPath(context, pathBorder);
        CGContextDrawPath(context, kCGPathStroke);
        
        self.layer.cornerRadius = self.radius;
        self.layer.masksToBounds = YES;
    }
    
    if (self.title && self.color) {
        UIFont *font = [UIFont systemFontOfSize:self.fontSize];
        CGSize titleSize = KyoTagViewSizeWithFont(self.title, font);
        NSInteger left = (rect.size.width - titleSize.width) / 2;
        NSInteger top = (rect.size.height + self.fontSize) / 2 - 1;
        [self.title drawWithRect:CGRectMake(left, top, rect.size.width, rect.size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:self.color} context:NULL];
    }
    
}


#pragma mark --------------------
#pragma mark - Methods

- (void)setupDefault {
//    self.image = [UIImage imageNamed:@"com_tag_border"];
    self.fontSize = 9;
    self.color = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0];
    self.backgroundColor = [UIColor clearColor];
    self.radius = 4;
}


@end
