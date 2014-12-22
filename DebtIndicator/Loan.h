//
//  Loan.h
//  DebtIndicator
//
//  Created by Anindya Sengupta on 21/12/2014.
//  Copyright (c) 2014 Anindya Sengupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Loan : NSObject

@property (nonatomic, strong) NSString *loanAmount;
@property (nonatomic, strong) NSString *outstanding;
@property (nonatomic, strong) NSString *paid;
@property (nonatomic, strong) NSString *accountNo;
@property (nonatomic, strong) NSString *nextInstallment;

-(instancetype) initWithLoanAmount: (NSString *) loanAmt
                       Outstanding: (NSString *) outstandingAmt
                              Paid: (NSString *) paidAmt
                         AccountNo: (NSString *) accountNumber
                       nextInstall: (NSString *) nextDate;
@end
