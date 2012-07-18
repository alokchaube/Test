//
//  SectionHeaderView.m
//  SpringerLink
//
//  Created by Alok on 25/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//


/*
     File: SectionHeaderView.m
 Abstract: A view to display a section header, and support opening and closing a section.
  */

#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SectionHeaderView

@synthesize volumeLabel         = _volumeLabel;
@synthesize dateLabel           = _dateLabel;
@synthesize disclosureButton    = _disclosureButton;
@synthesize delegate            = _delegate;
@synthesize section             = _section;
@synthesize backgroundImageView = _backgroundImageView;


+ (Class)layerClass {
    
    return [CAGradientLayer class];
}


-(id)initWithFrame:(CGRect)frame title:(NSString*)title date:(NSString*)date section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)delegate {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];

        _delegate = delegate;        
        self.userInteractionEnabled = YES;
        
        if (isIpad) {
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
            imgView.image = [UIImage imageNamed:@"bar_slide_ipad.png"];
            [self addSubview:imgView];
            self.backgroundImageView = imgView;
            
            // Create and configure the title label.
            _section = sectionNumber;
            CGRect titleLabelFrame = self.bounds;
            titleLabelFrame.origin.x += 30.0;
            if ([title isEqualToString:@"Online First Articles"]) 
               titleLabelFrame.origin.y -= 3.0; 
            else titleLabelFrame.origin.y -= 13.0;            
            
            titleLabelFrame.size.width -= 35.0;
            CGRectInset(titleLabelFrame, 0.0, 5.0);
            UILabel *label = [[UILabel alloc] initWithFrame:titleLabelFrame];
            label.text = title;
            label.font = [UIFont boldSystemFontOfSize:17.0];
            label.shadowColor = [UIColor whiteColor];
            label.shadowOffset = CGSizeMake(0, 1);
            label.textColor = [UIColor colorWithRed:01/255.0 green:118/255.0 blue:195/255.0 alpha:1.0];
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            _volumeLabel = label;
            
            CGRect dateLabelFrame = self.bounds;
            dateLabelFrame.origin.x += 30.0;
            dateLabelFrame.size.width -= 33.0;
            dateLabelFrame.origin.y   += 13.0;
            CGRectInset(dateLabelFrame, 0.0, 5.0);
            UILabel *labelDate = [[UILabel alloc] initWithFrame:dateLabelFrame];
            labelDate.text = date;
            [labelDate setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
            labelDate.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            labelDate.backgroundColor = [UIColor clearColor];
            [self addSubview:labelDate];
            _dateLabel = labelDate;
            
            // Create and configure the disclosure button.
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0, 15.0, 35.0, 35.0);
            [button setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            _disclosureButton = button;
            
            // Set the colors for the gradient layer.
            static NSMutableArray *colors = nil;
            if (colors == nil) {
                colors = [[NSMutableArray alloc] initWithCapacity:3];
                UIColor *color = nil;
                color = [UIColor colorWithRed:0.82 green:0.84 blue:0.87 alpha:1.0];
                [colors addObject:(id)[color CGColor]];
                color = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
                [colors addObject:(id)[color CGColor]];
                color = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
                [colors addObject:(id)[color CGColor]];
            }
            [(CAGradientLayer *)self.layer setColors:colors];
            [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.48], [NSNumber numberWithFloat:1.0], nil]];
        }
        else {
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
            imgView.image = [UIImage imageNamed:@"bar_slide.png"];
            [self addSubview:imgView];
            self.backgroundImageView = imgView;
            
            // Create and configure the title label.
            _section = sectionNumber;
            CGRect titleLabelFrame = self.bounds;
            titleLabelFrame.origin.x += 30.0;
            titleLabelFrame.size.width -= 35.0;
            CGRectInset(titleLabelFrame, 0.0, 5.0);
            UILabel *label = [[UILabel alloc] initWithFrame:titleLabelFrame];
            label.text = title;
            label.font = [UIFont boldSystemFontOfSize:15.0];
            label.shadowColor = [UIColor whiteColor];
            label.shadowOffset = CGSizeMake(0, 1);
            label.textColor = [UIColor colorWithRed:01/255.0 green:118/255.0 blue:195/255.0 alpha:1.0];
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
            _volumeLabel = label;
            
            CGRect dateLabelFrame = self.bounds;
            dateLabelFrame.origin.x += 190.0;
            dateLabelFrame.size.width -= 33.0;
            CGRectInset(dateLabelFrame, 0.0, 5.0);
            UILabel *labelDate = [[UILabel alloc] initWithFrame:dateLabelFrame];
            labelDate.text = date;
            [labelDate setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
            labelDate.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            labelDate.backgroundColor = [UIColor clearColor];
            [self addSubview:labelDate];
            _dateLabel = labelDate;
            
            // Create and configure the disclosure button.
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0, 5.0, 35.0, 35.0);
            [button setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            _disclosureButton = button;
            
            // Set the colors for the gradient layer.
            static NSMutableArray *colors = nil;
            if (colors == nil) {
                colors = [[NSMutableArray alloc] initWithCapacity:3];
                UIColor *color = nil;
                color = [UIColor colorWithRed:0.82 green:0.84 blue:0.87 alpha:1.0];
                [colors addObject:(id)[color CGColor]];
                color = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
                [colors addObject:(id)[color CGColor]];
                color = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
                [colors addObject:(id)[color CGColor]];
            }
            [(CAGradientLayer *)self.layer setColors:colors];
            [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.48], [NSNumber numberWithFloat:1.0], nil]];
        }
        }
        // image view
      
    if (self.section == 1) {
        [self toggleOpenWithUserAction:YES];
    }
    
    return self;
}


-(IBAction)toggleOpen:(id)sender {
    
    
    [self toggleOpenWithUserAction:YES];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    self.disclosureButton.selected = !self.disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (self.disclosureButton.selected) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}




@end
