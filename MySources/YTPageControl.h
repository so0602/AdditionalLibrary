#import <UIKit/UIKit.h>

@interface YTPageControl : UIPageControl{
	UIImage* _normalImage;
	UIImage* _selectedImage;
}

@property (nonatomic, readwrite, retain) UIImage *normalImage;
@property (nonatomic, readwrite, retain) UIImage *selectedImage;

@end