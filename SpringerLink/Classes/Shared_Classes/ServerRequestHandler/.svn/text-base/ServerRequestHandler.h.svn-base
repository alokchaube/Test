//
//  ServerRequestHandler.h
//  SpringerLink
//
//  Created by Kiwitech on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface RequestHandler : NSObject {
    
   __weak id            _delegate;
    SEL                 _selector;

    NSString            *_serverURL;
    ASIFormDataRequest  *_request;
    NSDictionary        *_responseDictonary;
    NSDictionary        *_objectInfoDictionary;
    NSString            *_doi;
    
}

@property (nonatomic, strong) ASIFormDataRequest    *request;
@property (nonatomic, strong) NSDictionary          *responseDictonary;
@property (nonatomic, strong) NSDictionary          *objectInfoDictionary;
@property (nonatomic, strong) NSString               *serverURL;
@property (nonatomic, weak)   id                    delegate;
@property (nonatomic, assign) SEL                   selector;
@property (nonatomic, assign) BOOL                   isHeader;
@property (nonatomic, copy)   NSString               *doi;


@end

@interface ServerRequestHandler : NSObject {
    
    NSMutableArray   *_requestArray;
    NSMutableArray   *_doiArray;
}
@property (nonatomic,retain)NSMutableArray   *doiArray;
+ (ServerRequestHandler *)sharedRequestHandler;
- (void)addRequest:(RequestHandler*)requestObject;
- (void)startRequets;
- (void)startRequetFromQueue;
@end
