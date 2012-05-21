#import "PetHunterDataSource.h"

#import "PetHunterTableViewDataSource.h"

@protocol PetHunterFriend<PetHunterDataSource, PetHunterTableViewDataSource>

@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* status;

@property (nonatomic, readonly) BOOL hasGift;

@end

@interface PetHunterFriend : PetHunterDataSource<PetHunterFriend>

@end

extern NSString* PetHunterFriend_ID;
extern NSString* PetHunterFriend_Name;
extern NSString* PetHunterFriend_Status;