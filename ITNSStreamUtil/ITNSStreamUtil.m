//
//  ITNSStreamUtil.m
//  Created by Leon
//

#import "ITNSStreamUtil.h"

@implementation NSInputStream(Util)
-(NSString *)readLine{
	NSUInteger       maxLength = 1;
    unsigned char	 *buffer  = malloc(sizeof(unsigned char) * maxLength);
	NSMutableData    *lineBuffer = [NSMutableData data];
	BOOL			 hadData = NO;
	while([self read:buffer maxLength:maxLength] == maxLength){
		hadData = YES;
        if (buffer[0] == '\r') {
            break;
        }
		[lineBuffer appendBytes:buffer length:maxLength];
	}
    free(buffer);
	if(!hadData){
		return nil;
    }
	return [[[NSString alloc] initWithData:lineBuffer encoding:NSUTF8StringEncoding] autorelease];
}
@end


@implementation NSOutputStream(Util)
-(void)writeLine:(NSString *)lineString{
    NSData *data = [lineString dataUsingEncoding:NSUTF8StringEncoding];
	[self write:[data bytes] maxLength:[data length]];
	NSString *lineEnd = @"\r";
	[self write:(const unsigned char *)[lineEnd UTF8String] maxLength:[lineEnd length]];
}

@end

