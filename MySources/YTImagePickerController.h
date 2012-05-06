#import <UIKit/UIKit.h>

@class YTImagePickerController;

@protocol YTImagePickerControllerDelegate<NSObject>

-(void)imagePickerController:(YTImagePickerController*)imagePickerController didFinishPickingImage:(UIImage*)image;

@end

@interface YTImagePickerController : UIImagePickerController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
	id<YTImagePickerControllerDelegate> _imagePickerDelegate;
}

@property (nonatomic, retain) id<YTImagePickerControllerDelegate> imagePickerDelegate;

-(id)initWithSourceType:(UIImagePickerControllerSourceType)sourceType;

@end