#import "PetHunterItemList.h"

@implementation PetHunterItemList

-(NSArray*)items{
	return [self.data objectForKey:PetHunterItemList_Items];
}
-(void)setItems:(NSArray<PetHunterItemList> *)items{
	[_data setNilObject:items forKey:PetHunterItemList_Items];
}

@end

NSString* PetHunterItemList_Items = @"Items";