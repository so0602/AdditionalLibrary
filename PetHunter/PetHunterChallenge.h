#import "PetHunterDataSource.h"

@protocol PetHunterChallenge<PetHunterDataSource>

@property (nonatomic, retain) NSString* actionCount;
@property (nonatomic, retain) NSString* maxActionCount;
@property (nonatomic, retain) NSString* challengeCount;
@property (nonatomic, retain) NSString* maxChallengeCount;

@end

@interface PetHunterChallenge : PetHunterDataSource<PetHunterChallenge>

@end

extern NSString* PetHunterChallenge_ActionCount;
extern NSString* PetHunterChallenge_MaxActionCount;
extern NSString* PetHunterChallenge_ChallengeCount;
extern NSString* PetHunterChallenge_MaxChallengeCount;