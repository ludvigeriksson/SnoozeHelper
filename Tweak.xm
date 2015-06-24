static UIView *tapView; // The view that acts like the snooze button
static BOOL showBorder = NO; // Used during development only

%hook SBLockScreenFullscreenBulletinViewController

-(void)loadView {
	%orig;

	// Get the view containing the snooze button
	UIView *bulletinView = MSHookIvar<UIView *>(self, "_bulletinView");

	// Just making the button bigger does not increase the tappable area

	// Add a tap view over the whole screen that also initiates snooze
	CGSize size = bulletinView.bounds.size;
	CGRect frame = CGRectMake(0, 0, size.width, size.height);
	[tapView removeFromSuperview];
	tapView = nil;
	tapView = [[UIView alloc] initWithFrame:frame];
	[bulletinView addSubview:tapView];

	// Add the gesture recognizer to the view
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
																		  action:@selector(handleTap)];
	[tapView addGestureRecognizer:tap];

	if (showBorder) {
		// Make a border around the tap view to indicate tappable area
		// Used during development only
		tapView.layer.borderColor = [UIColor whiteColor].CGColor;
		tapView.layer.borderWidth = 2.0;
	}
}

%new
- (void)handleTap {
	// Send handleTapGestureFromView: to snooze alarm
	UIView *v = MSHookIvar<UIView *>(self, "_bulletinView");
	[self performSelector:@selector(handleTapGestureFromView:) withObject:v];
}

%end