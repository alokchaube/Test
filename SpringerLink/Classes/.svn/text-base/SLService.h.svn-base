

typedef enum {
    KeywordType  = 0,
    AuthorType   = 1,
    EditorType   = 2,
    SubjectType  = 3,
    PublicationType  = 4,
    MostRecentType = 5,
    SequenceType = 6,
} TermsType;

@class ConstraintsQuery;
@class FacetsQuery;

@interface SLService : NSObject {
    
}

- (NSString *)search:(NSString *)searchStr 
         startNumber:(int)num 
     numberOfResults:(int)numRez 
         facetsQuery:(FacetsQuery *)facetsQueryOrNil
    constraintsQuery:(ConstraintsQuery *)constraintsQueryOrNil
           termsType:(TermsType)termsType;

- (NSString *)detailDataForDOI:(NSString *)doi
                   startNumber:(int)num 
               numberOfResults:(int)numRez 
                   facetsQuery:(FacetsQuery *)facetsQueryOrNil
              constraintsQuery:(ConstraintsQuery *)constraintsQueryOrNil;

- (NSString *)getBookThumbinalImage:(NSString*)isbn;
- (NSString *)getJournalThumbinalImage:(NSString*)journalid 
                                   vol:(NSString*)vol
                                 issue:(NSString*)issue;

@end



typedef enum {
    ContentTypeBookOrJournal     = 0,
    ContentTypeJornal   = 1,
    ContentTypeBook   = 2,
} ContentType;

typedef enum {
    ImageTypeImage   = 0,
    ImageTypeTable   = 1,
    ImageTypeVideo   = 2
} ImageType;

@interface FacetsQuery : NSObject {
@private
    //subject: 	limit to the specified subject collection 	metadata,openaccess,images
    NSArray*   subjects;
    //keyword: 	limit to articles tagged with a keyword 	metadata,openaccess,images
    NSArray*   keywords;
    //pub: 	limit to articles from a particular publication 	metadata,openaccess
    NSArray*   pub;
    //year: 	limit to articles published in a year 	metadata,openaccess,images
    int         byYear;
    int         toYear;
    //type: 	limit to either Book or Journal content 	metadata,openaccess,images
    ContentType contentType;
    //country: 	limit to articles authored in a particular country 	metadata,openaccess
    NSString*   country;
    //imagetype: 	limit to images of a particular type: {Image, Table, Video} 	images
    ImageType   imageType;
    NSArray  *  _months; 
    
    // year and month
    NSString *year;
    NSString *month;
    
    
}
@property (nonatomic, retain) NSString *  year;
@property (nonatomic, retain) NSString *  month;
@property (nonatomic, retain) NSArray*    subjects;
@property (nonatomic, retain) NSArray*    keywords;
@property (nonatomic, retain) NSArray*    pub;
@property (nonatomic, assign) int         byYear;
@property (nonatomic, assign) int         toYear;
@property (nonatomic, assign) ContentType contentType;
@property (nonatomic, retain) NSString*   country;
@property (nonatomic, assign) ImageType   imageType;


- (NSString*)quertString;
/*
 Returning number of days in any month of any year
 @param : mm - month number like 1 for jan, 2 for feb ...12 for Dec.
 @param : yy - year number like 2000,2001....
 */
- (int)numberOfDaysInMonth:(int)mm forYear:(int)yy;

/*
 *return the URL string in date formate like: 2011-01-02 OR 2011-01-03
 */
- (NSString *)getMnthURLStr;

@end


@interface ConstraintsQuery : NSObject {
    
@private
    
    NSString       *_doi;           //doi: 	Digital Object Identifier of article
    NSString       *_isbn;         //isbn:  International Standard Book Number,
    NSString       *_issn;         //issn:  International Standard Serial Number,
    NSString       *_orgName;      //name of organisation 
    
    NSArray        *_titleArray;   //array of  titles of article
    NSArray        *_journalArray;  //array of journals
    NSArray        *_bookArray;    //array of books name
    
    NSArray        *_authorNameArray; //array of author's name
    NSArray        *_dateArray;       //array of date  
    BOOL           _openaccess;       //is content related to open access
    BOOL           _onlineFirst;
}

@property (nonatomic, copy) NSString*   doi;
@property (nonatomic, copy) NSString*   isbn;
@property (nonatomic, copy) NSString*   issn;
@property (nonatomic, copy) NSString*   orgName;

@property (nonatomic, strong) NSArray*    journalArray;
@property (nonatomic, strong) NSArray*    titleArray;
@property (nonatomic, strong) NSArray*    bookArray;
@property (nonatomic, strong) NSArray*    authorNameArray;
@property (nonatomic, strong) NSArray*    dateArray;

@property (nonatomic, assign) BOOL        openaccess;
@property (nonatomic, assign) BOOL        onlineFirst;

- (NSString*)quertString;

@end


