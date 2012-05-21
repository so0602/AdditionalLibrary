#import "PetHunterDataSourceInput.h"

@protocol PetHunterMapListInput<PetHunterDataSourceInput>

@property (nonatomic, retain) NSString* page;
@property (nonatomic, readonly) NSString* count;

@end

@interface PetHunterMapListInput : PetHunterDataSourceInput<PetHunterMapListInput>

@end

extern NSString* PetHunterMapListInput_Page;
extern NSString* PetHunterMapListInput_Count;