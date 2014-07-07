//
//  CategorizedViewController.h
//  FinTracker
//
//  Created by Robin Mukanganise on 2014/06/26.
//  Copyright (c) 2014 Robin. All rights reserved.
//

#import "TransactionsTableViewController.h"
#import "Transaction.h"
#import "EColumnChart.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
#include <stdlib.h>



//@interface CategorizedViewController : ViewController

@interface CategorizedViewController : UIViewController <EColumnChartDelegate, EColumnChartDataSource>

@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (nonatomic, strong) NSArray *data;

@end
