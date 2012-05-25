#import "PetHunterDataSource.h"

@protocol PetHunterAction<PetHunterDataSource>

@property (nonatomic, retain) NSString* hunting;
@property (nonatomic, retain) NSString* maxHunting;
@property (nonatomic, retain) NSString* challenge;
@property (nonatomic, retain) NSString* maxChallenge;

@end

@interface PetHunterAction : PetHunterDataSource<PetHunterAction>

@end

extern NSString* PetHunterAction_Hunting;
extern NSString* PetHunterAction_MaxHunting;
extern NSString* PetHunterAction_Challenge;
extern NSString* PetHunterAction_MaxChallenge;