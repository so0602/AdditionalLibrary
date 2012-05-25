#import "PetHunterBattleInput.h"

@protocol PetHunterSpecialBattleInput<PetHunterBattleInput>

@property (nonatomic, readonly) NSString* ttype;

@end

@interface PetHunterSpecialBattleInput : PetHunterBattleInput<PetHunterSpecialBattleInput>

@end

extern NSString* PetHunterSpecialBattleInput_TType;