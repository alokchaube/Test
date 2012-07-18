//
//  SearchResultsCell.h
//  SpringerLink
//
//  Created by Alok on 12/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 * this is subclass of UITableViewCell contain four label title, authors name, publication name and volume number page number. 
 */
@interface SearchResultsCell : UITableViewCell<UITextViewDelegate> {
    
    UILabel     *_titleLabel;
    UILabel     *_authorsLabel;
    UILabel     *_dateLabel;
    UIButton    *_btnPdfDownload;
    UILabel     *_articlelabel;
    UILabel     *_pagelabel;
    
    UIActivityIndicatorView *_spinner;
}

@property (nonatomic, readonly) UILabel  *articlelabel;
@property (nonatomic, readonly) UILabel  *pagelabel;
@property (nonatomic, readonly) UILabel  *dateLabel;
@property (nonatomic, readonly) UILabel  *titleLabel;
@property (nonatomic, readonly) UILabel  *authorsLabel;
@property (nonatomic, readonly) UIButton *btnPdfDownload;
@property (nonatomic, readonly) UIActivityIndicatorView *spinner;

@end
