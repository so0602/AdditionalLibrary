#import "PetHunterDataSourceInput.h"

@protocol PetHunterMissionDetailInput<PetHunterDataSourceInput>

@property (nonatomic, retain) NSString* gid;

@end

@interface PetHunterMissionDetailInput : PetHunterDataSourceInput<PetHunterMissionDetailInput>

@end

extern NSString* PetHunterMissionDetailInput_Gid;