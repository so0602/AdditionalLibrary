#import "PetHunterDataSource.h"

@protocol PetHunterFriendGift<PetHunterDataSource>

@property (nonatomic, retain) NSString* name;

@end

@interface PetHunterFriendGift : PetHunterDataSource<PetHunterFriendGift>

@end

extern NSString* PetHunterFriendGift_Name;