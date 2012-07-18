//
//  AboutUsViewController.h
//  SpringerLink
//
//  Created by Prakash Raj on 23/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoaderView;
@interface AboutUsViewController : UIViewController <UISearchBarDelegate,UIWebViewDelegate> {
    
@private
    
    LoaderView           *_loader;
    
    IBOutlet UIImageView  *_imgViewTopbar; //image view at top.
    IBOutlet UIButton     *_topSearchBtn; //glass button to search.
    
    IBOutlet UIView       *_headersearchView; //view object open on click of glass search btn.
    IBOutlet UISearchBar  *_searchBar; //search bar object.
    IBOutlet UIButton     *_advCancelBtn; //button object Cancel/Advance.
    IBOutlet UIWebView *_webView; //web view to display about us text (in html formate).
}

- (IBAction)backClicked:(id)sender; //Action to go back.
- (IBAction)homeClicked:(id)sender; //Action to go Home.
- (IBAction)topSearchClicked:(id)sender; //Action performed when search glass clicked.

- (IBAction)advCancelBtnClicked:(id)sender; //Action performed when Cancel/Advanced button clicked.
@end
