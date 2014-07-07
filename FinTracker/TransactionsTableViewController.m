//
//  TransactionsTableViewController.m
//  FinTracker
//
//  Created by Robin Mukanganise on 2014/06/29.
//  Copyright (c) 2014 Robin. All rights reserved.
//

#import "TransactionsTableViewController.h"
#import "Transaction.h"

NSString *transactionClass;
NSString *category;
double   amount;
NSString *debitOrCredit;
NSString *year;
NSString *month;
NSString *day;
NSString *transactionDescription;
NSDate *date;
NSDate *cleanDate;
NSString *dateStr;
int counter;

@implementation TransactionsTableViewController
@synthesize dataset = _dataset;
@synthesize categorizedButton = _categorizedButton;
@synthesize listView = _listView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadJSONFromRemote];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    // Return the number of rows in the section.
    NSLog(@"count %lu", (unsigned long)[_listView count] );
    return [_listView count] ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"TransactionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.text = [_listView objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];

    
    return cell;  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)persistwithTransactions:(NSString *)transactionClass category:(NSString *)category amount:(double*)amount debitOrCredit:(NSString *) debitOrCredit date:(NSDate *)date transactionDescription:(NSString *)transactionDescription
{
    
    // Create new transaction
    Transaction *newTransaction = [Transaction MR_createEntity];
    newTransaction.transactionClass = transactionClass;
    newTransaction.category = category;
    newTransaction.amount = [NSNumber numberWithDouble:*amount];
    newTransaction.debitOrCredit = debitOrCredit;
    newTransaction.date = date;
    newTransaction.transactionDescription = transactionDescription;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
}

-(void)loadJSONFromRemote
{
    
    [self refresh]; //refresh each time to fetch new data from server
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://s3-eu-west-1.amazonaws.com/22seven-web/transactions_for_robin.json"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       
        NSLog(@"Number %lu", (unsigned long)[responseObject count]);
        //Search for all the transactions
        
        for (counter=0;counter<[responseObject count]; counter++) {
            
            _dataset = [NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject[counter]];
            
            
            transactionClass = [[_dataset objectForKey:@"transactionClass"] objectForKey:@"description"];
            category = [[_dataset objectForKey:@"category"] objectForKey:@"description"];
            amount = [[[_dataset objectForKey:@"amount"] objectForKey:@"amount"] doubleValue];
            debitOrCredit = [[_dataset objectForKey:@"amount"] objectForKey:@"debitOrCredit"];
            year = [_dataset objectForKey:@"transactionDateYear"];
            month = [_dataset objectForKey:@"transactionDateMonth"];
            day = [_dataset objectForKey:@"transactionDateDay"];
            transactionDescription = [_dataset objectForKey:@"description"];
            
            dateStr = [NSString stringWithFormat:@"%@-%@-%@",day,month,year];
           
           
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd-mm-yyyy"];
            date = [dateFormatter dateFromString:dateStr];
        
            [self persistwithTransactions:transactionClass category:category amount:&amount debitOrCredit:debitOrCredit date:date transactionDescription:transactionDescription];
            
        }
        
        [_categorizedButton setEnabled:YES]; //wait for the transactions to be loaded
        [self fillTransactionList]; //populate transaction list
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Financial Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    
    [operation start];
    NSLog(@"Finished Loading");
}

- (void)refresh
{
    NSLog(@"Refreshing");
    [Transaction MR_truncateAll];
}

- (void) fillTransactionList
{
    _listView = [NSMutableArray array];
    NSString *date;
    NSString *description;
    NSString *amount;
   
    NSArray *trans = [Transaction MR_findAllSortedBy:@"date" ascending:NO];
    
    for (int i=0; i<[trans count]; i++) {
        Transaction *transaction = [ trans objectAtIndex:i];
        date = (NSString *)transaction.date;
        description = transaction.transactionDescription;
        amount = (NSString *)transaction.amount;
       
        NSString *newStr = [[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(0,10)];
        
      
        [_listView addObject:[NSString stringWithFormat:@"%@    %@    %@", newStr, description, amount]];
    }
   
    [self.tableView reloadData]; //fill list view
}

@end
