#import "YTSound.h"

@interface YTSound ()

@property (nonatomic, copy, readwrite) NSString* filePath;

@end

@implementation YTSound

-(id)initWithFile:(NSString*)path{
	if( self = [super init] ){
		self.filePath = path;
		
		AudioFileID theAFID = 0;
		
		UInt64 theFileSize = 0;
		
		const char* fPath = [self.filePath UTF8String];
		CFURLRef theURL = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, (UInt8*)fPath, strlen(fPath), false);
		
		AudioFileOpenURL(theURL, kAudioFileReadPermission, 0, &theAFID);
		CFRelease(theURL);
		
		UInt32 thePropSize = sizeof(_fileFormat);
		AudioFileGetProperty(theAFID, kAudioFilePropertyDataFormat, &thePropSize, &_fileFormat);
		
		thePropSize = sizeof(UInt64);
		AudioFileGetProperty(theAFID, kAudioFilePropertyAudioDataByteCount, &thePropSize, &theFileSize);
		
		_dataSize = (UInt32)theFileSize;
		_data = malloc(_dataSize);
		AudioFileReadBytes(theAFID, false, 0, &_dataSize, _data);
		
		_fileType = -1;
		if( _fileFormat.mBitsPerChannel == 8 ) _fileType = (_fileFormat.mChannelsPerFrame == 1) ? AL_FORMAT_MONO8 : AL_FORMAT_STEREO8;
		else if( _fileFormat.mBitsPerChannel == 16 ) _fileType = (_fileFormat.mChannelsPerFrame == 1) ? AL_FORMAT_MONO16 : AL_FORMAT_STEREO16;
		
		AudioFileClose(theAFID);
	}
	return self;
}

#pragma mark YTSound Protocol

-(NSString*)soundFilePath:(id)target{
	return self.filePath;
}

-(UInt32)soundDataSize:(id)target{
	return self.dataSize;
}

-(void*)soundData:(id)target{
	return self.data;
}

-(ALenum)soundFileType:(id)target{
	return self.fileType;
}

-(AudioStreamBasicDescription)soundFileFormat:(id)target{
	return self.fileFormat;
}

#pragma mark Memory Management

-(void)dealloc{
	self.filePath = nil;
	free(_data);
	[super dealloc];
}

#pragma mark @synthesize

@synthesize filePath = _filePath;
@synthesize dataSize = _dataSize;
@synthesize data = _data;
@synthesize fileType = _fileType;
@synthesize fileFormat = _fileFormat;

@end