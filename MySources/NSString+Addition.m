#import "NSString+Addition.h"

#import "NSFileManager+Addition.h"

@implementation NSString (DecodeHTML)

+(NSString*)replaceXMLStuffInString:(NSString*)source{
	int anInt;
	NSScanner* scanner = [NSScanner scannerWithString:source];
	scanner.charactersToBeSkipped = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
	while( ![scanner isAtEnd] ){
		if( [scanner scanInt:&anInt] ){
			if( [source rangeOfString:[NSString stringWithFormat:@"&#%d;", anInt]].location != NSNotFound ){
				source = [source stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"&#%d;", anInt] withString:[NSString stringWithFormat:@"%C", anInt]];
			}
		}
	}
	return source;
}

@end

@implementation NSString (EncodeURL)

-(NSString*)urlEncode:(NSStringEncoding)encode{
	NSMutableString* escaped = [NSMutableString string];
	[escaped setString:[self stringByAddingPercentEscapesUsingEncoding:encode]];
	escaped = (NSMutableString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)escaped, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	
	return [escaped autorelease];
}

+(NSString*)encodeURLParameters:(NSString*)parameters{
	NSString* string = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)parameters, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	return [string autorelease];
}

@end

@implementation NSString (Hex)

+(NSString*)stringFromHex:(NSString*)string{
	NSMutableData* data = [NSMutableData data];
	unsigned char whole_byte;
	char byte_chars[3] = {
		'\0', '\0', '\0'
	};
	int i;
	for( i = 0; i < string.length / 2; i++ ){
		byte_chars[0] = [string characterAtIndex:i * 2];
		byte_chars[1] = [string characterAtIndex:i * 2 + 1];
		whole_byte = strtol(byte_chars, NULL, 16);
		[data appendBytes:&whole_byte length:1];
	}
	
	return [NSString stringWithData:data encoding:NSASCIIStringEncoding];
}

+(NSString*)stringToHex:(NSString*)string{
	NSUInteger length = string.length;
	unichar* chars = malloc(length * sizeof(unichar));
	[string getCharacters:chars];
	
	NSMutableString* hexString = [NSMutableString string];
	
	for( NSUInteger i = 0; i < length; i++ ){
		[hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
	}
	free(chars);
	
	return hexString;
}

@end

@implementation NSString (AlphaOnly)

-(BOOL)isAlphaNumeric{
	NSCharacterSet* unwantedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
	return [self rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound;
}

@end

@implementation NSString (Addition)

+(id)stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding{
	return [[[self alloc] initWithData:data encoding:encoding] autorelease];
}

-(NSString*)trimEndNewline{
	NSString* newline = @"\n";
	NSRange range = NSMakeRange(self.length - newline.length, newline.length);
	NSString* string = [self substringWithRange:range];
	if( [string isEqualToString:newline] ){
		string = [self stringByReplacingOccurrencesOfString:newline withString:@"" options:0 range:range];
		return string;
	}
	return self;
}

-(BOOL)contains:(NSString*)string{
    BOOL result = FALSE;
    result = [self rangeOfString:string].location != NSNotFound;
    return result;
}

-(BOOL)beginsWith:(NSString*)string{
    BOOL result = FALSE;
    result = [self rangeOfString:string].location == 0;
    return result;
}

-(BOOL)endsWith:(NSString*)string{
    BOOL result = FALSE;
    NSRange range = [self rangeOfString:string];
    if( range.location != NSNotFound ){
        result = (range.location + range.length) == self.length;
    }
    return result;
}

-(NSString*)mimeType{
	return [NSFileManager mimeTypeForFileAtPath:self];
}

@end