//
//  Utility.h
//  Elsevier
//
//  Created by Kiwitech on 11/16/11.
//  Copyright 2011 kiwitech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	
    UsernameIncorrectErrorMsg,
    PasswordIncorrectErrorMsg,
	LoginFailureErrorMsg,
	NetworkErrorMessage,
	
	MailSettingsFailMessage,
	FacebookSharingSuccesfullMessage,
	FacebookSharingFailMessage,
	TwitterSharingSuccesfullMessage,
	
	TwitterSharingFailMessage,
	SectionAvailabilityFailureMessage,
	
} AlertViewMessageType;

void showAlert(AlertViewMessageType messageType);
void setObjectsAttrbutesValues(id object, id value);
UIColor* convertIntoRGB(float red, float green, float blue, float alpha);
 NSString* GetCachesDirPath();
 NSString* GetResourcePath();
BOOL isRetinaDevice();