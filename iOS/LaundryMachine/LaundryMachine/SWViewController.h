//
//  SWViewController.h
//  LaundryMachine
//
//  Created by Anatoly Macarov on 1/25/14.
//  Copyright (c) 2014 sweuroseattle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWBTLECentral.h"

@interface SWViewController : UIViewController<SWBTLECentralDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *machineWindow;
@property (weak, nonatomic) IBOutlet UILabel *lbTimer;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger unCountTime;
@end
