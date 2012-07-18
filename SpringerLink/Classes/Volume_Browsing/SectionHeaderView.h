//
//  SectionHeaderView.h
//  SpringerLink
//
//  Created by Alok on 25/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//


/*
     File: SectionHeaderView.h
 Abstract: A view to display a section header, and support opening and closing a section.
 */

#import <Foundation/Foundation.h>
#import "ProtocolDecleration.h"

@interface SectionHeaderView : UIView  {
    
    UIImageView            *_backgroundImageView;
    __weak UILabel         *_volumeLabel;
    __weak UILabel         *_dateLabel;
    __weak UIButton        *_disclosureButton;
    
    __weak id <SectionHeaderViewDelegate> _delegate;

    NSInteger       _section;
}


@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, weak) UILabel  *volumeLabel;
@property (nonatomic, weak) UILabel  *dateLabel;
@property (nonatomic, weak) UIButton *disclosureButton;

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, weak) id <SectionHeaderViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title date:(NSString*)date section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)delegate;
-(void)toggleOpenWithUserAction:(BOOL)userAction;
@end



