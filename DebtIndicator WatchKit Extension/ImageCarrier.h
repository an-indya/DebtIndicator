//
//  ImageCarrier.h
//  DebtIndicator
//
//  Created by Anindya Sengupta on 22/12/2014.
//  Copyright (c) 2014 Anindya Sengupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCarrier : NSObject

@property (nonatomic, strong) NSData *imageData;

+(instancetype) sharedCarrier;

@end
