//
//  SLSortListTableCell.m
//  SpringerLink
//
//  Created by kiwitech kiwitech on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SLSortListTableCell.h"

@implementation SLSortListTableCell
@synthesize titleLabel = _titleLabel;
@synthesize detailLabel = _detailLabel;

- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 100, 30)];
        [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
        [_titleLabel setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
        [self addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 5, 200, 30)];
        [_detailLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
        [_detailLabel setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
        [self addSubview:_detailLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
