//
//  NSString+Additions.h
//  UltraMusicFestival
//
//  Created by Ankur Srivastava on 2/9/11.
//  Copyright 2011 kiwitech. All rights reserved.
//

/* ***********************************************************************************************************
 
 This is category class of NSString Class which provide extra functionality to NSString class
 
 *********************************************************************************************************** */	

#import <Foundation/Foundation.h>


@interface NSString (Additions) 

// Escapes single quotes
-(NSString*)escQuotes;

//check whether the string object is containing email address or not
- (BOOL) isValidEmail;

//it return the date object created from an NSString object
//@param -> contain type of date format stored inside the NSString object
-(NSDate*)createDateFromStringWithDateFormat:(NSString*)dateFormat;
- (BOOL) isEmpty;

//check whether the string object is containing alphabets and number only or not
- (BOOL) isAlphaNumeric;
- (BOOL)isContainSubstring:(NSString*)subString;

//check whether the string object is containing email address or not
- (NSRange)getRangeOfString:(NSString*)subString;

//check whether the string object is containing alphabets and number only or not
- (BOOL) isNumeric;

// Adds an integer to a string's value
-(NSString*)addInt:(NSInteger)val;

//Check whether the string is pure alphabetic or not.----Raj.
- (BOOL)isAlphabaticString;
- (BOOL)isOnlySpace;
//method to get first word of string-----Raj.
- (NSArray *)words;

@end
