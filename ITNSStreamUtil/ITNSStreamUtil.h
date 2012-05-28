//
//  ITNSStreamUtil.h
//  Created by Leon.
//

#import <Foundation/Foundation.h>

@interface NSInputStream(Util)
-(NSString *)readLine;
@end


@interface NSOutputStream(Util)
-(void)writeLine:(NSString *)lineString;
@end
