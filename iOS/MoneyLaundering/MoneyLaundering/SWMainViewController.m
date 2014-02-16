//
//  SWMainViewController.m
//  MoneyLaundering
//
//  Created by Anatoly Macarov on 1/25/14.
//  Copyright (c) 2014 sweuroseattle. All rights reserved.
//

#import "SWMainViewController.h"
#import "SWAppDelegate.h"
#import "SWHistoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Utils.h"

#define CHARGE 2
#define WORK_TIME_SEC 120

@interface SWMainViewController ()

@end

@implementation SWMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.btnBalance.layer.cornerRadius=8.0f;
//    self.btnBalance.layer.masksToBounds=YES;
//    self.btnBalance.layer.borderColor = [[UIColor colorWithHexString:@"0066CC"]CGColor];
//    self.btnBalance.layer.borderWidth= 1.0f;
    
    [(SWAppDelegate *) [[UIApplication sharedApplication] delegate] showLoginView];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Welcome, Monni";
    [self getBalance];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)runMachine:(id)sender {
    NSLog(@"runMachine");
    if(_balance - CHARGE > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:[NSString stringWithFormat:@"Please confirm a charge of $%i", CHARGE ] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:@"Your balance is too low. Please add more funds." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

//Required
- (void)error:(NSString*)error code:(int)code severity:(int)severity
{
    NSLog(@"Error #%d: %@ (Severity %d)", code, error, severity);
}

- (IBAction)openHistory:(id)sender {
    
    SWHistoryViewController *history = [[SWHistoryViewController alloc] initWithNibName:@"SWHistoryViewController" bundle:nil];
    [self.navigationController pushViewController:history animated:YES];
}

-(void)getBalance
{
//    dispatch_queue_t queue;
//    dispatch_async(queue, ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://monni.azure-mobile.net/api/userballance?id=1"] ];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Data %@", str);
            NSRange rng = [str rangeOfString:@"{\"Ballance\":"];
            if(rng.location != NSNotFound)
            {
                NSRange rng2;
                rng2.location = rng.location+rng.length;
                rng2.length = [str length] - rng2.location;
                NSRange rng3 = [str rangeOfString:@"}" options:0 range:rng2];
                rng2.length = rng3.location - rng2.location;
                str = [str substringWithRange:rng2];
                _balance = [str integerValue];
                [self.btnBalance setTitle:[NSString stringWithFormat:@"$ %i >", _balance] forState:UIControlStateNormal];
            }
        }];
    //});
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *now = [[NSDate alloc] init];
        NSString *theDate = [dateFormat stringFromDate:now];
        
        MSClient *client = [(SWAppDelegate *) [[UIApplication sharedApplication] delegate] client];
        NSDictionary *item = @{ @"userid" : @"1", @"machineid" : @"1", @"amount" : [NSString stringWithFormat:@"-%i", CHARGE], @"payment_method" : @"", @"transaction_date" : theDate };
        MSTable *itemTable = [client tableWithName:@"Transactions"];
        [itemTable insert:item completion:^(NSDictionary *insertedItem, NSError *error) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"INFO" message:@"Server connection failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                NSLog(@"Item inserted, id: %@", [insertedItem objectForKey:@"id"]);
                
                self.activity = [[SCActivityManager alloc] initWithContainerView:self.view withLabel:@"Place your device on the Monni Switch."];
                [self.activity setActivityIndicatorVisible:YES];
                _balance -= CHARGE;
                [self.btnBalance setTitle:[NSString stringWithFormat:@"$ %i >", _balance] forState:UIControlStateNormal];
                [SWBTLEPeripheral sharedInstance].delegate = self;
                [[SWBTLEPeripheral sharedInstance] startAdvertising];
                
            }
        }];
    }
}

-(void)dataTransfered:(NSData *)data
{
    if(self.activity)
    {
        [self.activity setActivityIndicatorVisible:NO];
        
        NSDate *date = [NSDate date];
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.fireDate = [date dateByAddingTimeInterval:WORK_TIME_SEC];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        localNotif.alertBody = @"Monni Laundry \n Your laundry is ready";
        
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        
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

@end
