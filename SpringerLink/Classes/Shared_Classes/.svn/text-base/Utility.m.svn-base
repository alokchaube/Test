//
//  Utility.m
//  Elsevier
//
//  Created by Kiwitech on 11/16/11.
//  Copyright 2011 __Kiwitech__. All rights reserved.
//

#import "Utility.h"
#import <objc/runtime.h>

void showAlert(AlertViewMessageType messageType){
    
    NSString* alertMessage = nil;
	NSString* msgHeader = nil;
	
	switch (messageType) {
		case UsernameIncorrectErrorMsg:{
			
			alertMessage = @"Please provide the valid Username.";
			msgHeader = @"Invalid Username!";
			break;
		}
        case PasswordIncorrectErrorMsg:{
			
			alertMessage = @"Please provide the valid Password.";
			msgHeader = @"Invalid Password!";
			break;
		}            
		case LoginFailureErrorMsg: {
			
			alertMessage = @"Invalid username and password combination. Try again.";
			msgHeader = @"Access Denied!";
			break;
		}			
		case NetworkErrorMessage: {
			
			alertMessage = @"";
			msgHeader = @"No internet connection";
			break;
		}
		case MailSettingsFailMessage: {
			
			alertMessage = @"Please set up an email account to send us feedback.";
			msgHeader = @"Fail!";			
			break;
		}	
		case FacebookSharingSuccesfullMessage: {
			
			alertMessage = @"Thank you for sharing.";
			msgHeader = @"Success!";			
			break;
		}
		case FacebookSharingFailMessage: {

			alertMessage = @"An error occurred while submitting your post. Please try again later.";
			msgHeader = @"Error!";			
			break;
		}
		case TwitterSharingSuccesfullMessage: {
			
			alertMessage = @"Thank you for sharing.";
			msgHeader = @"Success!";			
			break;
		}
		case TwitterSharingFailMessage: {
			
			alertMessage = @"An error occurred while submitting your post. Please try again later.";
			msgHeader = @"Error!";			
			break;
		}
		case SectionAvailabilityFailureMessage: {
			
			alertMessage = @"This article doesn't have section headers specified for quick browsing.";
			msgHeader = @"";
			break;
		}
		default:
			break;
	}
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:msgHeader message:alertMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	alertView=nil;
    return;
}

void setObjectsAttrbutesValues(id object, id value) {
   
	unsigned int outCount, i;
   objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        
         NSString* propAttrib = [NSString stringWithFormat:@"%s", property_getAttributes(property)];
        
        if(([propAttrib rangeOfString:@"T@\""].location != NSNotFound) ) {    
            [object setValue:value forKey:[NSString stringWithFormat:@"%s",property_getName(property)]];
        }
    }
    free(properties);
    properties = NULL;
}

inline  NSString* GetCachesDirPath(){
     
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);  
	NSString *documentsDirPath = [paths objectAtIndex:0];  
	return documentsDirPath;
} 

inline  NSString* GetResourcePath(){
     
	return [[NSBundle mainBundle] resourcePath];
}


inline BOOL isRetinaDevice() {
    
    BOOL hasHighResScreen = NO;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        if (scale > 1.0) {
            hasHighResScreen = YES;
        }
    }
    return hasHighResScreen;
}


//create a C function for converting any float values into uicolor object 
inline UIColor* convertIntoRGB(float red, float green, float blue, float alpha)
{	return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}