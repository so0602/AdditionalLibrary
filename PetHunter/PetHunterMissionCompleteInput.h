#import "PetHunterDataSourceInput.h"

@protocol PetHunterMissionCompleteInput<PetHunterDataSourceInput>

@property (nonatomic, retain) NSString* ttype;
@property (nonatomic, retain) NSString* gid;

@end

@interface PetHunterMissionCompleteInput : PetHunterDataSourceInput<PetHunterMissionCompleteInput>

@end

extern NSString* PetHunterCompleteMissionInput_TType;
extern NSString* PetHunterCompleteMissionInput_Gid;