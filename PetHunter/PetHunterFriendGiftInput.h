#import "PetHunterDataSourceInput.h"

@protocol PetHunterFriendGiftInput<PetHunterDataSourceInput>

@property (nonatomic, retain) NSString* gid;

@end

@interface PetHunterFriendGiftInput : PetHunterDataSourceInput<PetHunterFriendGiftInput>

@end

extern NSString* PetHunterFriendGiftInput_Gid;