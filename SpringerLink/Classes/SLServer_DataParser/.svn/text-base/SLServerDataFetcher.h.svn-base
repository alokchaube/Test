//
//  SLServerDataFetcher.h
//  SpringerLink
//
//  Created by Prakash Raj on 24/04/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ProtocolDecleration.h"

@interface SLServerDataFetcher : NSObject <ASIHTTPRequestDelegate> {
    
@private
    ASIHTTPRequest   *_httpRequest;
@public
    __unsafe_unretained id <SLServerDataFetcherDelegate>  _delegate;
}

@property (nonatomic, assign) id <SLServerDataFetcherDelegate> delegate;

- (void)fetchDataWithQuery:(NSString *)query;
- (void)stopFetching;
@end
