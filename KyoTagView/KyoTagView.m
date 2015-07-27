//
//  KyoTagView.m
//  XFLH
//
//  Created by Kyo on 7/23/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import "KyoTagView.h"
#include <objc/runtime.h>

@interface KyoTagView()

- (void)setupDefault;   //设置默认属性值
- (NSMutableAttributedString *)getAttributedStringTitle:(NSString *)title;  //根据文字获得attributedstring
- (NSDictionary *)getPropertyNameList;  //获取所有属性
- (void)observeAllProperty; //监听所有属性变化
- (void)removeObserveAllProperty;   //移除监听所有属性变化

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
        _title = title;
        _imageIcon = imageIcon;
        _fontSize = fontSize;
        [self setupDefault];
        
        //计算size
        NSMutableAttributedString *attributedStringTitle = [self getAttributedStringTitle:_title];
        CGSize titleSize = [attributedStringTitle boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size;
        CGSize iconSize = _imageIcon ? _imageIcon.size : CGSizeZero;  //icon的size
        CGSize maxSize = CGSizeMake(fmax(titleSize.width, iconSize.width), fmax(titleSize.height, iconSize.height));  //标题size和图标size的最大size
        CGSize realSize = CGSizeMake(maxSize.width + marginSize.width + (imageIcon ? _space : 0),
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
        _title = title;
        _imageIcon = imageIcon;
        _fontSize = 9;
        [self setupDefault];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefault];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserveAllProperty];    //移除监听所有属性变化
}

- (void)drawRect:(CGRect)rect {
    if (_isShowBorder) {
        if (_imageBorder) {
            _imageBorder = [_imageBorder resizableImageWithCapInsets:UIEdgeInsetsMake(_imageBorder.size.height/2 - 1, _imageBorder.size.width/2 - 1, _imageBorder.size.height/2 - 1, _imageBorder.size.width/2 - 1)];
            [_imageBorder drawInRect:rect];
        } else if (_color) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, 1.0);
            CGContextSetStrokeColorWithColor(context, _color.CGColor);
            CGPathRef pathBorder = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(_radius, _radius)].CGPath;
            CGContextAddPath(context, pathBorder);
            CGContextDrawPath(context, kCGPathStroke);
            
            self.layer.cornerRadius = _radius;
            self.layer.masksToBounds = YES;
        }
    }
    
    if (_title && _color) {
        NSMutableAttributedString *attributedStringTitle = [self getAttributedStringTitle:_title];
        CGSize titleSize = [attributedStringTitle boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size;
        CGFloat titleTop = (rect.size.height - titleSize.height) / 2.0;
        CGFloat titleLeft = (rect.size.width - titleSize.width) / 2.0;
        if (_imageIcon) {
            if (_direction == KyoTagViewIconDirectionLeft) {
                titleLeft += _space / 2.0;
            } else {
                titleLeft -= _space / 2.0;
            }
        }
        [attributedStringTitle drawAtPoint:CGPointMake(titleLeft, titleTop)];
    }
}

#pragma mark --------------------
#pragma mark - Methods

- (void)setupDefault {
    _color = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0];
    self.backgroundColor = [UIColor clearColor];
    _radius = 4;
    _space = 2;
    _iconYInset = 0;
    _isShowBorder = YES;
    
    [self observeAllProperty];  //监听所有属性变化
}

//根据文字获得attributedstring
- (NSMutableAttributedString *)getAttributedStringTitle:(NSString *)title {
    UIFont *font = [UIFont systemFontOfSize:_fontSize];
    NSMutableAttributedString *attributedStringTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:_color}];
    if (_imageIcon) {
        NSTextAttachment *textAttachmentIcon = [[NSTextAttachment alloc] init];
        textAttachmentIcon.image = _imageIcon;
        if (_direction == KyoTagViewIconDirectionLeft) {
            textAttachmentIcon.bounds = CGRectMake(-_space, _iconYInset, textAttachmentIcon.image.size.width, textAttachmentIcon.image.size.height);
            NSAttributedString *attributedStringArrow = [NSAttributedString attributedStringWithAttachment:textAttachmentIcon];
            [attributedStringTitle insertAttributedString:attributedStringArrow atIndex:0];
        } else {
            textAttachmentIcon.bounds = CGRectMake(_space, _iconYInset, textAttachmentIcon.image.size.width, textAttachmentIcon.image.size.height);
            NSAttributedString *attributedStringArrow = [NSAttributedString attributedStringWithAttachment:textAttachmentIcon];
            [attributedStringTitle insertAttributedString:attributedStringArrow atIndex:title.length];
        }
    }
    
    return attributedStringTitle;
}

//获取所有属性
- (NSDictionary *)getPropertyNameList {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *propertyNameDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count; i++) {
        const char *propertyAttributes = property_getAttributes(properties[i]);
        const char *propertyName = property_getName(properties[i]);
        [propertyNameDictionary setObject:[NSString stringWithUTF8String: propertyAttributes] forKey:[NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertyNameDictionary;
}

//监听所有属性变化
- (void)observeAllProperty {
    NSDictionary *dictProperty = [self getPropertyNameList];
    for (NSInteger i = 0; i < dictProperty.allKeys.count; i++) {
        [self addObserver:self forKeyPath:dictProperty.allKeys[i] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
}

//移除监听所有属性变化
- (void)removeObserveAllProperty {
    NSDictionary *dictProperty = [self getPropertyNameList];
    for (NSInteger i = 0; i < dictProperty.allKeys.count; i++) {
        [self removeObserver:self forKeyPath:dictProperty.allKeys[i]];
    }
    
}

#pragma mark ----------------
#pragma mark - KVC/KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay];
}


@end
