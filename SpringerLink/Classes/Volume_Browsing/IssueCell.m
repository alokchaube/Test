//
//  IssueCell.m
//  SpringerLink
//
//  Created by Alok on 25/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//


/*
 File: IssueCell.h
 Abstract: Table view cell to display information about Issue.
 */

#import "IssueCell.h"
#import "IssuesInfo.h"


@implementation IssueCell

@synthesize titleLabel = _titleLabel;
@synthesize quotation  = _quotation;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 300, 31)];
        if (isIpad) {
            _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            _titleLabel.frame = CGRectMake(30, 14, 300, 40);
            _titleLabel.highlightedTextColor = [UIColor colorWithRed:01/255.0 green:118/255.0 blue:195/255.0 alpha:1.0];
        }
        else {
            _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
            _titleLabel.highlightedTextColor = [UIColor whiteColor];
        }
        _titleLabel.numberOfLines = 2;
        
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|
        UIViewAutoresizingFlexibleRightMargin; 
        _titleLabel.textColor = [UIColor colorWithRed:01/255.0 green:118/255.0 blue:195/255.0 alpha:1.0];
        
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setQuotation:(IssuesInfo*)newQuotation {
 
    if (_quotation != newQuotation) {
        _quotation = newQuotation;
        NSString *strDate = [NSString stringWithFormat:@"%@-%@-01",_quotation.year,_quotation.month];
        
        _titleLabel.text = [NSString stringWithFormat:@"Issue %@ - %@",_quotation.startId,[self getIssueDateFormate:strDate]];
    }
}
- (NSString *)getIssueDateFormate:(NSString*)strDate{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *objEndDate = [dateFormat dateFromString:strDate];
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"MMMM yyyy"];
    NSString *str = [dateFormat2 stringFromDate:objEndDate];
    return str;
}

@end

