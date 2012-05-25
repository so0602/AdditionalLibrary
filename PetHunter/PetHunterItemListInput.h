#import "PetHunterDataSourceInput.h"

@protocol PetHunterItemListInput<PetHunterDataSourceInput>

@property (nonatomic, retain) NSString* page;
@property (nonatomic, retain) NSString* count;
@property (nonatomic, readonly) NSString* ttype;

@end

@interface PetHunterItemListInput : PetHunterDataSourceInput<PetHunterItemListInput>

@end

extern NSString* PetHunterItemListInput_Page;
extern NSString* PetHunterItemListInput_Count;
extern NSString* PetHunterItemListInput_TType;