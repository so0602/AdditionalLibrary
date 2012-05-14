#import "PetHunterDataSource.h"

@protocol PetHunterMissionDetail<PetHunterDataSource>

@property (nonatomic, retain) NSString* ttype;
@property (nonatomic, retain) NSString* gid;

@end

@interface PetHunterMissionDetail : PetHunterDataSource<PetHunterMissionDetail>

@end

extern NSString* PetHunterMissionDetail_TType;
extern NSString* PetHunterMissionDetail_Gid;
