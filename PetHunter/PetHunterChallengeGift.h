#import "PetHunterDataSource.h"

@protocol PetHunterChallengeGift<PetHunterDataSource>

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* gift;

@end

@interface PetHunterChallengeGift : PetHunterDataSource<PetHunterChallengeGift>

@end

extern NSString* PetHunterChallengeGift_Name;
extern NSString* PetHunterChallengeGift_Gift;