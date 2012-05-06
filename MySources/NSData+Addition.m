#import "NSData+Addition.h"

#import "zlib.h"
#import "zconf.h"

//#include "minizip/zip.h"
//#include "minizip/unzip.h"

@implementation NSData (Addition)

#pragma mark NSDataStrings

-(NSString*)stringWithHexBytes{
	static const char hexdigits[] = "0123456789ABCDEF";
	const size_t numBytes = [self length];
	const unsigned char* bytes = [self bytes];
	char *strbuf = (char*)malloc(numBytes * 2 + 1);
	char *hex = strbuf;
	NSString *hexBytes = nil;
	
	for(int i = 0; i<numBytes; ++i){
		const unsigned char c = *bytes++;
		*hex++ = hexdigits[(c >> 4) & 0xF];
		*hex++ = hexdigits[(c) & 0xF];
	}
	*hex = 0;
	hexBytes = [NSString stringWithUTF8String:strbuf];
	free(strbuf);
	return hexBytes;
}

-(NSData*)compressed{
	if( !self || self.length == 0 ){
		return nil;
	}
	
	uLong destSize = self.length * 1.001 + 12;
	NSMutableData* destData = [NSMutableData dataWithLength:destSize];
	
	int error = compress([destData mutableBytes], &destSize, self.bytes, self.length);
	if( error != Z_OK ){
		NSLog(@"%s: self:0x%p, zlib error on compress:%d\n", __func__, self, error);
		return nil;
	}
	
	[destData setLength:destSize];
	return destData;
}

@end