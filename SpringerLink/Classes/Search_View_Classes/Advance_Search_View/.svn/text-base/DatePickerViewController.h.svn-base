//
//  DatePickerViewController.h
//  SpringerLink
//
//  Created by Prakash Raj on 04/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

/* *****************************************************************************************************
 
 This is view controller (subclass of UIViewController) which is used to pick the date.
 
 ************************************************************************************************** */

#import <UIKit/UIKit.h>
#import "ProtocolDecleration.h"

@interface DatePickerViewController : UIViewController 
<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate> {
    
@private
    //textfield objects-
    IBOutlet UITextField  *_monthTextField;
    IBOutlet UITextField  *_yearTextField;
    IBOutlet UIButton     *_doneButton;
    IBOutlet UIPickerView *_picker;
    
    //array of months-
    NSArray               *_months;
    NSString              *_selectedMonthYear;
    
    __unsafe_unretained id <PickerViewControllerDelegate> _delegate;
}
@property (nonatomic, retain) UIPopoverController *datePickerPopover;
@property (nonatomic,assign) id <PickerViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString *selectedMonthYear;


- (IBAction)cancelClicked:(id)sender;
- (IBAction)doneClicked:(id)sender;
@end
