#import "YTDefineValues.h"

@interface NSString (DecodeHTML)

+(NSString*)replaceXMLStuffInString:(NSString*)source;

@end

@interface NSString (EncodeURL)

-(NSString*)urlEncode:(NSStringEncoding)encode;
+(NSString*)encodeURLParameters:(NSString*)parameters;

@end

@interface NSString (Hex)

+(NSString*)stringFromHex:(NSString*)string;
+(NSString*)stringToHex:(NSString*)string;

@end

@interface NSString (AlphaOnly)

@property (nonatomic, readonly, getter=isAlphaNumeric) BOOL alphaNumeric;

@end

@interface NSString (Addition)

+(id)stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding;

-(NSString*)trimEndNewline;

-(BOOL)contains:(NSString*)string;
-(BOOL)beginsWith:(NSString*)string;
-(BOOL)endsWith:(NSString*)string;

@property (nonatomic, readonly) NSString* mimeType;

@end