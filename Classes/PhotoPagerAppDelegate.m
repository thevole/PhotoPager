//
//  PhotoPagerAppDelegate.m
//  PhotoPager
//
//  Created by Martin Volerich on 3/9/10.
//  Copyright Bill Bear Technologies 2010. All rights reserved.
//

#import "PhotoPagerAppDelegate.h"
#import "PhotoPagerViewController.h"

@implementation PhotoPagerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	viewController = [[PhotoPagerViewController alloc] init];
	
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
