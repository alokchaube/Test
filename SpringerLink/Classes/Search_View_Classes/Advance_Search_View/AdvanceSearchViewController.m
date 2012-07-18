//
//  AdvanceSearchViewController.m
//  SpringerLink
//
//  Created by Prakash Raj on 04/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import "AdvanceSearchViewController.h"

#import "Constant.h"
#import "Global.h"
#import "Utility.h"
#import "DBManager.h"
#import "ApplicationConfiguration.h"
#import "DetectNetworkConnection.h"
#import "NSString+Additions.h"
#import "FindControllerOnDifferentViewController.h"

#import "SearchResultViewController.h"
#import "DownloadedPDFListViewController.h"
#import "DatePickerControllerIpad.h"

#import "SpringerLinkAppDelegate.h"

@interface AdvanceSearchViewController ()
//private methods-
- (void)showDatePicker;
- (void)checkHomeBtnAppearance;
- (void)makeViewsLayoutAccToDown:(BOOL)flag;
- (void)checkTitleOfAdvCancelBtn;
- (void)moveScreenVerticallyUpBy:(NSInteger)yy;
- (void)checkEnablityOfClearAllBtn;
@end


@implementation AdvanceSearchViewController
@synthesize imgViewTopbar;

BOOL isOpenAccess; //a veriable is taken to detect the search shoud be in open access or not.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [imgViewTopbar addSubview:[Global shared].btnPdfView];
    [self checkEnablityOfClearAllBtn];
    
    if (isIphone) {
        [imgViewTopbar addSubview:[Global shared].imgViewBadge];
    }else {
        [[Global shared].btnPdfView addSubview:[Global shared].imgViewBadge]; 
    }  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isOpenAccess = NO;
    isSearchOpen = NO;
    [[[_searchBar subviews]objectAtIndex:0]removeFromSuperview];
    CGSize scrollviewContentSize = (isIphone) ? CGSizeMake(320, 413) : CGSizeMake(320, 704);
    [_detailScrollView setContentSize:scrollviewContentSize];
    _detailScrollView.customDelegate = self;
    [_headersearchView setHidden:YES];
}

- (void)viewDidUnload
{
     [super viewDidUnload];
    btnDatePicker = nil;
    _lblMonth = nil;
    _lblYear = nil;
    _dateBoxImageView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (isIphone) {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);   
    }
    else {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation); 
    }
}


#pragma mark- IBActions

-(IBAction)backClicked:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction)homeClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)topSearchClicked:(id)sender {
    
    [UIView beginAnimations:@"moveField"context: nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    BOOL shouldscreenDown = [_headersearchView isHidden];
    if(!shouldscreenDown)
        [_searchBar resignFirstResponder];
    [self makeViewsLayoutAccToDown:shouldscreenDown];
    
    [UIView commitAnimations];
}

- (IBAction)doneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)openAccessClicked:(id)sender {
    
    isOpenAccess = !isOpenAccess;
    NSString *_imageName = (isOpenAccess) ? @"checked_btn.png":@"uncheck_btn.png";
    [sender setImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
    [self checkEnablityOfClearAllBtn];
}

- (IBAction)clearAllClicked:(id)sender {
    
    _searchTermTextField.text = _authorTextField.text=
    _articleTextField.text = _keyConceptTextField.text =  _dateTextField.text = @"";
    
    isOpenAccess = NO;
    [_openAccessBtn setImage:[UIImage imageNamed:@"uncheck_btn.png"] forState:UIControlStateNormal];
    [sender setEnabled:NO];
   
    if (isIpad) {
        _lblYear.text =  _lblMonth.text = @""; 
    }  
}

- (IBAction)performSearch:(id)sender {
    
    if([[_searchTermTextField text] length] <=0 && [[_authorTextField text] length] <=0 && 
       [[_articleTextField text] length] <=0 && [[_keyConceptTextField text]length] <=0 &&
       [[_dateTextField text]length] <=0 && !isOpenAccess) {
        
        UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Alert !" message:@"Could not perform blank search." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        alrt = nil;
        return ;
    }
    
    if(![DetectNetworkConnection isNetworkConnectionActive]) {
        showAlert(NetworkErrorMessage);
        return;
    }
    
    [_searchTermTextField resignFirstResponder];
    [_authorTextField resignFirstResponder];
    [_articleTextField resignFirstResponder];
    [_keyConceptTextField resignFirstResponder];
    
    ConstraintsQuery* constraintsQuery = [[ConstraintsQuery alloc] init];
    FacetsQuery *  facetsQuery  = [[FacetsQuery alloc] init];
    constraintsQuery.journalArray = [NSArray arrayWithObject:kJournalName];

    if([[_authorTextField text] length] > 0) {
        NSArray* authorArray = [[[_authorTextField text]lowercaseString]words];
        constraintsQuery.authorNameArray = [[authorArray reverseObjectEnumerator] allObjects];
    }
    
    if([[_articleTextField text] length] > 0 && [[_articleTextField text]isAlphabaticString])
        constraintsQuery.titleArray = [NSArray arrayWithObjects:[[_articleTextField text]lowercaseString],nil];
    
    if([[_keyConceptTextField text] length] > 0)
        facetsQuery.keywords = [NSArray arrayWithObjects:[_keyConceptTextField text],nil];

    
    if([[_dateTextField text] length]) {
         
        if([[_dateTextField text] length] == 4) {
            
            facetsQuery.byYear = [[_dateTextField text] intValue];
            
        } else {
            
            NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
            [_formatter setDateFormat:@"MMMM yyyy"];
            
            NSDate *_date = [_formatter dateFromString:[_dateTextField text]];
            [_formatter setDateFormat:@"MMM"];
            facetsQuery.month = [_formatter stringFromDate:_date];
            [_formatter setDateFormat:@"yyyy"];
            facetsQuery.year  = [_formatter stringFromDate:_date];
        }
    }
   
    constraintsQuery.openaccess =  isOpenAccess;
    
    if(isIpad) {
        searchResultViewControllerObj = nil;
        searchResultViewControllerObj = [[SearchResultViewController alloc]initWithNibName:@"SearchResult_Ipad" bundle:nil]; 
        searchResultViewControllerObj.constraintsQuery  =  constraintsQuery;
        searchResultViewControllerObj.facetsQuery       =  facetsQuery;
        searchResultViewControllerObj.termsType         =  KeywordType;
        searchResultViewControllerObj.currentSortBy     =  SortByRelevance;
        
        if([[_searchTermTextField text] length] > 0) {
            searchResultViewControllerObj.searchKey = [_searchTermTextField text];
        }
        searchResultViewControllerObj.isBasicSearch     =  NO;
        searchResultViewControllerObj.shouldShowInDetailArea = YES;
        [searchResultViewControllerObj resetControlsFraming];
        [[Global shared] setSearchResultViewController:searchResultViewControllerObj];
       
        UINavigationController *detailNavController = [[UINavigationController alloc]initWithRootViewController:searchResultViewControllerObj];
        [detailNavController setNavigationBarHidden:YES];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController, detailNavController, nil];

    } else {
        
        SearchResultViewController *controller = 
        [FindControllerOnDifferentViewController findClass:[SearchResultViewController class] onViews:[self.navigationController viewControllers]];
        
        BOOL isControllerNil = (controller == nil);
        if(isControllerNil) {
            controller = [[SearchResultViewController alloc]initWithNibName:@"SearchResultViewController_iPhone" bundle:nil];
        }
        
        controller.constraintsQuery  =  constraintsQuery;
        controller.facetsQuery       =  facetsQuery;
        controller.termsType         =  KeywordType;
        controller.currentSortBy     =  SortByRelevance;
        
        if([[_searchTermTextField text] length] > 0) {
            controller.searchKey = [_searchTermTextField text];
        }
        controller.isBasicSearch     =  NO;
        controller.shouldShowInDetailArea = NO;
        
        if(!isControllerNil) {
            [controller performAdv_Search];
            [self.navigationController popToViewController:controller animated:YES]; 
            
        } else {
            [[Global shared] setSearchResultViewController:controller];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (IBAction)advCancelBtnClicked:(id)sender {
    
    if([sender tag] == 1) {
        
        [_searchBar resignFirstResponder];
        
    } else {
        
        /*
        [UIView beginAnimations: @"moveField"context: nil];
        [UIView setAnimationDelegate: self];
        [UIView setAnimationDuration: 0.5];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        
        [self makeViewsLayoutAccToDown:NO];
        
        [UIView commitAnimations];
         */
    }
}
- (IBAction)btnDatePickerClicked:(id)sender {
    UIButton *btn  = sender;
    
    _dateBoxImageView.image = [UIImage imageNamed:@"box_input_date_selected_iPad.png"];
    nextViewController = [[DatePickerControllerIpad alloc]initWithNibName:@"DatePickerControllerIpad" bundle:nil];
    nextViewController.delegate = self;
    nextViewController.selectedMonthYear = _dateTextField.text;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:nextViewController];
    
    _datePickerPopover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    nextViewController.datePickerPopover = _datePickerPopover;
    _datePickerPopover.delegate=self;
    [_datePickerPopover setPopoverContentSize:CGSizeMake(320, 453) animated:NO];
    if (isSearchOpen) {
        [_datePickerPopover presentPopoverFromRect:CGRectMake(btn.frame.origin.x+10+245, btn.frame.origin.y+100-scrollPointY, 44, 44) inView:self.splitViewController.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];  
    }
    else{
        
        [_datePickerPopover presentPopoverFromRect:CGRectMake(btn.frame.origin.x+10+245, btn.frame.origin.y+55, 44, 44) inView:self.splitViewController.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];//
    }
    
    
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{

    
    _dateBoxImageView.image = [UIImage imageNamed:@"box_input_date_iPad.png"];
}


#pragma mark- private method

//method to open date picker page.
- (void)showDatePicker {
    
    DatePickerViewController *datePickerViewController = [[DatePickerViewController alloc]initWithNibName:@"DatePickerViewController" bundle:nil];
    datePickerViewController.delegate = self;
    datePickerViewController.selectedMonthYear = _dateTextField.text;
    [self presentModalViewController:datePickerViewController animated:YES];
}

//Method to check either Home button should appear or not.
- (void)checkHomeBtnAppearance {
    
    [_homeBtn setHidden:!([[self.navigationController viewControllers] count]>2)];
}

/*
 Method to set view layout according to @param flag.Since the view is going up when top searchBar is not visible and goes down in contradiction.
 
 @param flag : YES/NO - Down/Up    (only for basic search)
 */
- (void)makeViewsLayoutAccToDown:(BOOL)flag {

    int margin;
    
    if (isIphone) {
        float searchBtnAlpha = (flag) ? .6 : 1;
        [_topSearchBtn setAlpha:searchBtnAlpha]; 
        margin = (flag) ? 46 : -46;
        
    } else {
        
        isSearchOpen = flag;
        margin = (flag) ? 40 : -40;
        NSString *_imageName = (flag) ? @"btn_search_dull_ipad.png" : @"btn_search_normal_ipad.png";
         [_topSearchBtn setImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
    }
    
    CGRect frame = _detailScrollView.frame;
    frame.origin.y += margin;
    frame.size.height -= margin;
    _detailScrollView.frame = frame;

    [_headersearchView setHidden:!flag];
}

/*
 This method sets Title/Image of cancel/advance button as comatible. 
 */
- (void)checkTitleOfAdvCancelBtn {
    
    NSString *_imageName = (_advCancelBtn.tag) ? @"btn_cancel.png" : @"btn_adv.png";
    [_advCancelBtn setImage:[UIImage imageNamed:_imageName] 
                   forState:UIControlStateNormal];
}

/*
 method to move screen vertically by @param : yy px.
 @param : yy - argument how much pix we need to move our vertically.
 used when keyboard appear and textfield is not visible.
 */
- (void)moveScreenVerticallyUpBy:(NSInteger)yy {
    
    [UIView beginAnimations: @"moveField"context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    CGRect frame = _detailScrollView.frame;
    frame.origin.y -= yy;
    _detailScrollView.frame = frame;
    
    [UIView commitAnimations];
}

//method to check Enablity of clear botton
- (void)checkEnablityOfClearAllBtn {

    BOOL _shouldEnable = (BOOL)( _searchTermTextField.text.length || _authorTextField.text.length ||
                          _articleTextField.text.length || _keyConceptTextField.text.length ||  _dateTextField.text.length || isOpenAccess);
   
    [_clearAllButton setEnabled:_shouldEnable];
}


#pragma mark- UITextFieldDelegate
#define KVerticalMove 63
#define KVerticalMoveIpad 83
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (isIphone) {
        
        if(textField == _dateTextField) {
            
            [self showDatePicker];
            return NO;
            
        } else if(textField == _keyConceptTextField) {
            
            // int vertMove = (_headersearchView.isHidden) ? KVerticalMove : KVerticalMove + 44;
            [self moveScreenVerticallyUpBy:KVerticalMove];
        }
    } 
    
    else {
        NSString *_deselectedImageName = @"box_input_text_iPad_new.png";
        NSString *_selectedImageName = @"box_input_text_active_iPad.png";
        
        [_searchTermTextFieldImageV setImage:[UIImage imageNamed:_deselectedImageName]];
        [_authorTextFieldImageV setImage:[UIImage imageNamed:_deselectedImageName]];
        [_articleTextFieldImageV setImage:[UIImage imageNamed:_deselectedImageName]];
        [_keyConceptTextFieldImageV setImage:[UIImage imageNamed:_deselectedImageName]];
        
        if(textField ==_searchTermTextField) {
            [_searchTermTextFieldImageV setImage:
             [UIImage imageNamed:_selectedImageName]];
        } else if (textField ==_authorTextField) {
            [_authorTextFieldImageV setImage:
             [UIImage imageNamed:_selectedImageName]];
        }
        else if (textField ==_articleTextField) {
            [_articleTextFieldImageV setImage:
             [UIImage imageNamed:_selectedImageName]];
        } else if (textField ==_keyConceptTextField) {
            [_keyConceptTextFieldImageV setImage:
             [UIImage imageNamed:_selectedImageName]];
            [self moveScreenVerticallyUpBy:KVerticalMoveIpad];  
        }
    }
    [self checkEnablityOfClearAllBtn];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if(isIphone) {
        
        if(textField == _keyConceptTextField){
            
            [self moveScreenVerticallyUpBy:-KVerticalMove];
        }
        
    } else {
         NSString *_deselectedImageName = @"box_input_text_iPad_new.png";
        
        if(textField ==_searchTermTextField) {
            [_searchTermTextFieldImageV setImage:
             [UIImage imageNamed:_deselectedImageName]];
        } else if (textField ==_authorTextField) {
            [_authorTextFieldImageV setImage:
             [UIImage imageNamed:_deselectedImageName]];
        }
        else if (textField ==_articleTextField) {
            [_articleTextFieldImageV setImage:
             [UIImage imageNamed:_deselectedImageName]];
        } else if (textField ==_keyConceptTextField) {
            [_keyConceptTextFieldImageV setImage:
             [UIImage imageNamed:_deselectedImageName]];
            [self moveScreenVerticallyUpBy:-KVerticalMoveIpad];  
        }
    }
    [self checkEnablityOfClearAllBtn];
    return YES;
}



#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    _advCancelBtn.tag = 1;
    [self checkTitleOfAdvCancelBtn];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    _advCancelBtn.tag = 0;
    [self checkTitleOfAdvCancelBtn];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    if([[_searchBar text] isOnlySpace]) {
        
        UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Could not perform blank search." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        alrt = nil;
        return;
    }
    
    SearchResultViewController* controller =
    [FindControllerOnDifferentViewController findClass:[SearchResultViewController class] onViews:[self.navigationController viewControllers]];
    
    if(controller != nil) {
        
        [controller reSearchWithQueryStr:searchBar.text];
        [self.navigationController popToViewController:controller animated:YES];
        
    } else {
        
        NSString *XIBFileName = isIphone ? @"SearchResultViewController_iPhone" : @"SearchResult_Ipad";
        
        SearchResultViewController *objSearchResult=[[SearchResultViewController alloc]initWithNibName:XIBFileName bundle:nil] ;
        ConstraintsQuery* constraintsQuery = [[ConstraintsQuery alloc] init];
        FacetsQuery *     facetsQuery      = [[FacetsQuery alloc] init];
        NSArray *arrJournals = [NSArray arrayWithObject:kJournalName];
        constraintsQuery.journalArray = arrJournals;
        constraintsQuery.openaccess = NO;
        objSearchResult.constraintsQuery = constraintsQuery;
        objSearchResult.facetsQuery = facetsQuery;
        objSearchResult.searchKey = searchBar.text;
        objSearchResult.termsType = KeywordType;
        objSearchResult.currentSortBy = SortByRelevance;
        objSearchResult.isBasicSearch = YES;
        
        [self.navigationController pushViewController:objSearchResult animated:YES];
        [[Global shared] setSearchResultViewController:objSearchResult];
    }
}

#pragma mark - DatePickerViewControllerDelegate

- (void)didPickedMonth:(short)month andYear:(short)year {
    
    if(!month) {
        if (isIpad) {
            _lblYear.text  = [NSString stringWithFormat:@"%i",year]; 
            _lblMonth.text = [NSString stringWithFormat:@"%@",@"All"];
        }
        
        [_dateTextField setText:[NSString stringWithFormat:@"%i",year]];
       
        if (_dateTextField.text > 0 && isIpad) {
            
             _dateBoxImageView.image = [UIImage imageNamed:@"box_input_date_iPad.png"];
            [self checkEnablityOfClearAllBtn];
        }
        return;
        
    } else {
        
        if (isIpad) {
            NSString *_dateStr = [NSString stringWithFormat:@"%i",month];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM"];
            NSDate *date = [formatter dateFromString:_dateStr];
            [formatter setDateFormat:@"MMMM"];
            _lblYear.text = [NSString stringWithFormat:@"%i",year]; 
            _lblMonth.text = [formatter stringFromDate:date];  
        } 
    }
    
    NSString *_dateStr = [NSString stringWithFormat:@"%i %i",month,year];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM yyyy"];
    NSDate *date = [formatter dateFromString:_dateStr];
    [formatter setDateFormat:@"MMMM yyyy"];
    
    [_dateTextField setText:[formatter stringFromDate:date]];
    if (_dateTextField.text>0&&isIpad) {
        _dateBoxImageView.image = [UIImage imageNamed:@"box_input_date_iPad.png"];
        
         [self checkEnablityOfClearAllBtn];
    }
    
}
- (void)didPickerCancel{
 _dateBoxImageView.image = [UIImage imageNamed:@"box_input_date_iPad.png"];
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    scrollPointY = scrollView.contentOffset.y;
    NSLog(@"ScrollPoint---%f", scrollView.contentOffset.y);
    
}

#pragma mark - CustomScrollViewDelegate

- (void)performTouchEndTasks {
    
    [_searchTermTextField resignFirstResponder];
    [_authorTextField resignFirstResponder];
    [_articleTextField resignFirstResponder];
    [_keyConceptTextField resignFirstResponder];
}


@end
