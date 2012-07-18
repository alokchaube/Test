//
//  AdvanceSearchViewController.h
//  SpringerLink
//
//  Created by Prakash Raj on 04/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

/* *****************************************************************************************************
 
 This is view controller (subclass of UIViewController) which provide Advance search feature.
 
 ************************************************************************************************** */

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "CustomScrollView.h"

@class DatePickerControllerIpad;
@class SpringerLinkAppDelegate;
@class SearchResultViewController;

@interface AdvanceSearchViewController : UIViewController <UITextFieldDelegate,UISearchBarDelegate,
PickerViewControllerDelegate,CustomScrollViewDelegate,UIPopoverControllerDelegate> {
    
@private
    IBOutlet UIImageView      *imgViewTopbar; //image view at top.
    IBOutlet UIButton         *_homeBtn; // home btn object.
    IBOutlet UIButton         *_topSearchBtn; //glass button to search.
    IBOutlet UIView           *_headersearchView; //view object open on click of glass search btn.
    IBOutlet UISearchBar      *_searchBar; //search bar object.
    IBOutlet UIButton         *_advCancelBtn; //button object Cancel/Advance.
    
    IBOutlet CustomScrollView *_detailScrollView; //scroll view object contain rest controls.
    IBOutlet UIButton         *_clearAllButton; //clearAll button object.
    
    //Verious textField objects-
    IBOutlet UITextField      *_searchTermTextField; 
    IBOutlet UITextField      *_authorTextField;
    IBOutlet UITextField      *_articleTextField;
    IBOutlet UITextField      *_keyConceptTextField;
    IBOutlet UITextField      *_dateTextField;
    
    //----for ipad only----
    IBOutlet UIImageView      *_searchTermTextFieldImageV;
    IBOutlet UIImageView      *_authorTextFieldImageV;
    IBOutlet UIImageView      *_articleTextFieldImageV;
    IBOutlet UIImageView      *_keyConceptTextFieldImageV;
    
    IBOutlet UIButton         *_openAccessBtn; //openAccessBtn button object.
    IBOutlet UIButton         *btnDatePicker;
    IBOutlet UILabel          *_lblMonth;
    IBOutlet UILabel          *_lblYear;
    IBOutlet UIImageView      *_dateBoxImageView;
    
    UIPopoverController         *_datePickerPopover;
    DatePickerControllerIpad    *nextViewController;
    SearchResultViewController  *searchResultViewControllerObj;
    
    BOOL isSearchOpen;
    float scrollPointY;
}

@property (nonatomic,retain) IBOutlet UIImageView  *imgViewTopbar;

- (IBAction)backClicked:(id)sender; //Action to go back.
- (IBAction)homeClicked:(id)sender; //Action to go Home.
- (IBAction)topSearchClicked:(id)sender; //Action performed when search glass clicked.
- (IBAction)doneEditing:(id)sender; //Action performed when return type of textFields clicked. 
- (IBAction)openAccessClicked:(id)sender;
- (IBAction)clearAllClicked:(id)sender; //Action to clear all
- (IBAction)performSearch:(id)sender; //Action to search when search button clicked.
- (IBAction)advCancelBtnClicked:(id)sender; //Action performed when Cancel/Advanced button clicked.
- (IBAction)btnDatePickerClicked:(id)sender;

@end
