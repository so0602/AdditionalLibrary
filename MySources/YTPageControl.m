#import "YTPageControl.h"

@implementation YTPageControl

-(void)setNormalImage:(UIImage *)normalImage{
	[_normalImage release];
	_normalImage = [normalImage retain];
	[self setNeedsLayout];
}

-(void)setSelectedImage:(UIImage *)selectedImage{
	[_selectedImage release];
	_selectedImage = [selectedImage retain];
	[self setNeedsLayout];
}

-(void)setCurrentPage:(NSInteger)currentPage{
	[super setCurrentPage:currentPage];
	[self setNeedsLayout];
}

#pragma mark - UIView

-(void)layoutSubviews{
	[super layoutSubviews];
	
	[self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		UIImageView* imageView = obj;
		if( ![imageView isKindOfClass:[UIImageView class]] ){
			return;
		}
		UIImage* image = self.currentPage == idx ? self.selectedImage : self.normalImage;
		if( image ){
			imageView.image = image;
		}
	}];
}

#pragma mark - Memory Management

-(void)dealloc{
	[_normalImage release];
	[_selectedImage release];
	
	[super dealloc];
}

#pragma mark - @synthesize

@synthesize normalImage = _normalImage;
@synthesize selectedImage = _selectedImage;

@end