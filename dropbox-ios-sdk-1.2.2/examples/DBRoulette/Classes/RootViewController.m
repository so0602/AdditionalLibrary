//
//  RootViewController.m
//  DBRoulette
//
//  Created by Brian Smith on 6/29/10.
//  Copyright Dropbox, Inc. 2010. All rights reserved.
//

#import "RootViewController.h"
#import <DropboxSDK/DropboxSDK.h>


@interface RootViewController ()

- (void)updateButtons;

@end


@implementation RootViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.title = @"Link Account";
    }
    return self;
}

- (void)didPressLink {
	NSLog(@"LINE: %d", __LINE__);
    if (![[DBSession sharedSession] isLinked]) {
		[[DBSession sharedSession] linkFromController:self];
    } else {
        [[DBSession sharedSession] unlinkAll];
        [[[[UIAlertView alloc] 
           initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked" 
           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
          autorelease]
         show];
        [self updateButtons];
    }
}

- (IBAction)didPressPhotos {
	NSLog(@"LINE: %d", __LINE__);
    [self.navigationController pushViewController:photoViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	NSLog(@"LINE: %d", __LINE__);
    [self updateButtons];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"LINE: %d", __LINE__);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
            initWithTitle:@"Photos" style:UIBarButtonItemStylePlain 
            target:self action:@selector(didPressPhotos)] autorelease];
    self.title = @"Link Account";
}

- (void)viewDidUnload {
	NSLog(@"LINE: %d", __LINE__);
    [linkButton release];
    linkButton = nil;
}

- (void)dealloc {
	NSLog(@"LINE: %d", __LINE__);
    [linkButton release];
    [photoViewController release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return toInterfaceOrientation == UIInterfaceOrientationPortrait;
    } else {
        return YES;
    }
}


#pragma mark private methods

@synthesize linkButton;
@synthesize photoViewController;

- (void)updateButtons {
	NSLog(@"LINE: %d", __LINE__);
	NSLog(@"isLinked: %d", [[DBSession sharedSession] isLinked]);
    NSString* title = [[DBSession sharedSession] isLinked] ? @"Unlink Dropbox" : @"Link Dropbox";
    [linkButton setTitle:title forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem.enabled = [[DBSession sharedSession] isLinked];
}

@end

