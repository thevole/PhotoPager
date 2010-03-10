//
//  PhotoPagerViewController.h
//  PhotoPager
//
//  Created by Martin Volerich on 3/9/10.
//  Copyright Bill Bear Technologies 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPagerViewController : UIViewController <UIScrollViewDelegate> {
	NSInteger currentPageIndex;
	CGFloat currentPageSize;
	UIScrollView *scroller;
	CGPoint startDragPoint;
}

@end

