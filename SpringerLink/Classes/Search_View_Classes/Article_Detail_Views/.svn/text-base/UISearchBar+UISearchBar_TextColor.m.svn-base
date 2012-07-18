//
//  UISearchBar+UISearchBar_TextColor.m
//  SpringerLink
//
//  Created by Alok on 06/07/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import "UISearchBar+UISearchBar_TextColor.h"

@implementation UISearchBar (UISearchBar_TextColor)

- (UITextField *)field {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            return (UITextField *)subview;
        }
    }
    return nil;
}

- (UIColor *)textColor {
    return self.field.textColor;
}

/*
 set text color
 @param : color - specify color of text.
*/
- (void)setTextColor:(UIColor *)color {
    self.field.textColor = color;
}

/*
 set font
 @param : font - specify font.
 */
- (void)setFont:(UIFont *)font {
    self.field.font = font;
}
@end
