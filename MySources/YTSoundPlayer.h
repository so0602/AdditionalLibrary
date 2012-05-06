#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <OpenAL/oalStaticBufferExtension.h>

#import "YTSound.h"

@class YTSoundPlayer;

@interface YTSoundPlayer : NSObject{
	ALCdevice* _device;
	ALCcontext* _context;
	NSMutableArray* _sourceArray;
	NSMutableDictionary* _dataDic;
}

+(YTSoundPlayer*)instance;

-(ALuint)loadSound:(NSString*)path;
-(ALuint)loadSoundWithData:(id<YTSound>)sData;
-(void)deleteSound:(ALuint)source;

-(void)play:(ALuint)source;
-(void)stop:(ALuint)source;

-(void)pitch:(ALuint)source value:(Float32)value;

-(void)volume:(ALuint)source volume:(Float32)volume;

-(void)fadeOutStop:(ALuint)source;

@end

#ifdef __cplusplus
extern "C"
{
#endif
	
	extern YTSoundPlayer* SoundPlayer();

#ifdef __cplusplus
}
#endif