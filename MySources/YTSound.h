#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@class YTSound;

@protocol YTSound<NSObject>

-(NSString*)soundFilePath:(id)target;
-(UInt32)soundDataSize:(id)target;
-(void*)soundData:(id)target;
-(ALenum)soundFileType:(id)target;
-(AudioStreamBasicDescription)soundFileFormat:(id)target;

@end

@interface YTSound : NSObject<YTSound>{
@private
	NSString* _filePath;
	
	UInt32 _dataSize;
	void* _data;
	ALenum _fileType;
	AudioStreamBasicDescription _fileFormat;
}

@property (nonatomic, copy, readonly) NSString* filePath;
@property (nonatomic, readonly) UInt32 dataSize;
@property (nonatomic, readonly) void* data;
@property (nonatomic, readonly) ALenum fileType;
@property (nonatomic, readonly) AudioStreamBasicDescription fileFormat;

-(id)initWithFile:(NSString*)path;

@end