//
//  DatePickerControllerIpad.h
//  SpringerLink
//
//  Created by RAVI DAS on 15/06/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ProtocolDecleration.h"

@interface DatePickerControllerIpad : UIViewController 
<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate> {
    
@private
    
     IBOutlet UIPickerView *_picker;
     IBOutlet UIButton *_btnMonth;
     IBOutlet UIButton *_btnYear;
     IBOutlet UILabel *_lblYear;
     IBOutlet UILabel *_lblMonth;
     IBOutlet UILabel *_lblYearValue;
     IBOutlet UILabel *_lblMonthValue;
     UIBarButtonItem *okButton;
    //array of months-
     NSArray               *_months;
     NSString              *_selectedMonthYear;
     short pickerType;
    
    __unsafe_unretained id <PickerViewControllerDelegate> _delegate;
}

@property (nonatomic, retain) UIPopoverController *datePickerPopover;
@property (nonatomic,assign) id <PickerViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString *selectedMonthYear;

- (IBAction)btnYearClicked:(id)sender;
- (IBAction)btnMonthClicked:(id)sender;

@end

