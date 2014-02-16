

#import "SCActivityManager.h"
#import <QuartzCore/QuartzCore.h>

// Private methods declaration
@interface SCActivityManager()

- (void)arrangeViews;

@end


@implementation SCActivityManager

@synthesize activityIndicator;
@synthesize containerView;
@synthesize lbInfo;

- (id)init
{
	return [self initWithContainerView:nil];
}

- (id)initWithContainerView:(UIView *)_containerView withLabel:(NSString *)strInfo
{
    self.lbInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 57, 157, 50)];
    self.lbInfo.text = strInfo;
    self.lbInfo.backgroundColor = [UIColor clearColor];
    self.lbInfo.font = [UIFont systemFontOfSize:16];
    self.lbInfo.textAlignment = UITextAlignmentCenter;
    self.lbInfo.adjustsFontSizeToFitWidth = YES;
    self.lbInfo.textColor = [UIColor colorWithRed:188 green:149 blue:88 alpha:1.0];
    self.lbInfo.lineBreakMode = UILineBreakModeWordWrap;
    self.lbInfo.numberOfLines = 0;
    self.lbInfo.autoresizingMask = 
    UIViewAutoresizingFlexibleTopMargin 
    | UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleRightMargin;
    
	return [self initWithContainerView:_containerView activityIndicator:nil];
}

- (id)initWithContainerView:(UIView *)_containerView
{
	return [self initWithContainerView:_containerView activityIndicator:nil];
}

- (id)initWithContainerView:(UIView *)_containerView activityIndicator:(UIView *)_activityIndicator
{
	if (self = [super init]) 
	{
		containerView = _containerView;
		
		if (_activityIndicator == nil)
		{
			activityIndicator = [self defaultActivityIndicator];
            [self centerIndicatorInsideContainer];
		}
		else 
		{
			activityIndicator = _activityIndicator;
		}
        
		activityIndicator.hidden = YES;
		
		[self arrangeViews];
	}
	
	return self;
}

- (void)centerIndicatorInsideContainer
{
    activityIndicator.center = CGPointMake(containerView.frame.size.width / 2, 
                                           containerView.frame.size.height / 2);
    
    // remove blurriness on low-res screens
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
       && [[UIScreen mainScreen] scale] < 2.0f)
    {
        CGRect frame = activityIndicator.frame;
        frame.origin.x = floor(frame.origin.x);
        frame.origin.y = floor(frame.origin.y);
        activityIndicator.frame = frame;
	}
}

- (void)setContainerView:(UIView *)_containerView
{
	containerView = _containerView;
	
	[self arrangeViews];
}

- (void)setActivityIndicator:(UIView *)_activityIndicator
{
	[activityIndicator removeFromSuperview];
	activityIndicator = _activityIndicator;
	
	[self arrangeViews];
}

- (void)arrangeViews
{
	[self.containerView addSubview:self.activityIndicator];
	[self.containerView bringSubviewToFront:self.activityIndicator];
}

- (UIView *)defaultActivityIndicator
{
	UIActivityIndicatorView *indicator;
    if(self.lbInfo != nil)
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(67, 20, 37, 37)];
    else
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20, 20, 37, 37)] ;
    
	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[indicator startAnimating];
	
	UIView *activityIndicatorView; 
    if(self.lbInfo != nil)
        activityIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(121, 145, 177, 115)];
    else
        activityIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(121, 145, 77, 77)] ;
    
	activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75f];
	activityIndicatorView.layer.cornerRadius = 12;
	[activityIndicatorView addSubview:indicator];
    
    activityIndicatorView.autoresizingMask = 
    UIViewAutoresizingFlexibleTopMargin 
    | UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleRightMargin;
    
    if(self.lbInfo != nil)
        [activityIndicatorView addSubview:self.lbInfo];
	
	return activityIndicatorView;
}

- (void)setActivityIndicatorVisible:(BOOL)visible
{
	self.activityIndicator.hidden = !visible;
	[self.containerView bringSubviewToFront:self.activityIndicator];
    [self centerIndicatorInsideContainer];
}

- (void)setActivityIndicatorWithNetworkActivityVisible:(BOOL)visible
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:visible];
	[self setActivityIndicatorVisible:visible];
}

@end
