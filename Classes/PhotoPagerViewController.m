//
//  PhotoPagerViewController.m
//  PhotoPager
//
//  Created by Martin Volerich on 3/9/10.
//  Copyright Bill Bear Technologies 2010. All rights reserved.
//

#import "PhotoPagerViewController.h"

#define kIMAGEVIEWTAGBASE		1000
#define kNUMBEROFIMAGES			3

@implementation PhotoPagerViewController

#pragma mark Initialization

- (id)init {
	if (self = [super init]) {
		currentPageIndex = 0;
	}
	return self;
}

#pragma mark -
#pragma mark Memory cleanup

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[scroller release];
    [super dealloc];
}

#pragma mark -
#pragma mark View construction

- (void)layoutImageViewsInScrollView:(UIScrollView *)scrollView {
	// Images
	const CGFloat gap = 10.0f;
	CGRect rect = CGRectZero;
	rect.size = [scrollView bounds].size;
	CGFloat pageWidth = rect.size.width;
	currentPageSize = pageWidth + gap;
	
	for (int i=0; i<kNUMBEROFIMAGES; i++) {
		UIView *imageView = [scrollView viewWithTag:kIMAGEVIEWTAGBASE + i];
		imageView.frame = rect;
		
		rect.origin.x += currentPageSize;		
	}
	
	CGSize contentSize = CGSizeMake(pageWidth * kNUMBEROFIMAGES + gap * (kNUMBEROFIMAGES - 1), rect.size.height);
	scroller.contentSize = contentSize;
}

- (void)loadView {
	
	// Container view
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor redColor];
	contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	contentView.autoresizesSubviews = YES;
	self.view = contentView;
	[contentView release];
	
	// ScrollView
	scroller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	scroller.backgroundColor = [UIColor darkGrayColor];
	scroller.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scroller.contentMode = UIViewContentModeCenter;
	scroller.autoresizesSubviews = YES;
	scroller.showsVerticalScrollIndicator = scroller.showsHorizontalScrollIndicator = NO;
	scroller.delegate = self;
	scroller.decelerationRate = UIScrollViewDecelerationRateFast;
	[self.view addSubview:scroller];
	
	// Images	
	for (int i=0; i<kNUMBEROFIMAGES; i++) {
		NSString *imageName = [NSString stringWithFormat:@"photo%d.png", i+1];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		imageView.backgroundColor = [UIColor blackColor];
		imageView.tag = kIMAGEVIEWTAGBASE + i;
		[scroller addSubview:imageView];
		[imageView release];
				
	}
	
	[self layoutImageViewsInScrollView:scroller];
}



#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollToActivePageInScrollView:(UIScrollView *)scrollView {
	UIView *activeView = [scrollView viewWithTag:kIMAGEVIEWTAGBASE + currentPageIndex];
	NSLog(@"Scrolling to page %d", currentPageIndex);
	[scrollView scrollRectToVisible:activeView.frame animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	startDragPoint = scrollView.contentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSLog(@"Done decelerating");
	[self scrollToActivePageInScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	NSLog(@"Scroll view end dragging with decelerate %d", decelerate);
	CGPoint endDragPoint = scrollView.contentOffset;
	BOOL isForward = endDragPoint.x > startDragPoint.x;
	if (isForward){
		if (++currentPageIndex == kNUMBEROFIMAGES) currentPageIndex = kNUMBEROFIMAGES - 1;
	}
	else {
		if (--currentPageIndex < 0) currentPageIndex = 0;
	}

	if (!decelerate)
		[self scrollToActivePageInScrollView:scrollView];
}

#pragma mark -
#pragma mark Orientation handling

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self layoutImageViewsInScrollView:scroller];
	[self scrollToActivePageInScrollView:scroller];
}

@end
