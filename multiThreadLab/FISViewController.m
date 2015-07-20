//
//  FISViewController.m
//  multiThreadLab
//
//  Created by Joe Burgess on 4/26/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"
#import <CHCSVParser/CHCSVParser.h>
#import "FISZipSearchOperation.h"

@interface FISViewController () <CHCSVParserDelegate>

@property (weak, nonatomic) IBOutlet UITextField *zipCode;
@property (weak, nonatomic) IBOutlet UILabel *countyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
//@property (strong, nonatomic) NSMutableArray *arrayOfZipCodeColumns;
//@property (strong, nonatomic) NSOperationQueue *operationQueue;
//@property (nonatomic) BOOL zipCodeFound;

@end


@implementation FISViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.accessibilityLabel=@"Main View";
    // Do any additional setup after loading the view.
    
    //self.operationQueue = [[NSOperationQueue alloc] init];
    
    [NSTimer scheduledTimerWithTimeInterval:0.25
                                     target:self
                                   selector:@selector(changeBackgroundColor:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)changeBackgroundColor:(NSTimer *)timer
{
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(1000) / 1000.0
                                     green:arc4random_uniform(1000) / 1000.0
                                      blue:arc4random_uniform(1000) / 1000.0
                                     alpha:1];

    self.view.backgroundColor = color;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)removeQuotes:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
}

- (IBAction)searchZipCodeButtonTapped:(id)sender
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    FISZipSearchOperation *searchOperation = [[FISZipSearchOperation alloc] initWithSearchZipCode:self.zipCode.text];
    
    searchOperation.zipCodeBlock = ^(FISZipCode *zipCode, NSError *error)
    {        
        if (error.code == 101) {
            [self showAlertControllerWithMessage:error.userInfo[@"NSLocalizedDescriptionKey"]];
        } else if (error.code == 102) {
            [self showAlertControllerWithMessage:error.userInfo[@"NSLocalizedDescriptionKey"]];
        } else {
            self.countyLabel.text = zipCode.county;
            self.cityLabel.text = zipCode.city;
            self.stateLabel.text = zipCode.state;
            self.latitudeLabel.text = zipCode.latitude;
            self.longitudeLabel.text = zipCode.longitude;
        }
    };
    
    [operationQueue addOperation:searchOperation];
    
//    self.zipCodeFound = NO;
//
//    if (self.zipCode.text.length == 5) {
//        self.arrayOfZipCodeColumns = [@[] mutableCopy];
//        
//        NSBlockOperation *blockOeration = [NSBlockOperation blockOperationWithBlock:^{
//            
//            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zip_codes_states" ofType:@"csv"];
//            NSString *contents = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUTF8StringEncoding error:nil];
//            NSArray *rows = [contents componentsSeparatedByString:@"\n"];
//            
//            for (NSString *row in rows) {
//                [self.arrayOfZipCodeColumns addObject:[row componentsSeparatedByString:@","]];
//            }
//            
//            for (NSArray *column in self.arrayOfZipCodeColumns) {
//                if ([self.zipCode.text isEqualToString:[self removeQuotes:column[0]]]) {
//                    
//                    self.zipCodeFound = YES;
//                    
//                    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
//                    [mainQueue addOperationWithBlock:^{
//                        self.countyLabel.text = [self removeQuotes:column[5]];
//                        self.cityLabel.text = [self removeQuotes:column[3]];
//                        self.stateLabel.text = [self removeQuotes:column[4]];
//                        self.latitudeLabel.text = column[1];
//                        self.longitudeLabel.text = [self removeQuotes:column[2]];
//                        [self.zipCode resignFirstResponder];
//                    }];
//                    
//                    break;
//                }
//            }
//            
//            NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
//            [mainQueue addOperationWithBlock:^{
//                if (self.zipCodeFound == NO) {
//                    [self showAlertControllerWithMessage:@"Couldn't find that zip code"];
//                }
//
//            }];
//            
//        }];
//        
//        [self.operationQueue addOperation:blockOeration];
//
//        
////        if (self.zipCodeFound == NO) {
////            [self showAlertControllerWithMessage:@"Couldn't find that zip code"];
////        }
//    
//    } else {
//        
//        [self showAlertControllerWithMessage:@"Zip Codes need to be 5 digits"];
//    }
}

- (void)showAlertControllerWithMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Zip Code Error"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:OkAction];
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [mainQueue addOperationWithBlock:^{
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
