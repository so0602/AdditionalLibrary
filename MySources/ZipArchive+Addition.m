#import "ZipArchive+Addition.h"

@implementation ZipArchive (Addition)

+(void)unzipFilePath:(NSString*)filePath toPath:(NSString*)toFilePath overwrite:(BOOL)overwrite{
	ZipArchive* zipFile = [[ZipArchive alloc] init];
	[zipFile UnzipOpenFile:filePath];
	[zipFile UnzipFileTo:toFilePath overWrite:overwrite];
	[zipFile UnzipCloseFile];
	[zipFile release], zipFile = nil;
}

@end