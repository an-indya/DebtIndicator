//
//  ViewController.m
//  DebtIndicator
//
//  Created by Anindya Sengupta on 21/12/2014.
//  Copyright (c) 2014 Anindya Sengupta. All rights reserved.
//

#import "ViewController.h"
#import "Loan.h"
#import "Constants.h"
#import "CorePlot-CocoaTouch.h"
#import "UIView+Ext.h"

#define kJSONFileName "Loans"

@interface ViewController () <CPTPieChartDataSource, CPTPieChartDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nextPayment;
@property (weak, nonatomic) IBOutlet UILabel *outstandingLoan;
@property (weak, nonatomic) IBOutlet UILabel *paidLoan;
@property (weak, nonatomic) IBOutlet UILabel *totalLoan;
@property (weak, nonatomic) IBOutlet UILabel *accountNumber;

@property (strong, nonatomic) Loan *loan;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *hostView;
@property (weak, nonatomic) IBOutlet UIImageView *graph;

- (void)initPlot;
-(void)configureGraph;
-(void)configureChart;

@end

@implementation ViewController

- (void)initPlot {
    [self configureGraph];
    [self configureChart];
    
    UIImage *image = [self.hostView imageByRenderingView];
    NSData *pngData = UIImagePNGRepresentation(image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"chartImage.png"]; //Add the file name
    [pngData writeToFile:filePath atomically:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInterface];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWatchKitNotification:) name:@"WatchKitNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self initPlot];
}

-(void) setupInterface {
    
    NSError *error = nil;
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@kJSONFileName ofType:@"json"];
    NSDictionary *loans = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonFilePath] options:kNilOptions error:&error];
    
    self.loan = [[Loan alloc] initWithLoanAmount:loans[kLoanAmount] Outstanding:loans[kOutstanding]Paid:loans[kPaid] AccountNo:loans[kAccountNo] nextInstall:loans[kNextInstallment]];
    Loan *loan = self.loan;
    
    self.accountNumber.text = loan.accountNo;
    self.outstandingLoan.text = [NSString stringWithFormat:@"£%@",loan.outstanding];
    self.paidLoan.text = [NSString stringWithFormat:@"£%@", loan.paid];
    self.totalLoan.text = [NSString stringWithFormat:@"£%@",loan.loanAmount];
    self.nextPayment.text = loan.nextInstallment;
}


-(void)configureGraph {
    //Create and initialize graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.axisSet = nil;
    // Set up text stile
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 16.0f;
    
    // Configure title
    NSString *title = @"Loan Repayment";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
    // Set theme
    
    graph.borderWidth = 5;
    graph.borderColor = [[UIColor blackColor] CGColor];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainBlackTheme]];
}

-(void)configureChart {
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = (self.hostView.bounds.size.height * 0.7) / 2;
    pieChart.identifier = graph.title;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    pieChart.labelOffset = -100;
    // 3 - Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    // 4 - Add chart to graph
    [graph addPlot:pieChart];
}




#pragma mark - CPTPlotDataSource methods
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 2;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    NSDecimalNumber *number = (idx == 0) ? [NSDecimalNumber decimalNumberWithString:self.loan.outstanding]: [NSDecimalNumber decimalNumberWithString:self.loan.paid];
    return number;
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx {
    static CPTMutableTextStyle *labelText = nil;
    
    if (!labelText) {
        labelText= [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor whiteColor];
    }
    
    NSString *labelValue = idx > 0 ? [NSString stringWithFormat:@"£%@", self.loan.paid] : [NSString stringWithFormat:@"£%@", self.loan.outstanding];
    
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
    return textLayer;
}

-(void) handleWatchKitNotification: (NSNotification*) aNotification {
    [self initPlot];

}

@end
