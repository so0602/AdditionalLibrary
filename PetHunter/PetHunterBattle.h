#import "PetHunterDataSource.h"

@protocol PetHunterBattle<PetHunterDataSource>

@property (nonatomic, retain) NSString* actionCount;
@property (nonatomic, retain) NSString* maxActionCount;
@property (nonatomic, retain) NSString* challengeCount;
@property (nonatomic, retain) NSString* maxChallengeCount;
@property (nonatomic, retain) NSString* boost;
@property (nonatomic, retain) NSString* exp;
@property (nonatomic, retain) NSString* bonus;

@end

@interface PetHunterBattle : PetHunterDataSource<PetHunterBattle>

@end

extern NSString* PetHunterBattle_ActionCount;
extern NSString* PetHunterBattle_MaxActionCount;
extern NSString* PetHunterBattle_ChallengeCount;
extern NSString* PetHunterBattle_MaxChallengeCount;
extern NSString* PetHunterBattle_Boost;
extern NSString* PetHunterBattle_Exp;
extern NSString* PetHunterBattle_Bonus;