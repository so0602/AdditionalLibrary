#import "ZipArchive.h"

@interface ZipArchive (Addition)

+(void)unzipFilePath:(NSString*)filePath toPath:(NSString*)toFilePath overwrite:(BOOL)overwrite;

@end