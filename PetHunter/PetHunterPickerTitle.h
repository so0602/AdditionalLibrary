#import "YTDataSource.h"

@protocol PetHunterPickerTitle<YTDataSource>

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSArray<PetHunterPickerTitle>* subtitles;

@end

@interface PetHunterPickerTitle : YTDataSource<PetHunterPickerTitle>

@end