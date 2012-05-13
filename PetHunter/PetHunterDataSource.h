#import "YTDataSource.h"

@protocol PetHunterDataSource<YTDataSource>

@property (nonatomic, retain) NSString* resultString;

@end

@interface PetHunterDataSource : YTDataSource<PetHunterDataSource>

@end

extern NSString* PetHunterDataSource_ResultString;