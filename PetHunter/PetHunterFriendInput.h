#import "PetHunterDataSourceInput.h"

@protocol PetHunterFriendInput<PetHunterDataSourceInput>

@property (nonatomic, retain) NSString* page;
@property (nonatomic, readonly) NSString* count;

@end

@interface PetHunterFriendInput : PetHunterDataSourceInput<PetHunterFriendInput>

@end

extern NSString* PetHunterFriendInput_Page;
extern NSString* PetHunterFriendInput_Count;