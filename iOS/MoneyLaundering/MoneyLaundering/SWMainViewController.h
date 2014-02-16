//
//  SWMainViewController.h
//  MoneyLaundering
//
//  Created by Anatoly Macarov on 1/25/14.
//  Copyright (c) 2014 sweuroseattle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "SCActivityManager.h"
#import "SWBTLEPeripheral.h"

@interface SWMainViewController : UIViewController<UIAlertViewDelegate, SWBTLEPeripheralDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnBalance;
@property (nonatomic) NSInteger balance;
@property (strong, nonatomic) SCActivityManager *activity;
@property (weak, nonatomic) IBOutlet UILabel *lbTimer;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger unCountTime;

- (IBAction)openHistory:(id)sender;
-(void)getBalance;
@end
