//
//  CategorizedViewController.m
//  FinTracker
//
//  Created by Robin Mukanganise on 2014/06/26.
//  Copyright (c) 2014 Robin. All rights reserved.
//

#import "CategorizedViewController.h"


@implementation CategorizedViewController
@synthesize data = _data;


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
    // Do any additional setup after loading the view.
    [self createBarChartForCategories];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - load barChart

- (void)createBarChartForCategories
{
    NSArray *trans = [Transaction MR_findAll];
    
    NSMutableDictionary *categorizedList = [[NSMutableDictionary alloc ] init];
    double currentAmount = 0;
    double newAmount = 0;
    double temp = 0;
    
    
    for (int i=0; i<[trans count]; i++) {
        Transaction *transaction = [ trans objectAtIndex:i];
        // NSLog(@"%@  %@", transaction.category, transaction.amount);
        
        if([categorizedList objectForKey:transaction.category] == nil){
            [categorizedList setObject:transaction.amount forKey:transaction.category];
        }
        else{
            
            temp = [transaction.amount doubleValue];
            currentAmount = [[categorizedList objectForKey:transaction.category] doubleValue];
            
            newAmount = temp + currentAmount;
            //NSLog(@"%f %f", temp, currentAmount);
            
            [categorizedList setObject:[NSNumber numberWithDouble:newAmount] forKey:transaction.category];
        }
        
        
        
    }
    NSLog(@"----> %@", categorizedList);
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for(id key in categorizedList) {
        id value = [categorizedList objectForKey:key];
        NSString *category = key;
        NSString *amount_t = value;
        double amount = [amount_t doubleValue];
        
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:category value:amount index:1 unit:@""];
        [tempArray addObject:eColumnDataModel];
        
    }
    _data = [NSArray arrayWithArray:tempArray];
    
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40, 100, 400, 400)];
    [_eColumnChart setNormalColumnColor:[UIColor purpleColor]];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
	[_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    
    
    [self.view addSubview:_eColumnChart];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma -mark- EColumnChartDataSource
/** How many Columns are there in total.*/
- (NSInteger) numberOfColumnsInEColumnChart:(EColumnChart *) eColumnChart{
    return [_data count];
}

/** How many Columns should be presented on the screen each time*/
- (NSInteger) numberOfColumnsPresentedEveryTime:(EColumnChart *) eColumnChart{
    return [_data count];
    
}

/** The highest value among the whole chart*/
- (EColumnDataModel *)     highestValueEColumnChart:(EColumnChart *) eColumnChart{
    
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
    
}

/** Value for each column*/
- (EColumnDataModel *)     eColumnChart:(EColumnChart *) eColumnChart
                          valueForIndex:(NSInteger)index{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}


#pragma -mark- EColumnChartDelegate
- (void)eColumnChart:(EColumnChart *)eColumnChart
     didSelectColumn:(EColumn *)eColumn
{

}

/** When finger enter specific column, this is dif from tap*/
- (void)        eColumnChart:(EColumnChart *) eColumnChart
        fingerDidEnterColumn:(EColumn *) eColumn{
    
}

/** When finger leaves certain column, will tell you which column you are leaving*/
- (void)        eColumnChart:(EColumnChart *) eColumnChart
        fingerDidLeaveColumn:(EColumn *) eColumn
{
    
}

/** When finger leaves wherever in the chart, will trigger both if finger is leaving from a column */
- (void) fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart{
    
}
@end