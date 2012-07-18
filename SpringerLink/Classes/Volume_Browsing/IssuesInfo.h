//
//  IssuesInfo.h
//  SpringerLink
//
//  Created by Alok on 25/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//



#import <Foundation/Foundation.h>

/**
 * This is a IssuesInfo class in which store the information of Issues  endId, startId, startPage ,endPage after the XML parsing.
 * SLVolumeXMLRespone contain the object of this class.
 */
@interface IssuesInfo : NSObject {
   
    NSString*              _startId;            
    NSString*              _endId;            
    NSString*              _startPage;  
    NSString*              _endPage; 
    NSMutableString*       _year;
    NSMutableString*       _month;
    NSMutableString*       _title;
}

@property (nonatomic, strong) NSString           *startId;
@property (nonatomic, strong) NSString           *endId;
@property (nonatomic, strong) NSString           *startPage;
@property (nonatomic, strong) NSString           *endPage;
@property (nonatomic, strong) NSMutableString    *year;
@property (nonatomic, strong) NSMutableString    *month;
@property (nonatomic, strong) NSMutableString    *title;

@end