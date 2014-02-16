//
//  SWHistoryViewController.h
//  MoneyLaundering
//
//  Created by Anatoly Macarov on 1/25/14.
//  Copyright (c) 2014 sweuroseattle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface SWHistoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;
@property (strong, nonatomic) UIBarButtonItem *btnRefresh;
@end
