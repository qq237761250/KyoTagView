//
//  KyoTagView.h
//  XFLH
//
//  Created by Kyo on 7/23/15.
//  Copyright (c) 2015 Kyo. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface KyoTagView : UIView

@property (nonatomic, strong) IBInspectable NSString *title;    /**< 标题 */
@property (nonatomic, assign) IBInspectable CGFloat fontSize;   /**< 字体大小 */
@property (nonatomic, strong) IBInspectable UIColor *color; /**< 字体和边框颜色（iamge为空时对边框有效） */
@property (nonatomic, strong) IBInspectable UIImage *image; /**< image边框（优先使用image做边框） */
@property (nonatomic, assign) IBInspectable CGFloat radius; /**< 圆角大小（在image为空时有效） */

- (id)initWithTitle:(NSString *)title withFrame:(CGRect)frame;

@end
