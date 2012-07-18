//
//  UILabelExtended.h
//  Elsevier
//
//  Created by Tarun on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 
 This custom class enhance the size of custom label.
 
*/

#import <Foundation/Foundation.h>


@interface UILabelExtended : UILabel {
   __weak id  customDelegate;
    SEL selector;
}

@property (nonatomic,assign)  SEL selector;;
@property (nonatomic,weak) id  customDelegate;
@end

@interface UILabel(UILabelCategory)
- (void)setHeightOfLabel;
- (void)setWidthOfLabel;
- (void)setHeightOfLabelWithMaxHeight:(float)maxHeight;
- (void)setWidthOfLabelWithMaxWidth:(float)maxWidth ;
@end