#import "PetHunterDataSourceInput.h"

@protocol PetHunterBattleInput<PetHunterDataSourceInput>

@property (nonatomic, retain) NSString* hid;

@end

@interface PetHunterBattleInput : PetHunterDataSourceInput<PetHunterBattleInput>

@end

extern NSString* PetHunterBattleInput_HID;