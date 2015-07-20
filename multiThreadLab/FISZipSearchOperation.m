//
//  FISZipSearchOperation.m
//  multiThreadLab
//
//  Created by Gan Chau on 7/19/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import "FISZipSearchOperation.h"

@implementation FISZipSearchOperation

- (instancetype)initWithSearchZipCode:(NSString *)searchZipCode
{
    self = [super init];
    
    if (self) {
        _searchZipCode = searchZipCode;
    }
    
    return self;
}

- (void)main
{
    if (self.searchZipCode.length != 5) {
        NSDictionary *userInfo = @{ @"NSLocalizedDescriptionKey" : @"Zip Codes need to be 5 digits"};
        NSError *error = [[NSError alloc] initWithDomain:@"Zipcode not found" code:101 userInfo:userInfo];
        self.zipCodeBlock(nil, error);
        return;
    }
    
    __block BOOL zipCodeFound = NO;
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        FISZipCode *zipCode = [[FISZipCode alloc] init];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zip_codes_states" ofType:@"csv"];
        NSString *contents = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUTF8StringEncoding error:nil];
        NSArray *rows = [contents componentsSeparatedByString:@"\n"];
        NSMutableArray *arrayOfZipCodeColumns = [@[] mutableCopy];
        
        NSLog(@"I'm HERE");
        
        for (NSString *row in rows) {
            [arrayOfZipCodeColumns addObject:[row componentsSeparatedByString:@","]];
        }
        
        for (NSArray *column in arrayOfZipCodeColumns) {
            if ([self.searchZipCode isEqualToString:[column[0] stringByReplacingOccurrencesOfString:@"\""  withString:@""]]) {
                
                zipCodeFound = YES;
                
                NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
                [mainQueue addOperationWithBlock:^{
                    
                    zipCode.county = [column[5] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    zipCode.city = [column[3] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    zipCode.state = [column[4] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    zipCode.latitude = column[1];
                    zipCode.longitude = [column[2] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    
                    self.zipCodeBlock(zipCode, nil);

                }];
            }
        }

        if (zipCodeFound == NO) {
            
            NSDictionary *userInfo = @{ @"NSLocalizedDescriptionKey" : @"Couldn't find that zip code"};
            NSError *error = [[NSError alloc] initWithDomain:@"Zipcode not found" code:102 userInfo:userInfo];
            self.zipCodeBlock(nil, error);
            return;
        }
    
    }];
    [operationQueue addOperation:blockOperation];
    
    
}

@end
