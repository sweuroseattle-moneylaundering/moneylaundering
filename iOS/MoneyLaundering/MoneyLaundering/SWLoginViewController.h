//
//  SWLoginViewController.h
//  MoneyLaundering
//
//  Created by Anatoly Macarov on 1/25/14.
//  Copyright (c) 2014 sweuroseattle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWLoginViewController : UIViewController
- (void)loginFailed;
@property (retain, nonatomic) IBOutlet UIButton *btnLogIn;
- (IBAction)actLogin:(id)sender;
@end
