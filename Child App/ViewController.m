//
//  ViewController.m
//  Child App
//
//  Created by Rael Kenny on 10/23/16.
//  Copyright © 2016 Rael Kenny. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    [self.locationManager stopUpdatingLocation];
    
    [NSTimer scheduledTimerWithTimeInterval:40.0
                                     target:self
                                   selector:@selector(reportLocation:)
                                   userInfo:nil
                                    repeats:NO];
    
    
    //CLLocation *childsLocation = locations[0];
    [self locationInServer: locations[0]];
}


-(void) locationInServer: (CLLocation *)location {
    
  
NSString *latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
NSString *longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
   // NSLog(@"Latitude: %@", latitude);
   // NSLog(@"Longitude: %@", longitude);
    NSString *username = self.usernameTextField.text;
    
              self.childDict = @{
                                @"username":username,
                                @"current_latitude":latitude,
                                @"current_longitude":longitude
                                };
    
    //Dictionary ->JSON
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.childDict
                                                       options:0
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"We have an error %@", error);
    } else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", username]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPBody:jsonData];
        [request setHTTPMethod:@"PATCH"];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:
                             [NSURLSessionConfiguration defaultSessionConfiguration]];
        
        [[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        if (error) {
                            NSLog(@"We have an error %@", error);
                        } else {
                            NSLog(@"Request complete");
                            dispatch_async(dispatch_get_main_queue(), ^{
                            [self performSegueWithIdentifier:@"Locationsent" sender:self];
                            });
                        }
                        
                    }]
         resume];
        
    }
}


- (IBAction)reportLocation:(id)sender {
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

}
@end
