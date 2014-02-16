

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SCActivityManager : NSObject 
{
	UIView *activityIndicator;
	UIView *containerView;
    UILabel *lbInfo;
}

- (id)init;
- (id)initWithContainerView:(UIView *)containerView;
- (id)initWithContainerView:(UIView *)containerView activityIndicator:(UIView *)activityIndicator;
- (id)initWithContainerView:(UIView *)_containerView withLabel:(NSString *)strInfo;
- (UIView *)defaultActivityIndicator;

- (void)setActivityIndicatorWithNetworkActivityVisible:(BOOL)visible;
- (void)setActivityIndicatorVisible:(BOOL)visible;

@property (nonatomic, retain) IBOutlet UIView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIView *containerView;
@property (nonatomic, retain) UILabel *lbInfo;
@end
