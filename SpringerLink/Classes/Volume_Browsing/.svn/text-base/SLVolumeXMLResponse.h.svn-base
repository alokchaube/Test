//
//  SLVolumeXMLResponse.h
//  SpringerLink
//
//  Created by Alok on 25/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IssuesInfo.h"

/**
 * This is a metadata responce class in which store the information of journal and volumes  after the XML parsing.
 * it contain the array of VolumeListInfo objects.
 * it contain the journal ID ,journal title etc.
 */

@class VolumeListInfo;

@interface SLVolumeXMLResponse : NSObject {
    NSMutableArray*      _records; 
    NSString*            _journalName; 
    NSString*            _JournalID; 
    NSString*            _JournalPrintISSN;
    NSString*            _JournalElectronicISSN;
    NSString*            _Editor_in_Chief;
    NSString*            _publisherName;
    
}
@property (nonatomic, retain)NSString*            JournalPrintISSN;
@property (nonatomic, retain)NSString*            JournalID;
@property (nonatomic, retain)NSString*            JournalElectronicISSN;
@property (nonatomic, retain)NSString*            journalName;
@property (nonatomic, retain)NSString*            Editor_in_Chief;
@property (nonatomic, retain)NSString*            publisherName;

@property (nonatomic, readonly) NSMutableArray*   records;


@end

@interface VolumeListInfo : NSObject {
@public
    NSString*                  _year;
    NSString*                 _startId;
    NSString*                 _endId;
    NSMutableArray      *_arrayIssues;
}
@property (nonatomic, readwrite) NSMutableArray*     arrayIssues;
@property (nonatomic, retain) NSString*     year;
@property (nonatomic, retain) NSString*        startId;
@property (nonatomic, retain) NSString*        endId;

// join the names seperated by comma
//- (NSString*)namesJoinedWithComma;
@end












