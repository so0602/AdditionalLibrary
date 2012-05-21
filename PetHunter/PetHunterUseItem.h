#import "PetHunterDataSource.h"

@protocol PetHunterUseItem<PetHunterDataSource>

@end

@interface PetHunterUseItem : PetHunterDataSource<PetHunterUseItem>

@end