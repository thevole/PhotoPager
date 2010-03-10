//
//  PhotoPagerAppDelegate.h
//  PhotoPager
//
//  Created by Martin Volerich on 3/9/10.
//  Copyright Bill Bear Technologies 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoPagerViewController;

@interface PhotoPagerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PhotoPagerViewController *viewController;
}

@end

