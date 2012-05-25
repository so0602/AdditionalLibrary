#import "PetHunterDataSource.h"

#import "PetHunterTableViewDataSource.h"

@protocol PetHunterItem<PetHunterDataSource, PetHunterTableViewDataSource>

@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* count;

@end

@interface PetHunterItem : PetHunterDataSource<PetHunterItem>

@end

extern NSString* PetHunterItem_ID;
extern NSString* PetHunterItem_Name;
extern NSString* PetHunterItem_Count;