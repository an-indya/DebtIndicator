//
//  InterfaceController.m
//  DebtIndicator WatchKit Extension
//
//  Created by Anindya Sengupta on 21/12/2014.
//  Copyright (c) 2014 Anindya Sengupta. All rights reserved.
//

#import "InterfaceController.h"
#import "Loan.h"
#import "Constants.h"
#import "GlanceController.h"

#define kJSONFileName "Loans"

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *totalLoan;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *paidLoan;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *outstanding;
@property (strong, nonatomic) Loan *loan;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    NSError *error = nil;
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@kJSONFileName ofType:@"json"];
    NSDictionary *loans = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonFilePath] options:kNilOptions error:&error];
    
    self.loan = [[Loan alloc] initWithLoanAmount:loans[kLoanAmount] Outstanding:loans[kOutstanding]Paid:loans[kPaid] AccountNo:loans[kAccountNo] nextInstall:loans[kNextInstallment]];
    Loan *loan = self.loan;
    
    self.totalLoan.text = [NSString stringWithFormat:@"Account: %@",loan.accountNo];
    self.paidLoan.text = [NSString stringWithFormat:@"Outstanding: £%@",loan.outstanding];
    self.outstanding.text = [NSString stringWithFormat:@"Paid: £%@", loan.paid];
    
}

- (IBAction)refreshGlance {
    [self openParentAppToRefreshGraph];
}


-(void) openParentAppToRefreshGraph {
    [WKInterfaceController openParentApplication:[NSDictionary dictionaryWithObjectsAndKeys:@"ImageName", @"chartImage.png", nil] reply:^(NSDictionary *replyInfo, NSError *error) {
        NSData *pngData = replyInfo[@"Image"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"chartImage.png"]; //Add the file name
        [pngData writeToFile:filePath atomically:YES];
    }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    NSLog(@"%@ will activate", self);
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    NSLog(@"%@ did deactivate", self);
}


@end



