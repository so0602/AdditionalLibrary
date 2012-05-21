#import "YTDataSource.h"

@protocol PetHunterTableViewDataSource<YTDataSource>

@property (nonatomic, retain, readonly) NSString* tableTitle;

@end

@interface PetHunterTableViewDataSource : YTDataSource<PetHunterTableViewDataSource>

@property (nonatomic, retain, readwrite) NSString* tableTitle;

@end

extern NSString* PetHunterTableViewDataSource_TableTitle;