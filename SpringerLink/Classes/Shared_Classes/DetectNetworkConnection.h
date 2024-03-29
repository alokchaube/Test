//
//  DetectNetworkConnection.h
//  Atlas
//
//  Created by Tarun on 13/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/* ********************************************************************************************************************
	
			This class handle all the operations required for setting up / detecting up network connection
	
   ******************************************************************************************************************** */
 

@interface DetectNetworkConnection : NSObject 

//check whether there is any network connection or not 
+ (BOOL) isNetworkConnectionActive;
// Function used to check the network connectivity
+(BOOL)canConnectToWeb;
+(BOOL)checkForNetworkConnectievity;
@end
