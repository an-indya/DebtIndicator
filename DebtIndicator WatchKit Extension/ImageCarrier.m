//
//  ImageCarrier.m
//  DebtIndicator
//
//  Created by Anindya Sengupta on 22/12/2014.
//  Copyright (c) 2014 Anindya Sengupta. All rights reserved.
//

#import "ImageCarrier.h"

@implementation ImageCarrier

+(instancetype) sharedCarrier {
    
    static ImageCarrier *imageCarrier;
    static dispatch_once_t *onceToken;
    
    dispatch_once(onceToken, ^{
        imageCarrier = [[ImageCarrier alloc] init];
    });
    
    return imageCarrier;
}

@end
