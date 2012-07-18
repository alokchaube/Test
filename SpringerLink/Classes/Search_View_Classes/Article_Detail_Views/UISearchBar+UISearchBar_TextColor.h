//
//  UISearchBar+UISearchBar_TextColor.h
//  SpringerLink
//
//  Created by Alok on 06/07/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchBar (UISearchBar_TextColor)
- (UITextField *)field; //returns textField within searchBar.
- (UIColor *)textColor; //getting text color
- (void)setTextColor:(UIColor *)color; //set text color of search bar
- (void)setFont:(UIFont *)font;//set font of search bar
@end
