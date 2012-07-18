//
//  SearchResultsCell.m
//  SpringerLink
//
//  Created by Alok on 12/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import "SearchResultsCell.h"


@implementation SearchResultsCell
@synthesize articlelabel          = _articlelabel;
@synthesize pagelabel             = _pagelabel;
@synthesize titleLabel            = _titleLabel;
@synthesize authorsLabel          = _authorsLabel;
@synthesize btnPdfDownload        = _btnPdfDownload;
@synthesize dateLabel             = _dateLabel;
@synthesize spinner               =_spinner;


- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style 
                reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        //
        _articlelabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 5, 50, 15)];
        _articlelabel.backgroundColor = [UIColor clearColor];
        _articlelabel.text = @"Article";
        _articlelabel.textColor  = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self.contentView addSubview:_articlelabel];
        
        /* 
         uncomment it if show page range in article list.
         */
        
//        _pagelabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 5 , 100, 15)];
//        _pagelabel.backgroundColor = [UIColor clearColor];
//        _pagelabel.text = @"";
//        _pagelabel.textColor  = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
//        [_pagelabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
//        _pagelabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
//        [self.contentView addSubview:_pagelabel];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, 14, 300, 27)];
		_titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        
		[_titleLabel sizeToFit];
        _titleLabel.textColor  = [UIColor colorWithRed:1/255.0 green:118/255.0 blue:195/255.0 alpha:1.0];
		[self.contentView addSubview:_titleLabel];
       
        _authorsLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 36, 305, 13)];
        _authorsLabel.font = [UIFont systemFontOfSize:12];
        _authorsLabel.backgroundColor = [UIColor clearColor];
        _authorsLabel.textColor  = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        
        _authorsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_authorsLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 36, 130, 13)];
        _dateLabel.font = [UIFont systemFontOfSize:11];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor  = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
       
        _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:_dateLabel];
        
        _btnPdfDownload = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPdfDownload setFrame:CGRectMake(11, 50, 106, 25)]; 
        
        [_btnPdfDownload setTitleColor:[UIColor colorWithRed:1/255.0 green:118/255.0 blue:195/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_btnPdfDownload setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
        [_btnPdfDownload setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateHighlighted];
        //[_btnPdfDownload setBackgroundColor:[UIColor blueColor]];
        [self.contentView addSubview:_btnPdfDownload];
        
        //activity indicator
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.hidesWhenStopped = YES;
        [self.contentView addSubview:_spinner];
        
        if (isIphone) {
            
            [_btnPdfDownload.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
            [_articlelabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
            [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
            [_authorsLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
            [_dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
            
        } else {
            
            _authorsLabel.frame = CGRectMake(11, 36, 305, 16);
            _dateLabel.frame = CGRectMake(170, 36, 130, 16);
            [_btnPdfDownload.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [_articlelabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
            [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
            [_authorsLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
            [_dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        }
    }
    return self;
}
@end