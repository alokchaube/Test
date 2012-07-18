//
//  DBReferences.h
//  SpringerLink
//
//  Created by kiwitech kiwitech on 14/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBReferences : NSObject
@property (nonatomic, assign) short citiationNo;
@property (nonatomic, assign) short year;
@property (nonatomic, assign) short volumeID;
@property (nonatomic, assign) short firstPage;

@property (nonatomic,copy) NSString *journalTitle;
@property (nonatomic,copy) NSString *doi;
@property (nonatomic,copy) NSString *coi;
@property (nonatomic,copy) NSString *authorsStr;

@property (nonatomic,assign) short issueId; 
@property (nonatomic,copy) NSString *artDoi;
@end
