//
//  PhotoPagerViewController.m
//  PhotoPager
//
//  Created by Martin Volerich on 3/9/10.
//  Copyright Bill Bear Technologies 2010. All rights reserved.
//

#import "PhotoPagerViewController.h"

#define kIMAGEVIEWTAGBASE		1000
#define kNUMBEROFIMAGES			4

@implementation PhotoPagerViewController

@synthesize containedImageViews;
@synthesize zoomView;

#pragma mark Initialization

- (id)init {
	if (self = [super init]) {
		currentPageIndex = 0;
		isZooming = NO;
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
	[containedImageViews release];
	[zoomView release];
	[scroller release];
    [super dealloc];
}

#pragma mark -
#pragma mark View construction

- (void)layoutImageViewsInScrollView:(UIScrollView *)scrollView {
	// Images
	const CGFloat gap = 20.0f;
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
	scroller.minimumZoomScale = 1.0f;
	scroller.maximumZoomScale = 3.0f;
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
#pragma mark Scrolling utility methods



- (void)scrollToActivePageInScrollView:(UIScrollView *)scrollView animated:(BOOL)animated {
	UIView *activeView = [scrollView viewWithTag:kIMAGEVIEWTAGBASE + currentPageIndex];
//	NSLog(@"Scrolling to page %d", currentPageIndex);
	if (scrollRequired) {
		[scrollView scrollRectToVisible:activeView.frame animated:animated];
	}
}

- (void)showActiveViewAndPreserve {
	NSInteger currentPage = currentPageIndex;
	UIView *currentView = [scroller viewWithTag:kIMAGEVIEWTAGBASE + currentPage];
	NSMutableArray *imageViews = [NSMutableArray array];
	for (UIView *childView in [scroller subviews]) {
		if ([childView isKindOfClass:[UIImageView class]] && childView.tag >= kIMAGEVIEWTAGBASE) {
			[imageViews addObject:childView];
			if (childView != currentView) {
				[childView removeFromSuperview];
			}
		}
	}
	currentView.frame = currentView.bounds;
	scroller.contentSize = currentView.bounds.size;
	self.containedImageViews = imageViews;
	
	if (isZooming) 
		self.zoomView = currentView;
	
}



#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	if (!isZooming) {
		isZooming = YES;
		NSLog(@"Starting zoom");
		[self showActiveViewAndPreserve];
	}
	
	return self.zoomView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if (isZooming) return;
	startDragPoint = scrollView.contentOffset;
}



- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
	if (isZooming) return;
//	NSLog(@"Begin decelerating");
	[self scrollToActivePageInScrollView:scrollView animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (isZooming) return;
//	NSLog(@"Scroll view end dragging with decelerate %d", decelerate);
	CGPoint endDragPoint = scrollView.contentOffset;
	BOOL isForward = endDragPoint.x > startDragPoint.x;
	NSInteger previousPageIndex = currentPageIndex;
	if (isForward){
		if (++currentPageIndex == kNUMBEROFIMAGES) currentPageIndex = kNUMBEROFIMAGES - 1;
	}
	else {
		if (--currentPageIndex < 0) currentPageIndex = 0;
	}
	
	scrollRequired = (previousPageIndex != currentPageIndex);


	if (!decelerate)
		[self scrollToActivePageInScrollView:scrollView animated:YES];
}

#pragma mark -
#pragma mark Orientation handling

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	for (UIView *oldView in self.containedImageViews) {
		if (oldView.tag != kIMAGEVIEWTAGBASE + currentPageIndex) {
			[scroller addSubview:oldView];
		}
	}
	[self layoutImageViewsInScrollView:scroller];
	scrollRequired = YES;
	[self scrollToActivePageInScrollView:scroller animated:NO];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	//NSLog(@"Will Rotate");
	[self showActiveViewAndPreserve];
}

@end
