//
//  GlanceController.m
//  DebtIndicator WatchKit Extension
//
//  Created by Anindya Sengupta on 21/12/2014.
//  Copyright (c) 2014 Anindya Sengupta. All rights reserved.
//

#import "GlanceController.h"
#import "ImageCarrier.h"

@interface GlanceController()


@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"chartImage.png"];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    [self.glanceImage setImageData:pngData];
    
   
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



