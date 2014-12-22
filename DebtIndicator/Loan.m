//
//  Loan.m
//  DebtIndicator
//
//  Created by Anindya Sengupta on 21/12/2014.
//  Copyright (c) 2014 Anindya Sengupta. All rights reserved.
//

#import "Loan.h"

@implementation Loan

-(instancetype) initWithLoanAmount: (NSString *) loanAmt
                       Outstanding: (NSString *) outstandingAmt
                              Paid: (NSString *) paidAmt
                         AccountNo: (NSString *) accountNumber
                       nextInstall: (NSString *) nextDate {
    if (self = [super init]) {
        self.loanAmount = loanAmt;
        self.outstanding = outstandingAmt;
        self.paid = paidAmt;
        self.accountNo = accountNumber;
        self.nextInstallment = nextDate;
    }
    return self;
}

@end
