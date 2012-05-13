#import "YTDataSource.h"

@protocol PetHunterTableViewDataSource<YTDataSource>

@property (nonatomic, readonly) NSString* tableTitle;

@end

@interface PetHunterTableViewDataSource : YTDataSource<PetHunterTableViewDataSource>

@end