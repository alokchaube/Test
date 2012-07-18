//
//  SLServerDataFetcher.m
//  SpringerLink
//
//  Created by Prakash Raj on 24/04/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import "SLServerDataFetcher.h"

@implementation SLServerDataFetcher
@synthesize delegate=_delegate;

- (void)fetchDataWithQuery:(NSString *)query {
    
    NSURL *url = [NSURL URLWithString:[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    _httpRequest = [ASIHTTPRequest requestWithURL:url];
    [_httpRequest setDelegate:self];
    [_httpRequest startAsynchronous];
}

- (void)stopFetching {
    
    if([_httpRequest isExecuting])
        [_httpRequest clearDelegatesAndCancel];
}

#pragma mark- ASIHTTPRequest delegate

- (void)requestStarted:(ASIHTTPRequest *)request {
    NSLog(@"started");
}
- (void)requestFinished:(ASIHTTPRequest *)request {

    if(_delegate && [_delegate respondsToSelector:@selector(requestFinishedWithData:)])
        [_delegate requestFinishedWithData:[request responseData]];
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSLog(@"Failed");
    if(_delegate && [_delegate respondsToSelector:@selector(requestFailedWithError)])
        [_delegate requestFailedWithError];
}
@end
