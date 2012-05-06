#import "YTSoundPlayer.h"

static YTSoundPlayer* _instance = nil;

static int fluctuation = 0;

static alBufferDataStaticProcPtr proc = NULL;

@interface YTSoundPlayer ()

-(void)threadMain:(id)obj;

@property (nonatomic, assign) ALCdevice* device;
@property (nonatomic, assign) ALCcontext* context;
@property (nonatomic, retain) NSMutableArray* sourceArray;
@property (nonatomic, retain) NSMutableDictionary* dataDic;

@end

@implementation YTSoundPlayer

+(YTSoundPlayer*)instance{
	@synchronized(self){
		if( !_instance ) _instance = [[self alloc] init];
	}
	return _instance;
}

-(ALuint)loadSound:(NSString*)path{
	YTSound* sData = [self.dataDic objectForKey:path];
	if( !sData ){
		sData = [[[YTSound alloc] initWithFile:path] autorelease];
		[self.dataDic setObject:sData forKey:path];
	}
	return [self loadSoundWithData:sData];
}

-(ALuint)loadSoundWithData:(id<YTSound>)sData{
	ALuint buffer, source;
	
	alGenSources(1, &source);
	alGenBuffers(1, &buffer);
	
	if( proc == NULL ) proc = (alBufferDataStaticProcPtr)alcGetProcAddress(NULL, (const ALCchar*)"alBufferDataStatic");
	if( proc ) proc(buffer, [sData soundFileType:sData], [sData soundData:sData], [sData soundDataSize:sData], [sData soundFileFormat:sData].mSampleRate);
	
	alSourcei(source, AL_BUFFER, buffer);
	
	[self.sourceArray addObject:[NSNumber numberWithInt:source]];
	
	return source;
}

-(void)deleteSound:(ALuint)source{
	ALint buffer;
	alGetSourcei(source, AL_BUFFER, &buffer);
	
	alSourceStop(source);
	alDeleteSources(1, &source);
	
	alDeleteBuffers(1, (ALuint*)&buffer);
	
	[self.sourceArray removeObject:[NSNumber numberWithInt:source]];
}

-(void)play:(ALuint)source{
	alSourcePlay(source);
}

-(void)stop:(ALuint)source{
	alSourceStop(source);
}

-(void)pitch:(ALuint)source value:(Float32)value{
	if( fluctuation++ > 100 ) fluctuation = -100;
	value += fluctuation / 1000000.0;
	
	alSourcef(source, AL_PITCH, value);
}

-(void)volume:(ALuint)source volume:(Float32)volume{
	alSourcef(source, AL_GAIN, volume);
}

-(void)fadeOutStop:(ALuint)source{
	[NSThread detachNewThreadSelector:@selector(threadMain:) toTarget:self withObject:[NSNumber numberWithInt:source]];
}

#pragma mark Private Functions

-(void)threadMain:(id)obj{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	int source = [obj intValue];
	Float32 vol = 1.0;
	
	while( TRUE ){
		[NSThread sleepForTimeInterval:0.1];
		
		vol -= 0.1;
		if( vol < 0 ) break;
		
		alSourcef(source, AL_GAIN, vol);
	}
	alSourceStop(source);
	
	[pool drain];
}

#pragma mark Override Functions

-(id)init{
	if( self = [super init] ){
		self.sourceArray = [NSMutableArray array];
		self.dataDic = [NSMutableDictionary dictionary];
		
		self.device = alcOpenDevice(NULL);
		self.context = alcCreateContext(self.device, NULL);
		
		alcMakeContextCurrent(self.context);
	}
	return self;
}

+(id)allocWithZone:(NSZone *)zone{
	@synchronized(self){
		if( !_instance ) _instance = [super allocWithZone:zone];
		return _instance;
	}
	return nil;
}

-(id)copyWithZone:(NSZone*)zone{
	return self;
}

-(id)retain{
	return self;
}

-(NSUInteger)retainCount{
	return UINT_MAX;
}

-(void)release{
}

-(id)autorelease{
	return self;
}

#pragma mark Memory Management

-(void)dealloc{
	ALuint source;
	for( NSNumber* sourceNum in self.sourceArray ){
		source = (ALuint)[sourceNum intValue];
		alSourceStop(source);
		alDeleteBuffers(1, &source);
	}
	self.sourceArray = nil;
	self.dataDic = nil;
	alcMakeContextCurrent(NULL);
	alcDestroyContext(self.context);
	alcCloseDevice(self.device);
	[super dealloc];
}

#pragma mark @synthesize

@synthesize device = _device;
@synthesize context = _context;
@synthesize sourceArray = _sourceArray;
@synthesize dataDic = _dataDic;

@end

extern YTSoundPlayer* SoundPlayer(){
	return [YTSoundPlayer instance];
}