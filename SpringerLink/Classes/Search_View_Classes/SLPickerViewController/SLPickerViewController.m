//
//  SLPickerViewController.m
//  SpringerLink
//
//  Created by Kiwitech on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SLPickerViewController.h"
#import "ALPickerView.h"
#import "Utility.h"

@implementation SLPickerViewController
@synthesize delegate = _delegate;
@synthesize selectedRow = _selectedRow;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Create some sample data
	_entries = [[NSArray alloc] initWithObjects:@"Relevance", @"Date/(most-recent first)", nil];
	_selectionStates = [[NSMutableDictionary alloc] init];
	
    for (NSString *key in _entries)
		[_selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	
    if(self.selectedRow == SortByRelevance) {
        [_selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[_entries objectAtIndex:0]];
        
    }else if(self.selectedRow == SortByDate) {
        [_selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[_entries objectAtIndex:1]];
    }
    
	// Init picker and add it to view
	_pickerView = [[ALPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
	_pickerView.delegate = self;
	[self.view addSubview:_pickerView];	
    [_pickerView reloadAllComponents];
    [self.view addSubview:_navigationBar];
}


#pragma mark - UIButton_Action_Handling
- (IBAction)onClickDoneButton:(id)sender {
    
    [UIView beginAnimations:@"moveField" context: nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	self.view.frame = CGRectMake(0, 460, 320, 260);
	[UIView commitAnimations];
    
    if([self.delegate respondsToSelector:@selector(onSelectingPickerRow:)]) {
        
        [self.delegate onSelectingPickerRow:_selectedTitle];
    }
}

- (IBAction)onClickCancelButton:(id)sender {
    
    [UIView beginAnimations:@"moveField" context: nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	self.view.frame = CGRectMake(0, 460, 320, 260);
	[UIView commitAnimations];
    
    if(self.selectedRow == SortByRelevance) {
            _selectedTitle = [_entries objectAtIndex:0];
        
    }else if(self.selectedRow == SortByDate) {
        _selectedTitle = [_entries objectAtIndex:1];
    }
    
    if([self.delegate respondsToSelector:@selector(onChangingPickerTitleSelection:)]) {
        [self.delegate onChangingPickerTitleSelection:_selectedTitle];
    }

}

#pragma mark -
#pragma mark ALPickerView delegate methods
- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView {
	return [_entries count];
}


- (NSString *)pickerView:(ALPickerView *)pickerView TitleTextForRow:(NSInteger)row {
    
    NSArray* array = [[_entries objectAtIndex:row] componentsSeparatedByString:@"/"];
    NSString* title = nil;

    if([array count] > 0) {
        title = [array objectAtIndex:0];
    }
    return title;
}


- (NSString *)pickerView:(ALPickerView *)pickerView detailTextForRow:(NSInteger)row {
    
    NSArray* array = [[_entries objectAtIndex:row] componentsSeparatedByString:@"/"];
    NSString* title = nil;
    
    if([array count] > 1) {
        title = [array objectAtIndex:1];
    }
    return title;
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row {
	return [[_selectionStates objectForKey:[_entries objectAtIndex:row]] boolValue];
}

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
    
    NSArray* array = [_selectionStates allKeys];
    
    for(id key in array) {
        [_selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
    }
    [_selectionStates setObject:[NSNumber numberWithBool:YES] forKey:[_entries objectAtIndex:row]];
    _selectedTitle = [_entries objectAtIndex:row];

    if([self.delegate respondsToSelector:@selector(onChangingPickerTitleSelection:)]) {
        [self.delegate onChangingPickerTitleSelection:_selectedTitle];
    }
}

- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
	// Check whether all rows are unchecked or only one
	if (row == -1)
		for (id key in [_selectionStates allKeys])
			[_selectionStates setObject:[NSNumber numberWithBool:NO] forKey:key];
	else
		[_selectionStates setObject:[NSNumber numberWithBool:NO] forKey:[_entries objectAtIndex:row]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    _navigationBar = nil;
    [super viewDidUnload];
}
@end
