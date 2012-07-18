
#import "SLService.h"
#import "Constant.h"
#import "ApplicationConfiguration.h"

static NSString* const SpringerMetadataApiKey = @"bgv3jaw6bcqjcjp6gcqt62ar";
static NSString* const SpringerOpenAccessApiKey = @"re4jxecxyt8ucvwuchsnjney";
static NSString* const SpringerXmlDataApiKey = @"e7n578r8kqtppjg6df5m9ca9";


@implementation SLService


- (NSString*) urlEncodeParameter:(NSString*)paramToEncode {
	NSString* str = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
																		(__bridge CFStringRef)paramToEncode,
																		NULL,
																		(CFStringRef)@"!*'();:@&=+$,/?%#[]",
																		kCFStringEncodingUTF8 );
	return str;
}

- (NSString *)search:(NSString *)searchStr 
         startNumber:(int)num 
     numberOfResults:(int)numRez 
         facetsQuery:(FacetsQuery *)facetsQueryOrNil
    constraintsQuery:(ConstraintsQuery *)constraintsQueryOrNil
            termsType:(TermsType)termsType
{

    NSMutableString* query = [NSMutableString string];    
    
    if (searchStr != nil) {
        NSString *parameterName = @"";
        
        if (termsType == SubjectType) {
            
                parameterName = @"\"%@\"";
        } else if (termsType == AuthorType || termsType == EditorType) {
            parameterName = @"name:\"%@,%@\"";
        } else if (termsType == PublicationType) {
            parameterName = @"journal:\"%@\" OR book:\"%@\"";
        } else if (termsType == KeywordType) {
            parameterName = @"\"%@\"";
        }
        
        if (!facetsQueryOrNil.keywords) {
            if (termsType == PublicationType) {                
                [query appendString:[NSString stringWithFormat:parameterName, searchStr, searchStr]];
            } else if (termsType == AuthorType || termsType == EditorType) {
                NSArray *names = [searchStr componentsSeparatedByString:@"|"];
                [query appendString:[NSString stringWithFormat:parameterName, [names objectAtIndex:0], [names objectAtIndex:1]]];
            } else {
                [query appendString:searchStr];
            }
            [query appendString:@" "];
        }  
        if (termsType == MostRecentType) {
            [query appendString:@" sort:date "]; 
        }
        else if (termsType == SequenceType) {
            
            [query appendString:@" sort:sequence "];
            
        } 
    } else if (termsType == MostRecentType) {
        
        [query appendString:@" sort:date "];
        [query appendString:@"journal:\""];
//        @"journal:\"European Radiology\""
        [query appendString:kJournalName];
        [query appendString:@"\""];
        
    }   
    
    

    NSString* facetsQ = [facetsQueryOrNil quertString];
    NSString* constrainsQ = [constraintsQueryOrNil quertString];
    if (facetsQ != nil || constrainsQ != nil) {        
        if (facetsQ) {
            [query appendString:facetsQ];
        }

        if (facetsQ != nil && constrainsQ != nil)
            [query appendString:@" "];

        
        if (constrainsQ)
            [query appendString:constrainsQ];
    }
    
    //[q appendString:@" sort:date"];
    NSString * queryString = [self urlEncodeParameter:query];
//	NSMutableString * urlString = !constraintsQueryOrNil.openaccess ? [NSMutableString stringWithFormat:@"%@metadata/pam?q=%@&api_key=%@&s=%d&p=%d",KServerURL, queryString, SpringerMetadataApiKey, num, numRez] : [NSMutableString stringWithFormat:@"%@openaccess/pam?q=%@&api_key=%@&s=%d&p=%d",KServerURL ,queryString, SpringerOpenAccessApiKey, num, numRez];
    NSMutableString * urlString;
    if (!constraintsQueryOrNil.openaccess &!constraintsQueryOrNil.onlineFirst) {
       urlString = [NSMutableString stringWithFormat:@"%@metadata/pam?q=%@&api_key=%@&s=%d&p=%d",KServerURL, queryString, SpringerMetadataApiKey, num, numRez];
    }
    else if(constraintsQueryOrNil.openaccess) {
      urlString =  [NSMutableString stringWithFormat:@"%@openaccess/pam?q=%@&api_key=%@&s=%d&p=%d",KServerURL ,queryString, SpringerOpenAccessApiKey, num, numRez];
    }
    else if(constraintsQueryOrNil.onlineFirst) {
     urlString =   [NSMutableString stringWithFormat:@"%@metadata/pam?q=%@JournalOnlineFirst%@&api_key=%@&s=%d&p=%d",KServerURL, queryString,[self urlEncodeParameter:@":true"], SpringerMetadataApiKey, num, numRez];
        
    }
	
	return urlString;
}

- (NSString *)detailDataForDOI:(NSString *)doi
                   startNumber:(int)num 
               numberOfResults:(int)numRez 
                   facetsQuery:(FacetsQuery *)facetsQueryOrNil
              constraintsQuery:(ConstraintsQuery *)constraintsQueryOrNil
{
	NSString * q = doi;
	NSMutableString * urlString = [NSMutableString stringWithFormat:@"%@xmldata/app?q=doi:%@&api_key=%@&s=%d&p=%d",KServerURL, q, SpringerXmlDataApiKey, num, numRez];
    
    return urlString;
}

- (NSString *)getBookThumbinalImage:(NSString*)isbn  {
	NSMutableString * urlString = [NSMutableString stringWithFormat:@"http://coverimages.cmgsites.com/book/%@.jpg", isbn];
   
    return urlString;
}

- (NSString *)getJournalThumbinalImage:(NSString*)journalid 
                                   vol:(NSString*)vol
                                 issue:(NSString*)issue
                               
{
    NSString *format = vol && issue ? @"%@_%@_%@" : @"%@";
    
	NSMutableString * urlString = [NSMutableString stringWithFormat:@"http://coverimages.cmgsites.com/journal/%@.jpg", format, journalid, vol,issue];
    
    NSLog(@"URL for journal cover: %@", urlString);
    
	return urlString;
}
@end



@implementation FacetsQuery
@synthesize subjects;
@synthesize keywords;
@synthesize pub;
@synthesize byYear;
@synthesize toYear;
@synthesize contentType;
@synthesize country;
@synthesize imageType;
@synthesize month;
@synthesize year;

- (void)encodeWithCoder:(NSCoder *)aCoder {
	if ([aCoder isKindOfClass:[NSKeyedArchiver class]]) {
		NSKeyedArchiver* coder = (NSKeyedArchiver*)aCoder;
		[coder encodeObject:subjects forKey:@"subjects"];
		[coder encodeObject:keywords forKey:@"keywords"];
        [coder encodeInteger:byYear forKey:@"byYear"];
        [coder encodeInteger:toYear forKey:@"toYear"];
        [coder encodeInteger:contentType forKey:@"contentType"];
		[coder encodeObject:country forKey:@"country"];
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init]; 
	if ([aDecoder isKindOfClass:[NSKeyedUnarchiver class]]) {
		NSKeyedUnarchiver* decoder = (NSKeyedUnarchiver*)aDecoder;
        subjects = [decoder decodeObjectForKey:@"subjects"] ;
        keywords = [decoder decodeObjectForKey:@"keywords"] ;
        byYear = [decoder decodeIntegerForKey:@"byYear"];
        toYear = [decoder decodeIntegerForKey:@"toYear"];
        contentType = [decoder decodeIntegerForKey:@"contentType"];
        country = [decoder decodeObjectForKey:@"country"] ;
	}
	return self;
}



- (NSString*)quertString {
    _months = [[NSArray alloc] initWithObjects:
               @"Jan",@"Feb",@"Mar",
               @"Apr",@"May",@"Jun",
               @"Jul",@"Aug",@"Sep",
               @"Oct",@"Nov",@"Dec",nil];
    NSMutableArray* compponents = [NSMutableArray array];
    NSString *subQuery = @"";
    
    if ([subjects count] > 0) {
        if ([subjects count] == 1) {
             [compponents addObject:[NSString stringWithFormat:@"\"%@\"",[subjects objectAtIndex:0]]];
        }else {
            for (NSString *item in subjects) {
                subQuery = [subQuery stringByAppendingFormat:@"\"%@\" ", item];
            }            
            [compponents addObject:[NSString stringWithFormat:@"(%@)", subQuery]];
        }
    }

    subQuery = @"";
    
    if ([keywords count] > 0) {
        [compponents addObject:@"keyword:"];
        for (NSString *item in keywords) {
            subQuery = [subQuery stringByAppendingFormat:@"\"%@\" ", item];
        }                    

        [compponents addObject:[NSString stringWithFormat:@"%@",subQuery]];
    }
    if (self.month != nil &&self.year != nil) {
        [compponents addObject:@"(date:"];
        
        NSString *strMnthQuerry = [self getMnthURLStr];
        [compponents addObject:strMnthQuerry];
        [compponents addObject:@")"];
        NSLog(@"%@",strMnthQuerry);
        
    }

    if (byYear > 0) {
        [compponents addObject:@"year:"];
        [compponents addObject:[NSString stringWithFormat:@"%i",byYear]];
        
    }

    return [compponents componentsJoinedByString:@" "];
}

/*
 * return the URL string in date formate like: 2011-01-02 OR 2011-01-03
 */
- (NSString *)getMnthURLStr
{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@""];
    int count = [self numberOfDaysInMonth:[_months indexOfObject:month]+1 
                                  forYear:[year intValue]];
    
    NSString *mnth = [NSString stringWithFormat:@"0%i",[_months indexOfObject:month]+1];
    if([_months indexOfObject:month]+1>9)
        mnth = [mnth substringFromIndex:1];
    
    for(int k = 1; k<= count; k++) {
        if(k<10)
            [str appendFormat:@"%i-%@-0%i OR ",[year intValue],mnth,k];
        else
            [str appendFormat:@"%i-%@-%i OR ",[year intValue],mnth,k]; 
    }
    str = [[str substringToIndex:[str length] - 4]mutableCopy]; // removing last " OR " from str
    
    return str;
}
/*
 * Returning number of days in any month of any year
 * @param : mm - month number like 1 for jan, 2 for feb ...12 for Dec.
 * @param : yy - year number like 2000,2001....
 */
- (int)numberOfDaysInMonth:(int)mm forYear:(int)yy {
    if(mm==2)
        return  ((yy % 400 == 0) ? 29 :
                 ((yy % 100 == 0) ? 28 :
                  ((yy % 4  == 0 ) ? 29 :28 )));
    return  (mm <= 7)? (mm %2 == 1 ?31 : 30) : (mm %2 == 1 ?30 : 31);
}


@end


@implementation ConstraintsQuery
@synthesize doi     = _doi;
@synthesize isbn    = _isbn;
@synthesize issn    = _issn;
@synthesize orgName = _orgName;

@synthesize titleArray   = _titleArray;
@synthesize journalArray = _journalArray;
@synthesize bookArray    = _bookArray;
@synthesize dateArray    = _dateArray;

@synthesize authorNameArray   = _authorNameArray;
@synthesize openaccess        = _openaccess;
@synthesize onlineFirst       = _onlineFirst;

- (void)encodeWithCoder:(NSCoder *)aCoder {
	if ([aCoder isKindOfClass:[NSKeyedArchiver class]]) {
		
        NSKeyedArchiver* coder = (NSKeyedArchiver*)aCoder;
		[coder encodeObject:_doi forKey:@"doi"];
		[coder encodeObject:_titleArray forKey:@"titles"];
		[coder encodeObject:_isbn forKey:@"isbn"];
		[coder encodeObject:_issn forKey:@"issn"];
		[coder encodeObject:_orgName forKey:@"orgName"];
		[coder encodeObject:_journalArray forKey:@"jornals"];
		[coder encodeObject:_bookArray forKey:@"books"];
		[coder encodeObject:_authorNameArray forKey:@"names"];
        [coder encodeObject:_dateArray forKey:@"dates"];
        
        [coder encodeBool:_openaccess forKey:@"openaccess"];
        [coder encodeBool:_onlineFirst forKey:@"onlineFirst"];
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init]; 
	if ([aDecoder isKindOfClass:[NSKeyedUnarchiver class]]) {
		NSKeyedUnarchiver* decoder = (NSKeyedUnarchiver*)aDecoder;
        
        _doi     = [decoder decodeObjectForKey:@"doi"] ;
        _isbn    = [decoder decodeObjectForKey:@"isbn"];
        _issn    = [decoder decodeObjectForKey:@"issn"];
        _orgName = [decoder decodeObjectForKey:@"orgName"];
        
        _titleArray  = [decoder decodeObjectForKey:@"titles"];

        _journalArray = [decoder decodeObjectForKey:@"jornals"];
        _bookArray    = [decoder decodeObjectForKey:@"books"];
        _dateArray    = [decoder decodeObjectForKey:@"dates"];
        _openaccess   = [decoder decodeBoolForKey:@"openaccess"];
        _onlineFirst   = [decoder decodeBoolForKey:@"onlineFirst"];
       

        _authorNameArray   = [decoder decodeObjectForKey:@"names"];
	}
	return self;
}



- (NSString*)quertString {
    
    NSMutableArray* compponents = [NSMutableArray array];
    NSString *subQuery = @"";
    
    if ([_authorNameArray count] > 0) {
        
        if ([_authorNameArray count] == 1) {
            [compponents addObject:[NSString stringWithFormat:@"name:\"%@\"",[_authorNameArray objectAtIndex:0]]];
        }
        else {
            [compponents addObject:@"name:\""];
            int count=0;
            for (NSString *item in _authorNameArray) {
                subQuery = [subQuery stringByAppendingFormat:@"%@", item];
                count++;
                if (count<[_authorNameArray count]) {
                    subQuery = [subQuery stringByAppendingFormat:@"%@", @","];
                       
                }
            }            
            
            [compponents addObject:subQuery];
            [compponents addObject:@"\""];
        }
    }
   
    if ([_journalArray count] > 0) {
        
        if ([_journalArray count] == 1) {
            [compponents addObject:[NSString stringWithFormat:@"journal:\"%@\"",[_journalArray objectAtIndex:0]]];
        }
        else {
            for (NSString *item in _journalArray) {
                subQuery = [subQuery stringByAppendingFormat:@"\"%@\" ", item];
            }            
            
            [compponents addObject:[NSString stringWithFormat:@"journal:(%@)", subQuery]];
        }
        
        //[compponents addObject:@" AND "];
        subQuery = @"";
    }
    else if ([_journalArray count] > 0) {
        
        if ([_journalArray count] == 1) {
            [compponents addObject:[NSString stringWithFormat:@"journal:\"%@\"",[_journalArray objectAtIndex:0]]];
        }
        else {
            for (NSString *item in _journalArray) {
                subQuery = [subQuery stringByAppendingFormat:@"\"%@\" ", item];
            }            
            
            [compponents addObject:[NSString stringWithFormat:@"journal:(%@)", subQuery]];
        }
    }
    
    if (_titleArray) {
        
        if ([_titleArray count] == 1) {
            [compponents addObject:[NSString stringWithFormat:@"title:\"%@\"",[_titleArray objectAtIndex:0]]];
        }
        else {
            for (NSString *item in _titleArray) {
                subQuery = [subQuery stringByAppendingFormat:@"\"%@\" ", item];
            }            
            
            [compponents addObject:[NSString stringWithFormat:@"title:(%@)", subQuery]];
        }
    }


    if ([_dateArray count] > 0) {
        
        NSMutableArray* temp = [NSMutableArray array];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        for (NSDate* date in _dateArray) {
            NSString* dateString = [formatter stringFromDate:date];
            if (dateString) {
                [temp addObject:dateString];
            }
        }
        
        [compponents addObject:[NSString stringWithFormat:@"date:%@",[temp componentsJoinedByString:@" OR "]]];
    }

    return [compponents componentsJoinedByString:@" "];
}

@end
