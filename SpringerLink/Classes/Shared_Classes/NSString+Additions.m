//
//  NSString+Additions.m
//  UltraMusicFestival
//
//  Created by Ankur Srivastava on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+Additions.h"


@implementation NSString (Additions) 

-(NSString*)escQuotes {
	return [self stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

//check whether the string object is containing email address or not
- (BOOL) isValidEmail {
	//create an set of possible characters which can be contained by NSString object		
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	//create predicate using possible characters , and the NSString should be match with these predicate
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
	return [emailTest evaluateWithObject:self];
}

//check whether the string object is containing email address or not
- (BOOL)isContainSubstring:(NSString*)subString {
	
	@try {
		
		if(self.length > 0) {
			
			return	([self rangeOfString:subString].location != NSNotFound) ? YES : NO;
		}
	}
	@catch (NSException * e) {
		
		NSLog(@"\n\n Exception Generated ->>>>>>>> %@",[e reason]);
	}
	
	return NO;
}

//check whether the string object is containing email address or not
- (NSRange)getRangeOfString:(NSString*)subString {
	
	@try {
		
		if(self.length > 0) {
			
			NSRange range = [self rangeOfString:subString];
			return	(range.location != NSNotFound) ? range : NSMakeRange(-1, -1);
		}
	}
	@catch (NSException * e) {
		
		NSLog(@"\n\n Exception Generated ->>>>>>>> %@",[e reason]);
	}
	
	return NSMakeRange(-1, -1);
}

//it return the date object created from an NSString object
//@param -> contain type of date format stored inside the NSString object
- (NSDate*)createDateFromStringWithDateFormat:(NSString*)dateFormat {
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:dateFormat];	
	return [dateFormatter dateFromString:self];
}

//check whether the string object is containing email address or not
- (BOOL)isEmpty {
	if(self.length > 0)
		return NO;
	return YES;
}

//check whether the string object is containing alphabets and number only or not
- (BOOL)isAlphaNumeric {
    NSCharacterSet *unwantedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];	
    return ([self rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
}

//check whether the string object is containing number only or not
- (BOOL)isNumeric {
    NSCharacterSet *unwantedCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
	return ([self rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
}

// Adds an integer to a string's value
- (NSString*)addInt:(NSInteger)val {
	return [NSString stringWithFormat:@"%d", [self intValue] + val];
}

// method to check the string is alphabatic or not.
- (BOOL)isAlphabaticString {
    NSString *_regex = @"[A-Za-z_]*"; 
    NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _regex]; 
    return [_predicate evaluateWithObject:self];
}
// method to check the string is only space.
- (BOOL)isOnlySpace {
    NSArray *words = [self componentsSeparatedByString:@" "];
    BOOL flag = YES;
    for (NSString *str in words) {
        if([str length] > 0)
            flag = NO;
    }
    return flag;
}


- (NSArray *)words {
   NSMutableArray *words = [[self componentsSeparatedByString:@" "] mutableCopy];
    [words removeObject:@""];
    return words;
}

@end
