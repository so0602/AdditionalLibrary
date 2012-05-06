#import "YTImagePickerController.h"

@interface YTAlbumViewController : YTImagePickerController

@end

@interface YTCameraViewController : YTImagePickerController

@end

@implementation YTImagePickerController

-(id)init{
	if( self = [super init] ){
		self.delegate = self;
	}
	return self;
}

-(id)initWithSourceType:(UIImagePickerControllerSourceType)sourceType{
	Class class = nil;
	switch( sourceType ){
		case UIImagePickerControllerSourceTypePhotoLibrary:
			class = [YTAlbumViewController alloc];
			break;
		case UIImagePickerControllerSourceTypeCamera:
			class = [YTCameraViewController alloc];
			break;
		default:
			class = nil;
	}
	if( !class ) return nil;
	
	self = [class init];
	return self;
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
	NSLog(@"%s - Line %d", __FUNCTION__, __LINE__);
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	NSLog(@"%s - Line %d", __FUNCTION__, __LINE__);
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	[self.imagePickerDelegate imagePickerController:self didFinishPickingImage:image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	NSLog(@"%s - Line %d", __FUNCTION__, __LINE__);
	UINavigationController* navigationController = self.navigationController;
	if( [navigationController.visibleViewController isEqual:navigationController.topViewController] ){
		[navigationController popViewControllerAnimated:TRUE];
	}else{
		[self dismissModalViewControllerAnimated:TRUE];
	}
}

#pragma mark - Memory Management

-(void)dealloc{
	[_imagePickerDelegate release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize imagePickerDelegate = _imagePickerDelegate;

@end

@implementation YTAlbumViewController

-(id)init{
	if( self = [super init] ){
		self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		self.delegate = self;
	}
	return self;
}

@end

@implementation YTCameraViewController

-(id)init{
	if( self = [super init] ){
		self.sourceType = UIImagePickerControllerSourceTypeCamera;
		self.delegate = self;
	}
	return self;
}

@end