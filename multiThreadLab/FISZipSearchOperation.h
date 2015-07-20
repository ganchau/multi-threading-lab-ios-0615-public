//
//  FISZipSearchOperation.h
//  multiThreadLab
//
//  Created by Gan Chau on 7/19/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FISZipCode.h"

@interface FISZipSearchOperation : NSOperation

@property (strong, nonatomic) NSString *searchZipCode;
@property (copy, nonatomic) void (^zipCodeBlock)(FISZipCode *zipCode, NSError *error);

- (instancetype)initWithSearchZipCode:(NSString *)searchZipCode;

@end