//
//  XMLDictionary.h

#import <Foundation/Foundation.h>


#define COLLAPSE_TEXT_NODES		YES
#define TRIM_WHITE_SPACE		YES

#define XML_ATTRIBUTES_KEY		@"__attributes"
#define XML_COMMENTS_KEY		@"__comments"
#define XML_TEXT_KEY			@"__text"
#define XML_NAME_KEY			@"__name"

#define XML_ATTRIBUTE_PREFIX	@"_"


@interface NSDictionary (XMLDictionary)

+ (NSDictionary *)dictionaryWithXMLData:(NSData *)data;
+ (NSDictionary *)dictionaryWithXMLString:(NSString *)string;
+ (NSDictionary *)dictionaryWithXMLFile:(NSString *)path;

- (NSString *)attributeForKey:(NSString *)key;
- (NSDictionary *)attributes;
- (NSDictionary *)childNodes;
- (NSArray *)comments;
- (NSString *)nodeName;
- (NSString *)innerText;
- (NSString *)innerXML;
- (NSString *)xmlString;

@end


@interface NSString (XMLDictionary)

- (NSString *)xmlEncodedString;

@end

