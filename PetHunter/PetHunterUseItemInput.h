#import "PetHunterDataSourceInput.h"

@protocol PetHunterUseItemInput<PetHunterDataSourceInput>

@property (nonatomic, retain) NSString* index;
@property (nonatomic, retain) NSString* index1;

@end

@interface PetHunterUseItemInput : PetHunterDataSourceInput<PetHunterUseItemInput>

@end

extern NSString* PetHunterUseItemInput_Index;
extern NSString* PetHunterUseItemInput_Index1;