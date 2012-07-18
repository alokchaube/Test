//
//  SLXMLResponse.h
//  SpringerLink
//
//  Created by Alok on 11/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetadataInfoResult.h"

/**
 * This is a metadata responce class in which store the information of metadata results article array and facet array  after the XML parsing.
 * it contain the object of MetadataInfoResult class.
 * it contain the array of Article objects.
 * it contain the array of Facet objects.
 */

@class Facet;

@interface SLXMLResponse : NSObject {
    NSString            *_query;
    //Articles
    NSMutableArray      *_records;
    NSMutableArray      *_facets;
    //Query Results
    MetadataInfoResult  *_currentResult;
}

@property (nonatomic, copy)     NSString*           query;
@property (nonatomic, readonly) NSMutableArray*     records;
@property (nonatomic, readonly) NSMutableArray*     facets;
@property (nonatomic, retain)   MetadataInfoResult* currentResult;

@end



@interface Article : NSObject <NSCoding> {
@private
    NSMutableString* _htmlBody;
    NSString*        _identifier;
    NSString*        _title;
    NSMutableArray*  _creators;         //Arr of strings
    NSString*        _publicationName;
    NSString*        _isbn;
    NSString*        _issn;
    NSString*        _journalId;
    NSString*        _doi;
    NSString*        _publisher;
    NSDate*          _publicationDate; 
    NSString*        _url;
    NSString*        _copyright;
    NSString*        _volume;
    NSString*        _number;
    NSString*        _startingPage;
}
@property (nonatomic, copy) NSMutableString*htmlBody;
@property (nonatomic, copy) NSString*       identifier;
@property (nonatomic, copy) NSString*       title;
@property (nonatomic, copy) NSMutableArray* creators;
@property (nonatomic, copy) NSString*       publicationName;
@property (nonatomic, copy) NSString*       isbn;
@property (nonatomic, copy) NSString*       issn;
@property (nonatomic, copy) NSString*       journalId;
@property (nonatomic, copy) NSString*       doi;
@property (nonatomic, copy) NSString*       publisher;
@property (nonatomic, retain) NSDate*       publicationDate;
@property (nonatomic, copy) NSString*       url;
@property (nonatomic, copy) NSString*       copyright;
@property (nonatomic, copy) NSString*       volume;
@property (nonatomic, copy) NSString*       number;
@property (nonatomic, copy) NSString*       startingPage;

- (NSString*)authors;
- (NSString*)allAuthors;
//•Journal Articles: YYYY, Volume ##, Number ##, p###
//(p stands for page number)
- (NSString*)composeVolumeNumberPage ;

@end


@interface Facet : NSObject {
@private
    NSString*              _name;
    NSMutableDictionary*   _facetCountByName;
}
@property (nonatomic, retain) NSString*                 name;
@property (nonatomic, retain) NSMutableDictionary*      facetCountByName;

// join the names seperated by comma
- (NSString*)namesJoinedWithComma;
@end












