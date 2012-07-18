//
//  SLPickerViewController.h
//  SpringerLink
//
//  Created by Kiwitech on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALPickerView.h"
#import "ProtocolDecleration.h"

@interface SLPickerViewController : UIViewController<ALPickerViewDelegate> {
	
    NSArray                         *_entries;
	NSMutableDictionary             *_selectionStates;
	
	ALPickerView                    *_pickerView;
    NSString                        *_selectedTitle;   
    SortBy                          _selectedRow;   
    
    __weak id <PickerViewControllerDelegate> _delegate;
    __weak IBOutlet UINavigationBar *_navigationBar;
}

@property (nonatomic, weak) id <PickerViewControllerDelegate> delegate;
@property (nonatomic, assign) SortBy selectedRow;
- (IBAction)onClickDoneButton:(id)sender;
- (IBAction)onClickCancelButton:(id)sender;
@end
