//
//  DownloadPdfTableViewCell.m
//  SpringerLink
//
//  Created by Kiwitech on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DownloadPdfTableViewCell.h"

@implementation DownloadPdfTableViewCell
@synthesize articalPublishedDate     = _articalPublishedDate;
@synthesize articalAuthorsName       = _articalAuthorsName;
@synthesize articalTitle             = _articalTitle;
@synthesize articalTitleCategoryType = _articalTitleCategoryType;
@synthesize reuseIdentifier;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier
{
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
