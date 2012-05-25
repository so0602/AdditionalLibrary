#import "PetHunterDataSource.h"

#import "PetHunterMap.h"

@protocol PetHunterMapList<PetHunterDataSource>

@property (nonatomic, retain) NSArray<PetHunterMap>* maps;

@end

@interface PetHunterMapList : PetHunterDataSource<PetHunterMapList>

@end

extern NSString* PetHunterMapList_Maps;