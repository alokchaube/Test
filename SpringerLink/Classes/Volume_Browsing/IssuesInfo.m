//
//  IssuesInfo.m
//  SpringerLink
//
//  Created by Alok on 11/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import "IssuesInfo.h"

@implementation IssuesInfo
@synthesize endId       = _endId;
@synthesize startId     = _startId;
@synthesize startPage   = _startPage;
@synthesize endPage     = _endPage;
@synthesize year        = _year;
@synthesize month       = _month;
@synthesize title       = _title;

- (id)init {
    
    self = [super init];
   
    if (self != nil) {
        
        _endId      = 0;
        _startId    = 0;
        _startPage  = 0; 
        _endPage    = 0;
        _year       = [NSMutableString new];
        _month      = [NSMutableString new];
        _title      = [NSMutableString new];
    }
    return self;
}

@end