//
//  AdditionalLibraryAppDelegate.h
//  AdditionalLibrary
//
//  Created by So Yiu Tak on 21/07/2011.
//  Copyright 2011 Cherrypicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdditionalLibraryViewController;

@interface AdditionalLibraryAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AdditionalLibraryViewController *viewController;
	UINavigationController* navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AdditionalLibraryViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController* navigationController;

@end

