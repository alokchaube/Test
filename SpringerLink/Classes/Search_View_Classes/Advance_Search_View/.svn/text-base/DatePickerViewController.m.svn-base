//
//  DatePickerViewController.m
//  SpringerLink
//
//  Created by Prakash Raj on 04/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

- (NSDate *)getDateFromStr:(NSString *)str;
- (void)checkTextColorOfTextFields;
- (void)setEnabilityOfDoneButton;
@end

@implementation DatePickerViewController
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
    
    _months = [[NSArray alloc] initWithObjects:@"All",
              @"January",@"February",@"March",
              @"April",@"May",@"June",
              @"July",@"August",@"September",
              @"October",@"November",@"December",nil];
    
    _monthTextField.inputView = _picker;
    _yearTextField.inputView = _picker;
   
    
    if(_selectedMonthYear && _selectedMonthYear.length) {
        
        NSArray *words = [_selectedMonthYear componentsSeparatedByString:@" "];
        
        if(words.count == 2) {
            
            [_monthTextField setText:[words objectAtIndex:0]];
            [_yearTextField setText:[words objectAtIndex:1]];
            
        } else {
            
            [_yearTextField setText:[words objectAtIndex:0]];
        }
        [self setEnabilityOfDoneButton];
    }
    
     [_monthTextField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(setEnabilityOfDoneButton)
                                                 name:UITextFieldTextDidChangeNotification 
                                               object:_yearTextField];

    
    
    NSDictionary *_dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"volumeMetadata"];
    
    NSString *_dateStr = [_dict objectForKey:@"volumeDate"];
    NSArray  *_words = [_dateStr componentsSeparatedByString:@"-"];
    
    _startyear = [[_words objectAtIndex:0] intValue];
    _numberOfYears = [[_words objectAtIndex:1] intValue] - _startyear+1;
}

- (void)viewDidUnload
{
    _months = nil;
    _monthTextField = nil;
    _yearTextField = nil;
    _doneButton = nil;
    _picker = nil;
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation); 
}

#pragma mark- Button Actions.

- (IBAction)cancelClicked:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doneClicked:(id)sender {
    
    
    short mm = 0 ;
    if(_monthTextField.text.length > 0)
        mm = [_months indexOfObject:_monthTextField.text];
    short yy = [_yearTextField.text intValue];
   
    if(_delegate && [_delegate respondsToSelector:@selector(didPickedMonth:andYear:)])
       [_delegate didPickedMonth:mm andYear:yy];
    
    [self dismissModalViewControllerAnimated:YES];
    
}

#pragma mark- Private methods

//method to convert text to date.
- (NSDate *)getDateFromStr:(NSString *)str {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM yyyy"];
    return [formatter dateFromString:str];
}

//checks the text formatting style of text fields.
- (void)checkTextColorOfTextFields {
    
    int rgb1 = ([_monthTextField isFirstResponder]) ? 51 : 102;
    int rgb2 = ([_monthTextField isFirstResponder]) ? 102 : 51;
    
    _monthTextField.textColor = [UIColor colorWithRed:(float)rgb1/255 green:(float)rgb1/255 
                                               blue:(float)rgb1/255 alpha:.9];
    
    _yearTextField.textColor = [UIColor colorWithRed:(float)rgb2/255 green:(float)rgb2/255 
                                             blue:(float)rgb2/255 alpha:.9];
}

//method to check whether _doneButton should enable/disable
- (void)setEnabilityOfDoneButton {
    
    [_doneButton setEnabled:(_yearTextField.text.length > 0)];
    _doneButton.alpha = (_yearTextField.text.length > 0) ? 1 : .75;
}

#pragma mark- UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self checkTextColorOfTextFields];
    [_picker reloadAllComponents];
    
    short _selectedRow = 0;
    if(textField == _monthTextField && _monthTextField.text.length > 0) {
        
        _selectedRow = [_months indexOfObject:textField.text]; 
        
    } else if (textField == _yearTextField && _yearTextField.text.length > 0) {
        
        _selectedRow = _startyear+_numberOfYears-[textField.text intValue]-1;
        //_selectedRow = [textField.text intValue]-_startyear;
    }
    
    [_picker selectRow:_selectedRow inComponent:0 animated:YES];
}

#pragma mark- UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView 
numberOfRowsInComponent:(NSInteger)component {
    
    if([_monthTextField isFirstResponder])
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
    
    if([_monthTextField isFirstResponder]) {
        return [_months objectAtIndex:row];
    }
    return [NSString stringWithFormat:@"%i",_startyear+_numberOfYears-row-1];
    
}
//action performed when any row is selected in picker view
- (void)pickerView:(UIPickerView *)pickerView 
      didSelectRow:(NSInteger)row 
       inComponent:(NSInteger)component {
    
    if([_monthTextField isFirstResponder]) {
        
        (row <=0) ? [_monthTextField setText:@""] : [_monthTextField setText:[_months objectAtIndex:row]];
        
    } else if ([_yearTextField isFirstResponder]) {
        
        [_yearTextField setText:[NSString stringWithFormat:@"%i",_startyear+_numberOfYears-row-1]];
    }
}

@end
