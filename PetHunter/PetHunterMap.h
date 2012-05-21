#import "PetHunterDataSource.h"

#import "PetHunterTableViewDataSource.h"

@protocol PetHunterMap<PetHunterDataSource, PetHunterTableViewDataSource>

@property (nonatomic, readonly) NSString* ID;
@property (nonatomic, readonly) NSString* rate;
@property (nonatomic, readonly) BOOL isFinish;
@property (nonatomic, readonly) NSString* name;

@end

@interface PetHunterMap : PetHunterDataSource<PetHunterMap>

@end

extern NSString* PetHunterMap_ID;
extern NSString* PetHunterMap_Rate;
extern NSString* PetHunterMap_IsFinish;
extern NSString* PetHunterMap_Name;