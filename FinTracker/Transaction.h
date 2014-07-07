//
//  Transaction.h
//  FinTracker
//
//  Created by Robin Mukanganise on 2014/06/26.
//  Copyright (c) 2014 Robin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSString * transactionClass;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * debitOrCredit;
@property (nonatomic, retain) NSString * transactionDescription;

@end
