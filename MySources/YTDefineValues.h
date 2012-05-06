#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define printFunc NSLog(@"%s At Line: %d", __FUNCTION__, __LINE__)

typedef enum{
	AlignmentTypeCenter = 0,
	AlignmentTypeTop = 1,
	AlignmentTypeBottom = 2,
	AlignmentTypeLeft = 10,
	AlignmentTypeRight = 20,
}AlignmentType;

typedef enum{
	UIViewControllerAnimationNormal = 0,
	UIViewControllerAnimationOpenDoor = 1,
	UIViewControllerAnimationCloseDoor = 2,
}UIViewControllerAnimation;