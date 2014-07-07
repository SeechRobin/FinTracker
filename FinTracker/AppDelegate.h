//
//  AppDelegate.h
//  FinTracker
//
//  Created by Robin Mukanganise on 2014/06/24.
//  Copyright (c) 2014 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TransactionsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)  TransactionsViewController *viewController;

@end
