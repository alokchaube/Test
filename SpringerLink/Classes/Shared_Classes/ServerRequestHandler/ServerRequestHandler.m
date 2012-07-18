//
//  ServerRequestHandler.m
//  SpringerLink
// 
//  Created by Kiwitech on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerRequestHandler.h"
#import "XMLDictionary.h"
#import "ApplicationConfiguration.h"
@implementation RequestHandler

@synthesize request              = _request;
@synthesize responseDictonary    = _responseDictonary;
@synthesize delegate             = _delegate;
@synthesize selector             = _selector;
@synthesize isHeader             = _isHeader;
@synthesize serverURL            = _serverURL;
@synthesize objectInfoDictionary = _objectInfoDictionary;
@synthesize  doi                 = _doi;

@end


static ServerRequestHandler *_sharedServerRequestHnadler = nil;
@implementation ServerRequestHandler
@synthesize doiArray = _doiArray;

+ (ServerRequestHandler *)sharedRequestHandler {
    
	@synchronized(self) {
        if (_sharedServerRequestHnadler == nil) {
            _sharedServerRequestHnadler = [[self alloc] init];
        } 
    }
    return _sharedServerRequestHnadler;
}

- (void) addRequest:(RequestHandler*)requestObject {
    
    if(_requestArray == nil) {
        _requestArray = [[NSMutableArray alloc] initWithCapacity:5];
        _doiArray     = [[NSMutableArray alloc] initWithCapacity:5];
        [_requestArray addObject:requestObject];
    
    } else {
     
         [_requestArray addObject:requestObject];
    }
}

- (void)startRequets {
    // if object in queue is greater then 1 then request add to queue else start request
    
    if ([_requestArray count]<2&[_requestArray count]>0) {
        
        [self startRequetFromQueue];
    }
    
}

// fetch request from queue and start request
- (void)startRequetFromQueue{
    RequestHandler *objRequest = [_requestArray objectAtIndex:0];
    ASIHTTPRequest *_httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:objRequest.serverURL]];
    [_httpRequest setDelegate:self];
    if (objRequest.isHeader) {
        //[_httpRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"]; 
        [_httpRequest addRequestHeader:@"CASPER_API_KEY" value:kCasperAPIKey];    
    }
    [_httpRequest startAsynchronous]; 
}

#pragma mark- ASIHTTPRequest delegate
- (void)requestStarted:(ASIHTTPRequest *)request {
     NSLog(@"started");
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSLog(@"finished");
    
     RequestHandler *objRequest = [_requestArray objectAtIndex:0];
    
    NSDictionary* dictionary = nil;
    if(request.responseData)
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:request.responseData,@"response",@"NO",@"Error",objRequest.doi,@"doi",nil];
        //[NSDictionary dictionaryWithObject:request.responseData forKey:@"response"];
 #pragma clang diagnostic ignored "-Warc-performSelector-leaks"  
    
    if(objRequest.delegate != nil && [objRequest.delegate respondsToSelector:objRequest.selector])
        [objRequest.delegate performSelector:objRequest.selector withObject:dictionary withObject:objRequest.objectInfoDictionary];
    /*if(self.callbackFunction != nil)
     self.callbackFunction(dictionary);*/
    objRequest.responseDictonary = nil;
    objRequest.objectInfoDictionary = nil;
    [_requestArray removeObjectAtIndex:0];
    [_doiArray removeObjectAtIndex:0];
    NSLog(@"Total Count of request Array:%d",[_requestArray count]);
    if ([_requestArray count]>0) {
        [self startRequetFromQueue];
        NSLog(@"Start Method Called");
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"failed");
    
     RequestHandler *objRequest = [_requestArray objectAtIndex:0];
    NSDictionary* dictionary ;
    NSData *response = [[NSData alloc] init];
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:response,@"response",@"YES",@"Error",_doiArray,@"doi",nil];
    
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    if(objRequest.delegate != nil && [objRequest.delegate respondsToSelector:objRequest.selector])
        [objRequest.delegate performSelector:objRequest.selector withObject:dictionary withObject:objRequest.objectInfoDictionary];
    objRequest.responseDictonary = nil;
    objRequest.objectInfoDictionary = nil;
    [_requestArray removeAllObjects];
    [_doiArray removeAllObjects];
//    [_requestArray removeObjectAtIndex:0];
//    if ([_requestArray count]>0) {
//        [self startRequetFromQueue];
//        NSLog(@"Start Method Called");
//    }
}

@end

