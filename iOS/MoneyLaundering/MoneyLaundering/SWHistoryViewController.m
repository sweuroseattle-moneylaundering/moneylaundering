//
//  SWHistoryViewController.m
//  MoneyLaundering
//
//  Created by Anatoly Macarov on 1/25/14.
//  Copyright (c) 2014 sweuroseattle. All rights reserved.
//

#import "SWHistoryViewController.h"
#import "SWAppDelegate.h"

@interface SWHistoryViewController ()

@end

@implementation SWHistoryViewController

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
    // Do any additional setup after loading the view from its nib.

    [self refreshData];
    self.btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = self.btnRefresh;
    self.navigationItem.title = @"My History";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshData
{
    [self.activityLoad setHidden:NO];
    [self.activityLoad startAnimating];
    [self.btnRefresh setEnabled:NO];
    MSClient *client = [(SWAppDelegate *) [[UIApplication sharedApplication] delegate] client];
    MSTable *itemTable = [client tableWithName:@"Transactions"];
    [itemTable readWithQueryString:@"" completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Selected %i: %@", totalCount, items);
            self.data = items;
            [self.tableView reloadData];
        }
        [self.activityLoad stopAnimating];
        [self.activityLoad setHidden:YES];
        [self.btnRefresh setEnabled:YES];
    }];
}

#pragma -UITableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
    }
    NSDictionary *item = [self.data objectAtIndex:indexPath.row];
    BOOL isAddMoney = NO;
    id machine = [item objectForKey:@"machineid"];
    if(machine != NULL && [machine respondsToSelector:@selector(integerValue)])
        cell.textLabel.text = [NSString stringWithFormat:@"Machine %i", [machine integerValue]];
    else
    {
        cell.textLabel.text = @"Added Money";
        isAddMoney = YES;
    }
    
    id dateValue = [item objectForKey:@"transaction_date"];
    NSString *dateStr = @"";
    if(dateValue != NULL)
    {
        dateStr = [self dateToLongString:dateValue];
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Date: %@",  dateStr];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 80, 40)];
    id amount = [item objectForKey:@"amount"];
    lb.text = [NSString stringWithFormat:@"$%.2f", [amount floatValue]];
    lb.textAlignment = UITextAlignmentRight;
    if(isAddMoney)
        lb.textColor = [UIColor greenColor];
    else
        lb.textColor = [UIColor redColor];
    cell.accessoryView = lb;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSDate*)dateTimeFromString:(NSString*)stringObj
{
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	NSDate* result = [dateFormatter dateFromString:stringObj];
	return result;
}

- (NSString*)dateToLongString:(NSDate*)dateObj
{
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd/MM/yyyy"];
	NSString* result = [dateFormatter stringFromDate:dateObj];
	return result;
}

@end
