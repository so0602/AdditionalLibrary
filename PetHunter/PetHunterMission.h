#import "PetHunterDataSource.h"

#import "PetHunterTableViewDataSource.h"

@protocol PetHunterMission<PetHunterDataSource, PetHunterTableViewDataSource>

@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* completed;

@property (nonatomic, readonly) BOOL isCompleted;

@end

@interface PetHunterMission : PetHunterDataSource<PetHunterMission>

@end

extern NSString* PetHunterMission_Id;
extern NSString* PetHunterMission_Name;
extern NSString* PetHunterMission_Completed;