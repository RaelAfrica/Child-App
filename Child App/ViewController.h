//
//  ViewController.h
//  Child App
//
//  Created by Rael Kenny on 10/23/16.
//  Copyright © 2016 Rael Kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (strong, nonatomic) NSDictionary *childDict;
//@property (strong, nonatomic) NSString *username;
@property (nonatomic, strong) CLLocationManager *locationManager;



- (IBAction)reportLocation:(id)sender;


@end

