//
//  TransactionsTableViewController.h
//  FinTracker
//
//  Created by Robin Mukanganise on 2014/06/29.
//  Copyright (c) 2014 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionsTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *categorizedButton;
@property (strong, nonatomic) NSDictionary *dataset;
@property (strong, nonatomic) NSMutableArray *listView;
@end
