//
//  DBArticle.h
//  SpringerLink
//
//  Created by Prakash Raj on 15/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved..
//

#import <Foundation/Foundation.h>

@interface DBArticle : NSObject 

@property (nonatomic,assign) short ID;
@property (nonatomic,copy)   NSString  *title;
@property (nonatomic,copy)   NSString  *type;
@property (nonatomic,copy)   NSString  *journalNo;
@property (nonatomic,copy)   NSString  *authors;
@property (nonatomic,copy)   NSString  *date;
@property (nonatomic,copy)   NSString  *doi;
@property (nonatomic,copy)   NSString  *artIssueId;
@property (nonatomic,assign) short refId; 

@end
