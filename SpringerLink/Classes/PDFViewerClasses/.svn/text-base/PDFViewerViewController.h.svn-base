//
//  PDFViewerViewController.h
//  SpringerLink
//
//  Created by Kiwitech on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDFHomeView;
@interface PDFViewerViewController : UIViewController <UISearchBarDelegate> {
    
    
    IBOutlet UIButton     *_topSearchBtn;
    
    IBOutlet UIView       *_headersearchView; //view object open on click of glass search btn.
    IBOutlet UISearchBar  *_searchBar; //search bar object.
    IBOutlet UIButton     *_advCancelBtn; //button object Cancel/Advance.
    
    __weak IBOutlet UIView *_navigationBarView;
    PDFHomeView            *_pdfView;
    NSString               *_pdfFileName;
}

@property (nonatomic, copy) NSString     *pdfFileName;

- (IBAction)onClickBackButton:(id)sender;
- (IBAction)onClickHomeButton:(id)sender;

- (IBAction)topSearchClicked:(id)sender;
- (IBAction)advCancelBtnClicked:(id)sender; //Action performed when Cancel/Advanced button clicked.
@end
