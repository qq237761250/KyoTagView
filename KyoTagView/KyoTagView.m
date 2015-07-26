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

- (id)initWithTitle:(NSString *)title withPoint:(CGPoint)point withMargin:(CGSize)marginSize {
    return [self initWithTitle:title withPoint:point withMargin:marginSize withIcon:nil];
}

- (id)initWithTitle:(NSString *)title withPoint:(CGPoint)point withMargin:(CGSize)marginSize withIcon:(UIImage *)imageIcon {
    return [self initWithTitle:title withPoint:point withMargin:marginSize withIcon:imageIcon withFontSize:9];
}

- (id)initWithTitle:(NSString *)title withPoint:(CGPoint)point withMargin:(CGSize)marginSize withIcon:(UIImage *)imageIcon withFontSize:(CGFloat)fontSize {
    self = [super init];
    if (self) {
        self.title = title;
        self.imageIcon = imageIcon;
        self.fontSize = fontSize;
        [self setupDefault];
        
        //计算size
        NSMutableAttributedString *attributedStringTitle = [self getAttributedStringTitle:self.title];
        CGSize titleSize = [attributedStringTitle boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size;
        CGSize iconSize = self.imageIcon ? self.imageIcon.size : CGSizeZero;  //icon的size
        CGSize maxSize = CGSizeMake(fmax(titleSize.width, iconSize.width), fmax(titleSize.height, iconSize.height));  //标题size和图标size的最大size
        CGSize realSize = CGSizeMake(maxSize.width + marginSize.width + (imageIcon ? self.space : 0),
                                     maxSize.height + marginSize.height);  //真实size
        self.frame = CGRectMake(point.x, point.y, realSize.width, realSize.height);
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title withFrame:(CGRect)frame {
    return [self initWithTitle:title withFrame:frame withIcon:nil];
}

- (id)initWithTitle:(NSString *)title withFrame:(CGRect)frame withIcon:(UIImage *)imageIcon {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.imageIcon = imageIcon;
        self.fontSize = 9;
        [self setupDefault];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.isShowBorder) {
        if (self.imageBorder) {
            self.imageBorder = [self.imageBorder resizableImageWithCapInsets:UIEdgeInsetsMake(self.imageBorder.size.height/2 - 1, self.imageBorder.size.width/2 - 1, self.imageBorder.size.height/2 - 1, self.imageBorder.size.width/2 - 1)];
            [self.imageBorder drawInRect:rect];
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
    }
    
    if (self.title && self.color) {
        NSMutableAttributedString *attributedStringTitle = [self getAttributedStringTitle:self.title];
        CGSize titleSize = [attributedStringTitle boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size;
        CGFloat titleTop = (rect.size.height - titleSize.height) / 2.0;
        CGFloat titleLeft = (rect.size.width - titleSize.width) / 2.0;
        if (self.imageIcon) {
            if (self.direction == KyoTagViewIconDirectionLeft) {
                titleLeft += self.space / 2.0;
            } else {
                titleLeft -= self.space / 2.0;
            }
        }
        [attributedStringTitle drawAtPoint:CGPointMake(titleLeft, titleTop)];
    }
}


#pragma mark --------------------
#pragma mark - Methods

- (void)setupDefault {
    self.color = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0];
    self.backgroundColor = [UIColor clearColor];
    self.radius = 4;
    self.space = 2;
    self.iconYInset = 0;
    self.isShowBorder = YES;
}

//改变地区名
- (NSMutableAttributedString *)getAttributedStringTitle:(NSString *)title {
    UIFont *font = [UIFont systemFontOfSize:self.fontSize];
    NSMutableAttributedString *attributedStringTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:self.color}];
    if (self.imageIcon) {
        NSTextAttachment *textAttachmentIcon = [[NSTextAttachment alloc] init];
        textAttachmentIcon.image = self.imageIcon;
        if (self.direction == KyoTagViewIconDirectionLeft) {
            textAttachmentIcon.bounds = CGRectMake(-self.space, self.iconYInset, textAttachmentIcon.image.size.width, textAttachmentIcon.image.size.height);
            NSAttributedString *attributedStringArrow = [NSAttributedString attributedStringWithAttachment:textAttachmentIcon];
            [attributedStringTitle insertAttributedString:attributedStringArrow atIndex:0];
        } else {
            textAttachmentIcon.bounds = CGRectMake(self.space, self.iconYInset, textAttachmentIcon.image.size.width, textAttachmentIcon.image.size.height);
            NSAttributedString *attributedStringArrow = [NSAttributedString attributedStringWithAttachment:textAttachmentIcon];
            [attributedStringTitle insertAttributedString:attributedStringArrow atIndex:title.length];
        }
    }
    
    return attributedStringTitle;
}


@end
