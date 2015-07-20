//
//  FISZipCode.h
//  multiThreadLab
//
//  Created by Gan Chau on 7/19/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISZipCode : NSObject

@property (strong, nonatomic) NSString *county;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;

@end
