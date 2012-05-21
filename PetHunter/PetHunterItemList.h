#import "PetHunterDataSource.h"

#import "PetHunterItem.h"

@protocol PetHunterItemList<PetHunterDataSource>

@property (nonatomic, retain) NSArray<PetHunterItem>* items;

@end

@interface PetHunterItemList : PetHunterDataSource<PetHunterItemList>

@end

extern NSString* PetHunterItemList_Items;