#import "ASIFormDataRequest.h"

@interface ASIFormDataRequest (Addition)

@property (nonatomic, readonly) NSMutableArray* postData;
@property (nonatomic, readonly) NSString* urlForGetMethod;

-(void)addPostValues:(NSDictionary*)postValues;

@end