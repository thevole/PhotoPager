//
//  PhotoPagerViewController.m
//  PhotoPager
//
//  Created by Martin Volerich on 3/9/10.
//  Copyright Bill Bear Technologies 2010. All rights reserved.
//

#import "PhotoPagerViewController.h"

#define kIMAGEVIEWTAGBASE		1000
#define kNUMBEROFIMAGES			2

@implementation PhotoPagerViewController

#pragma mark Initialization

- (id)init {
	if (self = [super init]) {
		currentPage = 0;
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
	scroller.backgroundColor = [UIColor blueColor];
	scroller.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scroller.contentMode = UIViewContentModeCenter;
	scroller.autoresizesSubviews = YES;
	scroller.showsVerticalScrollIndicator = scroller.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:scroller];
	
	// Images
	CGFloat gap = 10.0f;
	CGRect rect = [scroller bounds];
	CGFloat pageWidth = rect.size.width;
	
	for (int i=0; i<kNUMBEROFIMAGES; i++) {
		NSString *imageName = [NSString stringWithFormat:@"photo%d.png", i+1];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		imageView.backgroundColor = [UIColor blackColor];
		imageView.tag = kIMAGEVIEWTAGBASE;
		imageView.frame = rect;
		[scroller addSubview:imageView];
		[imageView release];
		
		rect.origin.x += pageWidth + gap; 
		
	}
	
	CGSize contentSize = CGSizeMake(pageWidth * kNUMBEROFIMAGES + gap * (kNUMBEROFIMAGES - 1), rect.size.height);
	scroller.contentSize = contentSize;
}

#pragma mark -
#pragma mark Orientation handling

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

@end
