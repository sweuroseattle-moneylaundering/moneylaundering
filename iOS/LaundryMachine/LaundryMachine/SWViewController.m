//
//  SWViewController.m
//  LaundryMachine
//
//  Created by Anatoly Macarov on 1/25/14.
//  Copyright (c) 2014 sweuroseattle. All rights reserved.
//

#import "SWViewController.h"
#import "TransferService.h"
#import <AVFoundation/AVFoundation.h>


#define WORK_TIME_SEC 120

@interface SWViewController ()

@end

@implementation SWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [SWBTLECentral sharedInstance].delegate = self;
    [[SWBTLECentral sharedInstance] startScan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataTransfered:(NSData *)data
{
    if([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqualToString:TRANSFER_KEY])
    {
        [self startSpin];
    }
}

// an ivar for your class:
BOOL animating;

- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         self.machineWindow.transform = CGAffineTransformRotate(self.machineWindow.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void) startSpin {
    if (!animating) {
        animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
        [self playBackgroundSound];
        _unCountTime = WORK_TIME_SEC;
        if(self.timer == NULL)
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(uncountTime:) userInfo:nil repeats:YES];
    }
}

-(void)uncountTime:(id)sender
{
    _unCountTime--;
    if(_unCountTime < 0)
    {
        [self stopSpin];
        return;
    }
    //Accessing UI Thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        int min = _unCountTime / 60;
        int sec = _unCountTime - min*60;
        NSString *newText = [NSString stringWithFormat:@"0%i:%@%i", min, sec < 10 ? @"0": @"",sec];
        //Do any updates to your label here
        self.lbTimer.text = newText;
        
    }];
}

- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    animating = NO;
    [self.timer invalidate];
    self.timer = NULL;
    [self stopBackgroundSound];
}

static AVAudioPlayer *player = NULL;
-(void)playBackgroundSound
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"washing-machine-1" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = -1; //infinite
    
    [player play];
}

-(void)stopBackgroundSound
{
    [player stop];
}

-(void)dealloc
{
    [[SWBTLECentral sharedInstance] stopScan];
}

@end
