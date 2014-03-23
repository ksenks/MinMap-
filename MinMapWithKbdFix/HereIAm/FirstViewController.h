//
//  FirstViewController.h
//  MinMap
//
//  Created by Lori Hill on 3/22/14.
//  Copyright (c) 2014 Lori Hill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface FirstViewController : UIViewController <CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    CLLocationManager *locationManager;   
}
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

- (IBAction)checkIn:(id)sender;

@end
