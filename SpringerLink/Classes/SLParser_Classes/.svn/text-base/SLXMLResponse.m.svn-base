//
//  MetadataResponse.m
//  SpringerLink
//
//  Created by Alok on 11/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import "SLXMLResponse.h"


@implementation SLXMLResponse

@synthesize query           = _query;
@synthesize currentResult   = _currentResult;
@synthesize records         = _records;
@synthesize facets          = _facets;

- (id)init {
    self = [super init];
    
    if (self != nil) {
        
        _query   = [NSString new];
        _records = [NSMutableArray new];
        _facets  = [NSMutableArray new];
    }
    return self;
}

@end

@implementation Article
@synthesize htmlBody        = _htmlBody;
@synthesize identifier      = _identifier;
@synthesize title           = _title;
@synthesize creators        = _creators;
@synthesize publicationName = _publicationName;
@synthesize isbn            = _isbn;
@synthesize issn            = _issn;
@synthesize journalId       = _journalId;
@synthesize doi             = _doi;
@synthesize publisher       = _publisher;
@synthesize publicationDate = _publicationDate;
@synthesize url             = _url;
@synthesize copyright       = _copyright;
@synthesize volume          = _volume;
@synthesize number          = _number;
@synthesize startingPage    = _startingPage;

- (id)init {
    self = [super init];
    if (self != nil) {
        _creators = [NSMutableArray new];
        _htmlBody = [NSMutableString new];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
	[encoder encodeObject:self.htmlBody forKey:@"htmlBody"];
	[encoder encodeObject:self.identifier forKey:@"identifier"];
	[encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.creators forKey:@"creators"];
    [encoder encodeObject:self.publicationName forKey:@"publicationName"];
    [encoder encodeObject:self.isbn forKey:@"isbn"];
    [encoder encodeObject:self.issn forKey:@"issn"];
    [encoder encodeObject:self.journalId forKey:@"journalId"];
    [encoder encodeObject:self.doi forKey:@"doi"];
    [encoder encodeObject:self.publisher forKey:@"publisher"];
    [encoder encodeObject:self.publicationDate forKey:@"publicationDate"];
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.copyright forKey:@"copyright"];
    [encoder encodeObject:self.volume forKey:@"volume"];
    [encoder encodeObject:self.number forKey:@"number"];
    [encoder encodeObject:self.startingPage forKey:@"startingPage"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if( self != nil )
	{
        //decode properties, other class vars
		self.htmlBody = [decoder decodeObjectForKey:@"htmlBody"];
		self.identifier = [decoder decodeObjectForKey:@"identifier"];
		self.title = [decoder decodeObjectForKey:@"title"];
        self.creators = [[decoder decodeObjectForKey:@"creators"] mutableCopy];
        self.publicationName = [decoder decodeObjectForKey:@"publicationName"];
        self.isbn = [decoder decodeObjectForKey:@"isbn"];
        self.issn = [decoder decodeObjectForKey:@"issn"];
        self.journalId = [decoder decodeObjectForKey:@"journalId"];
        self.doi = [decoder decodeObjectForKey:@"doi"];
        self.publisher = [decoder decodeObjectForKey:@"publisher"];
        self.publicationDate = [decoder decodeObjectForKey:@"publicationDate"];
        self.copyright = [decoder decodeObjectForKey:@"copyright"];
        self.volume = [decoder decodeObjectForKey:@"volume"];
        self.number = [decoder decodeObjectForKey:@"number"];
        self.startingPage = [decoder decodeObjectForKey:@"startingPage"];
	}
	return self;
}

- (NSString *)joinAuthors:(NSArray *)authors {
    NSMutableString* authorsStr = [NSMutableString string];
    int count = 0;
    for (NSString* auth in authors) {
        if (count != 0) {
            [authorsStr appendString:@"; "];
        }
        
        if (count < 2) {
            [authorsStr appendString:auth];
        }
        else {
            [authorsStr appendString:@",..."];
            break;
        }
        count++;
    }
    
//    if ([authors count] > 0) {
//        [authorsStr appendString:@"."];
//    }
    
    return authorsStr;
}

- (NSString*)authors {
    return [self joinAuthors:self.creators];
}

- (NSString*)allAuthors {
    return [self.creators componentsJoinedByString:@"; "];
}

//•Journal Articles: YYYY, Volume ##, Number ##, p###
//•Book Chapters: YYYY, p###
//(p stands for page number)
- (NSString*)composeVolumeNumberPage {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    
    NSMutableString* str = [NSMutableString string];
    
    if (self.publicationDate != nil) {
            [str appendString:[formatter stringFromDate:self.publicationDate]];
        }
        
//        BOOL volumeOrNumberExists = NO;
//    
//        if (self.volume && [_volume length] > 0) {
//            if (![str isEqualToString:@""]) {
//                [str appendString:@", "];
//            }
//            [str appendFormat:@"Volume %@", self.volume];
//            
//            volumeOrNumberExists = YES;
//        }
//    
//        if (self.number && [_number length] > 0) {
//            if (![str isEqualToString:@""]) {
//                [str appendString:@", "];
//            }
//            [str appendFormat:@"Number %@",self.number];
//            
//            volumeOrNumberExists = YES;
//        }
//        
//        if (volumeOrNumberExists && self.startingPage && [_startingPage length] > 0) {
//            if (![str isEqualToString:@""]) {
//                [str appendString:@", "];
//            }
//            [str appendFormat:@"p %@",self.startingPage];
//        }
    
   return str;
}

@end

@implementation Facet
@synthesize name             = _name;
@synthesize facetCountByName = _facetCountByName;

- (id)init {
    self = [super init];
    
    if (self != nil) {
        _facetCountByName = [NSMutableDictionary new];
    }
    
    return self;
}

- (NSString*)namesJoinedWithComma {
    
    return [[_facetCountByName allKeys] componentsJoinedByString:@", "];
}
@end









