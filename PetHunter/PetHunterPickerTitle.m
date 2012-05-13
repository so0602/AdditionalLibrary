#import "PetHunterPickerTitle.h"

@implementation PetHunterPickerTitle

#pragma mark - Memory Management

-(void)dealloc{
	[_title release];
	[_subtitles release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize title = _title;
@synthesize subtitles = _subtitles;

@end