//
//  SLArticleDataXMLParser.m
//  SpringerLink
//
//  Created by Prakash Raj on 24/04/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import "SLArticleDataXMLParser.h"
#import "SLServerXMLResponse.h"


typedef enum { 
    issueElement = 0,
    articleInfoElement,
    authorElement,
    abstractElement,
    bodyElement,
    refrencesElement
} Element;

@interface SLArticleDataXMLParser ()
- (NSDate *)dateFromStr:(NSString *)dtStr;
@end

@implementation SLArticleDataXMLParser
Element currentElement;

BOOL isCoi;

@synthesize delegate = _delegate;

- (void)parseData:(NSData *)data {
    
    //    NSString *XMLStr = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@",XMLStr);
    
    _response = [[SLServerXMLResponse alloc] init];
    
    if(_xmlParser == nil)
        _xmlParser = [[NSXMLParser alloc] initWithData: data];
    [_xmlParser setDelegate: self];
    [_xmlParser setShouldResolveExternalEntities:YES];
    [_xmlParser parse];
    
}

#pragma mark - NSXMLParser delegate

- (void)parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName 
  namespaceURI:(NSString *) namespaceURI 
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict {
    
    if([elementName isEqualToString:@"PublisherInfo"]){
		_publisherInfo = [[PublisherInfo alloc] init];
    }
    if([elementName isEqualToString:@"JournalInfo"]) {
        _journalInfo = [[JournalInfo alloc]init]; 
    }
    if([elementName isEqualToString:@"JournalSubjectGroup"]) {
        _journalSubjects = [[NSMutableArray alloc] init];
    }
    if([elementName isEqualToString:@"VolumeInfo"]) {
        _volumeInfo = [[VolumeInfo alloc] init];
    }
    if([elementName isEqualToString:@"IssueInfo"]) {
        currentElement = issueElement;
        _issueInfo = [[IssueInfo alloc] init];
    }
    if([elementName isEqualToString:@"Article"]) {
        _articleInfo = [[ArticleInfo alloc] init];
    }
    if([elementName isEqualToString:@"ArticleInfo"]) {
        currentElement = articleInfoElement;
    }
    if([elementName isEqualToString:@"AuthorGroup"]) { 
        currentElement = authorElement;
        _authorsArray = [[NSMutableArray alloc] init];
    }
    if([elementName isEqualToString:@"Author"]) { 
        _author = [[Author alloc] init];
    }
    if([elementName isEqualToString:@"Abstract"]) {
        currentElement = abstractElement;
    }
    if([elementName isEqualToString:@"Body"]) {
        currentElement = bodyElement;
    }
    
    if([elementName isEqualToString:@"OnlineDate"] ||
       [elementName isEqualToString:@"PrintDate"]||
       [elementName isEqualToString:@"CoverDate"]) {
        _dateString = [[NSMutableString alloc]initWithCapacity:11];
    }
    
    /////
    if([elementName isEqualToString:@"ArticleBackmatter"]) {
        currentElement = refrencesElement;
        _referencesArray = [[NSMutableArray alloc] init];        
        NSLog(@"ArticleBackmatter comes...");
    }
    if([elementName isEqualToString:@"Citation"] && currentElement == refrencesElement) {
        _refrences = [[References alloc] init];
    }
    
    if([elementName isEqualToString:@"Occurrence"] && currentElement == refrencesElement) {
        
        isCoi = [[attributeDict objectForKey:@"Type"] isEqualToString:@"COI"];
    } 
}

- (void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string {
    if(!_currentElementStr) 
        _currentElementStr = [[NSMutableString alloc] initWithString:string];
    else
        [_currentElementStr appendString:string];
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    
    if(_currentElementStr != nil)
        _currentElementStr = [[_currentElementStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];
    //    _currentElementStr = [[_currentElementStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] mutableCopy];
    //     _currentElementStr = [[_currentElementStr stringByReplacingOccurrencesOfString:@"                  " withString:@""] mutableCopy];
    
    if([elementName isEqualToString:@"PublisherName"]){
		_publisherInfo.publisherName = _currentElementStr;
    } else if([elementName isEqualToString:@"PublisherLocation"]) {
        _publisherInfo.publisherLocation = _currentElementStr;
    } else if([elementName isEqualToString:@"PublisherURL"]) {
        _publisherInfo.publisherURL = _currentElementStr;
    }
    
    if([elementName isEqualToString:@"JournalID"]) {
        _journalInfo.journalID = _currentElementStr;
    } else if([elementName isEqualToString:@"JournalPrintISSN"]) {
        _journalInfo.journalPrintISSN = _currentElementStr;
    } else if([elementName isEqualToString:@"JournalElectronicISSN"]) {
        _journalInfo.journalElectronicISSN = _currentElementStr;
    } else if([elementName isEqualToString:@"JournalTitle"]) {
        _journalInfo.journalTitle = _currentElementStr;
    } else if([elementName isEqualToString:@"JournalSubTitle"]) {
        _journalInfo.journalSubTitle = _currentElementStr;
    } else if([elementName isEqualToString:@"JournalAbbreviatedTitle"]) {
        _journalInfo.journalAbbreviatedTitle = _currentElementStr;
    } else if([elementName isEqualToString:@"JournalSubject"]) {
        [_journalSubjects addObject:_currentElementStr];
    } 
    
    if([elementName isEqualToString:@"VolumeIDStart"]) {
        _volumeInfo.volumeIDStart = [_currentElementStr integerValue];
    } else if([elementName isEqualToString:@"VolumeIDEnd"]) {
        _volumeInfo.volumeIDEnd = [_currentElementStr integerValue];
    } else if([elementName isEqualToString:@"VolumeIssueCount"]) {
        _volumeInfo.volumeIssueCount = [_currentElementStr integerValue];
    } 
    
    
    if(currentElement == issueElement) {
        if([elementName isEqualToString:@"IssueIDStart"]) {
            _issueInfo.issueIDStart = [_currentElementStr integerValue];
        } else if([elementName isEqualToString:@"IssueIDEnd"]) {
            _issueInfo.issueIDEnd = [_currentElementStr integerValue];
        } else if([elementName isEqualToString:@"IssueArticleCount"]) {
            _issueInfo.issueArticleCount = [_currentElementStr integerValue];
        } else if([elementName isEqualToString:@"PricelistYear"]) {
            _issueInfo.pricelistYear = [_currentElementStr integerValue];
        } else if([elementName isEqualToString:@"CopyrightHolderName"]) {
            _issueInfo.copyrightHolderName = _currentElementStr;
        } else if([elementName isEqualToString:@"CopyrightYear"]) {
            _issueInfo.copyrightYear = [_currentElementStr integerValue];
        } else if([elementName isEqualToString:@"OnlineDate"]) {
            _issueInfo.onlineDate = [self dateFromStr:_dateString];
            _dateString = nil;
        } else if([elementName isEqualToString:@"PrintDate"]) {
            _issueInfo.printDate = [self dateFromStr:_dateString];
            _dateString = nil;
        } else if([elementName isEqualToString:@"CoverDate"]) {
            [_dateString appendFormat:@"-1"];
            _issueInfo.coverDate = [self dateFromStr:_dateString];
            _dateString = nil;
        }
    }
    
    
    if(currentElement == articleInfoElement) {
        
        if([elementName isEqualToString:@"ArticleID"]) {
            _articleInfo.articleID = [_currentElementStr integerValue];
        } else if([elementName isEqualToString:@"ArticleSequenceNumber"]) {
            _articleInfo.articleSequenceNumber = [_currentElementStr integerValue];
        } else if([elementName isEqualToString:@"ArticleFirstPage"]) {
            _articleInfo.articleLastPage = [_currentElementStr integerValue];
        } else if([elementName isEqualToString:@"ArticleLastPage"]) {
            _articleInfo.articleLastPage = [_currentElementStr integerValue];
        } 
        else if([elementName isEqualToString:@"RegistrationDate"]) {
            _articleInfo.registrationDate = [self dateFromStr:_dateString];
            _dateString = nil;
        } else if([elementName isEqualToString:@"Received"]) {
            _articleInfo.receivedDate = [self dateFromStr:_dateString];
            _dateString = nil;
        } else if([elementName isEqualToString:@"Accepted"]) {
            _articleInfo.accepteddate = [self dateFromStr:_dateString];
            _dateString = nil;
        } else if([elementName isEqualToString:@"OnlineDate"]) {
            _articleInfo.onlineDate = [self dateFromStr:_dateString];
            _dateString = nil;
        } else if([elementName isEqualToString:@"ArticleCopyright"]) {
            _articleInfo.copyrightHolderName = _currentElementStr;
        } else if([elementName isEqualToString:@"CopyrightYear"]) {
            _articleInfo.copyrightYear = [_currentElementStr integerValue];
        } 
    }
    
    if(currentElement == authorElement) {
        if([elementName isEqualToString:@"Author"]) {
            [_authorsArray addObject:_author];
            _author = nil;
        }
        
        if([elementName isEqualToString:@"GivenName"]) {
            _author.givenName = _currentElementStr;
        } else if([elementName isEqualToString:@"FamilyName"]) {
            _author.familyName = _currentElementStr;
        }
    } 
    
    if([elementName isEqualToString:@"OrgDivision"]) {
        _articleInfo.orgDivision = _currentElementStr;
    } else if([elementName isEqualToString:@"OrgName"]) {
        _articleInfo.orgName = _currentElementStr;
    } else if([elementName isEqualToString:@"City"]) {
        _articleInfo.city = _currentElementStr;
    } else if([elementName isEqualToString:@"Postcode"]) {
        _articleInfo.postcode = _currentElementStr;
    } else if([elementName isEqualToString:@"Country"]) {
        _articleInfo.country = _currentElementStr;
    }
    
    if(currentElement == abstractElement) {
        if([elementName isEqualToString:@"Para"]) {
            _articleInfo.abstract = _currentElementStr;
        }
    }
    
    if([elementName isEqualToString:@"Year"]) {
        [_dateString appendFormat:@"%i",[_currentElementStr intValue]];;
    } else if([elementName isEqualToString:@"Month"]) {
        [_dateString appendFormat:@"-%i",[_currentElementStr intValue]];
    } if([elementName isEqualToString:@"Day"]) {
        [_dateString appendFormat:@"-%i",[_currentElementStr intValue]];
    }
    
    
    //----------references------
    
    if(currentElement == refrencesElement) {
        //NSLog(@"%@",elementName);
        if([elementName isEqualToString:@"Citation"]) {
            [_referencesArray addObject:_refrences];
            _refrences = nil;
            
        } 
        if ([elementName isEqualToString:@"CitationNumber"]) {
            NSRange r = NSMakeRange(0, [_currentElementStr length]-1);
            NSString *_str = [_currentElementStr substringWithRange:r]; 
            _refrences.citiationNo = [_str intValue];
            
        } 
        if ([elementName isEqualToString:@"Year"]) {
            
            _refrences.year = [_currentElementStr intValue];
            
        } 
        if ([elementName isEqualToString:@"JournalTitle"]) {
            
            _refrences.journalTitle = _currentElementStr;
            
        } 
        if ([elementName isEqualToString:@"VolumeID"]) {
            
            _refrences.volumeID = [_currentElementStr intValue];
            
        } 
        if ([elementName isEqualToString:@"FirstPage"]) {
            
            _refrences.firstPage = [_currentElementStr intValue];
            
        } 
        if ([elementName isEqualToString:@"RefSource"]) {
            if(_currentElementStr != nil && [_currentElementStr length]) {
                NSString *_str = [_currentElementStr stringByReplacingOccurrencesOfString:@"  " withString:@""];
                _refrences.authorsStr = (_refrences.authorsStr == nil) ? _currentElementStr :
                [NSString stringWithFormat:@"%@ %@",_refrences.authorsStr,[_str stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
            }
            //NSLog(@"see authors:%@", _refrences.authorsStr);
            
        } else if ([elementName isEqualToString:@"Emphasis"]) {
            
            if(_currentElementStr != nil && [_currentElementStr length]) {
                _refrences.authorsStr = (_refrences.authorsStr == nil) ? _currentElementStr :
                [NSString stringWithFormat:@"%@ %@",_refrences.authorsStr,_currentElementStr];
            }
               
        } else if ([elementName isEqualToString:@"BibUnstructured"]) {
            
            if(_currentElementStr != nil && [_currentElementStr length])
                _refrences.authorsStr = (_refrences.authorsStr == nil) ? _currentElementStr :
                [NSString stringWithFormat:@"%@%@",_refrences.authorsStr,_currentElementStr];
        } 
         
        if([elementName isEqualToString:@"Handle"]) {
            isCoi ? (_refrences.coi = _currentElementStr) : (_refrences.doi = _currentElementStr);
        }
    }
    
    _currentElementStr = nil;
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    _response.publisherInfo = _publisherInfo;
    
    _journalInfo.journalSubjects = _journalSubjects;
    _response.journalInfo = _journalInfo;
    
    _response.volumeInfo = _volumeInfo;
    _response.issueInfo = _issueInfo;
    
    _articleInfo.authorsArray = _authorsArray;
    _response.articleInfo = _articleInfo;
    
    _response.referencesList = _referencesArray;
    
    if(_delegate && [_delegate respondsToSelector:@selector(didRecieveResponse:)])
        [_delegate didRecieveResponse:_response];    
}

//formate: yyyy-mm-dd //
- (NSDate *)dateFromStr:(NSString *)dtStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dtStr];
}
@end
