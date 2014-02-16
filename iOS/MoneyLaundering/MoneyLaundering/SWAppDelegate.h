//
//  SWAppDelegate.h
//  MoneyLaundering
//
//  Created by Anatoly Macarov on 1/25/14.
//  Copyright (c) 2014 sweuroseattle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMainViewController.h"

@class SWLoginViewController;
@interface SWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWMainViewController *mainViewController;
@property (strong, nonatomic) MSClient *client;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) SWLoginViewController* loginViewController;

- (void)showLoginView;
@end
