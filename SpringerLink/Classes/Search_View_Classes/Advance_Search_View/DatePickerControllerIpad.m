//
//  DatePickerControllerIpad.m
//  SpringerLink
//
//  Created by RAVI DAS on 15/06/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import "DatePickerControllerIpad.h"

@interface DatePickerControllerIpad ()

- (NSDate *)getDateFromStr:(NSString *)str;
- (void)setEnabilityOfDoneButton;
@end

@implementation DatePickerControllerIpad
@synthesize delegate = _delegate;
@synthesize selectedMonthYear = _selectedMonthYear;
@synthesize datePickerPopover;

short _startyear;
short _numberOfYears;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil 
                           bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    okButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed)];
    [okButton setTintColor:[UIColor colorWithRed:1/255.0 green:118/255.0 blue:195/255.0 alpha:1]];
    okButton.enabled = FALSE;
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
        
        self.title = @"Date Published";
        
        [self.navigationItem setLeftBarButtonItem:cancelButton animated:NO];
        [self.navigationItem setRightBarButtonItem:okButton animated:NO];
    pickerType = 0;
        
    
    
    _months = [[NSArray alloc] initWithObjects:@"All",
               @"January",@"February",@"March",
               @"April",@"May",@"June",
               @"July",@"August",@"September",
               @"October",@"November",@"December",nil];
    
    
    if(_selectedMonthYear && _selectedMonthYear.length) {
        
        NSArray *words = [_selectedMonthYear componentsSeparatedByString:@" "];
        
        if(words.count == 2) {
            
            [_lblMonthValue setText:[words objectAtIndex:0]];
            [_lblYearValue setText:[words objectAtIndex:1]];
            
        } else {
            
            [_lblYearValue setText:[words objectAtIndex:0]];
        }
        [self setEnabilityOfDoneButton];
    }
    
//    [_lblMonthValue becomeFirstResponder];
    [self btnMonthClicked:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(setEnabilityOfDoneButton)
                                                 name:UITextFieldTextDidChangeNotification 
                                               object:_lblYearValue];
    
    
    
    NSDictionary *_dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"volumeMetadata"];
    
    NSString *_dateStr = [_dict objectForKey:@"volumeDate"];
    NSArray  *_words = [_dateStr componentsSeparatedByString:@"-"];
    
    _startyear = [[_words objectAtIndex:1] intValue];
    _numberOfYears =  _startyear - [[_words objectAtIndex:0] intValue] +1;
}

- (void)viewDidUnload
{
    _months = nil;
    _lblMonthValue = nil;
    _lblYearValue = nil;
    okButton = nil;
    _picker = nil;
    
    _lblMonthValue = nil;
    _lblYearValue = nil;
    _btnMonth = nil;
    _btnYear = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation); 
}

#pragma mark- Button Actions.

//
- (void)cancelButtonPressed{
    if(_delegate && [_delegate respondsToSelector:@selector(didPickerCancel)])
        [_delegate didPickerCancel];
    
    [self.datePickerPopover dismissPopoverAnimated:YES];
}
- (void)doneButtonPressed{
    
    short mm = 0 ;
    if(_lblMonthValue.text.length > 0)
        mm = [_months indexOfObject:_lblMonthValue.text];
    short yy = [_lblYearValue.text intValue];
    
    if(_delegate && [_delegate respondsToSelector:@selector(didPickedMonth:andYear:)])
        [_delegate didPickedMonth:mm andYear:yy];
    
    [self.datePickerPopover dismissPopoverAnimated:YES];
}

- (IBAction)btnYearClicked:(id)sender {
    [_btnYear setImage:[UIImage imageNamed:@"bar_selected_year_iPad.png"] forState:UIControlStateNormal];
    [_btnMonth setImage:[UIImage imageNamed:@"bar_normal_month_iPad.png"] forState:UIControlStateNormal];
    _lblMonthValue.textColor = [UIColor colorWithRed:1/255.0 green:118/255.0 blue:195/255.0 alpha:1];
    _lblYearValue.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    
    _lblMonth.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    _lblYear.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    pickerType = 1;
    [_picker reloadAllComponents];
    if (![_lblYearValue.text isEqualToString:@""]) {
        // [self checkTextColorOfTextFields];
        
        
        short _selectedRow = 0;
        _selectedRow = _startyear-[_lblYearValue.text intValue];
        [_picker selectRow:_selectedRow inComponent:0 animated:YES];
    }
    else{
        [_picker selectRow:0 inComponent:0 animated:YES];
    }
}

- (IBAction)btnMonthClicked:(id)sender {
    [_btnYear setImage:[UIImage imageNamed:@"bar_normal_year_iPad.png"] forState:UIControlStateNormal];
    [_btnMonth setImage:[UIImage imageNamed:@"bar_selected_month_iPad.png"] forState:UIControlStateNormal];
    _lblYearValue.textColor = [UIColor colorWithRed:1/255.0 green:118/255.0 blue:195/255.0 alpha:1];
    _lblMonthValue.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    
    _lblYear.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    _lblMonth.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    
    pickerType = 2;
    [_picker reloadAllComponents];
    if (![_lblMonthValue.text isEqualToString:@""]) {
        //[self checkTextColorOfTextFields];
        
        
        short _selectedRow = 0;
        _selectedRow = [_months indexOfObject:_lblMonthValue.text]; 
        [_picker selectRow:_selectedRow inComponent:0 animated:YES]; 
    }
    
}
#pragma mark- Private methods

//method to convert text to date.
- (NSDate *)getDateFromStr:(NSString *)str {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM yyyy"];
    return [formatter dateFromString:str];
}


//method to check whether okButton should enable/disable
- (void)setEnabilityOfDoneButton {
    
    [okButton setEnabled:(_lblYearValue.text.length > 0)];
   
}


#pragma mark- UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView 
numberOfRowsInComponent:(NSInteger)component {
    
    if(pickerType == 0||pickerType == 2)
        return [_months count];
    return _numberOfYears;
}

#pragma mark- UIPickerViewDelegate

//returns width of component in pickerView
- (CGFloat)pickerView:(UIPickerView *)pickerView 
    widthForComponent:(NSInteger)component {
    
    return 240;
}
//set title of row in component of pickerView
- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component {
    
    if(pickerType == 0||pickerType == 2) {
        return [_months objectAtIndex:row];
    }
    return [NSString stringWithFormat:@"%i",_startyear-row];
    
}
//action performed when any row is selected in picker view
- (void)pickerView:(UIPickerView *)pickerView 
      didSelectRow:(NSInteger)row 
       inComponent:(NSInteger)component {
    
    if(pickerType == 2|| pickerType == 0) {
        
        (row <=0) ? [_lblMonthValue setText:@""] : [_lblMonthValue setText:[_months objectAtIndex:row]];
        if([_lblYearValue.text isEqualToString:@""])
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY"];
            NSString *yearString = [formatter stringFromDate:[NSDate date]];
           [_lblYearValue setText:yearString];
        }
        okButton.enabled = YES;
        
    } else if(pickerType == 1  ) {
        okButton.enabled = YES;
        
        [_lblYearValue setText:[NSString stringWithFormat:@"%i",_startyear-row]];
    }
}


@end
