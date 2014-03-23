//
//  FirstViewController.m
//  MinMap
//
//  Created by Lori Hill on 3/22/14.
//  Copyright (c) 2014 Lori Hill. All rights reserved.
//

#import "FirstViewController.h"
#import "MinMapData.h"

static NSString * const kTagViewSegueId = @"tagViewSegueId";

@interface FirstViewController ()

@property (strong, nonatomic) CLLocation *myLocation;
@property (strong, nonatomic) NSArray *categoryNames;
@property (strong, nonatomic) IBOutlet UISegmentedControl *needProvided;

@end

@implementation FirstViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
		[self getCurrentLocation];
	      self.categoryNames = @[@"Bible Studies", @"Career Services",@"Education",@"Food", @"Housing", @"Legal",
              @"Physical/Mental Health",@"Neighborhood Watch",
                @"Shelter-temp", @"Worship"];
		[self.picker selectRow:2 inComponent:0 animated:YES];
		
		UIFont *font = [UIFont boldSystemFontOfSize:16.f];
		NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
		[self.needProvided setTitleTextAttributes:attributes forState:UIControlStateNormal];
		
			 
}

-(void) getCurrentLocation {

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
	self.myLocation = [locations lastObject];
    NSLog(@"NewLocation %f %f", self.myLocation.coordinate.latitude, self.myLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed %ld",(long)[error code]);

}
- (NSString *) getFormattedDate {

	NSDate *localDate = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
	timeFormatter.dateFormat = @"HH:mm:ss";
	timeFormatter.timeZone = [NSTimeZone localTimeZone];

	NSString *dateString = [dateFormatter stringFromDate: localDate];
	NSString *timeString = [timeFormatter stringFromDate: localDate];

	NSString *formattedDateString = [NSString stringWithFormat: @"%@T%@", dateString, timeString];
	NSLog (@"formattedDateString is %@", formattedDateString);

	return formattedDateString;
}
#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
        return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
      numberOfRowsInComponent:(NSInteger)component
{
        return self.categoryNames.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
titleForRow:(NSInteger)row
forComponent:(NSInteger)component
{
    return self.categoryNames[row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkIn:(id)sender {
//	[self sendToServer];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	if ([segue.identifier isEqualToString: kTagViewSegueId]) {
		MinMapData *minmap = [MinMapData sharedInstance];
		minmap.category = self.categoryNames[[self.picker selectedRowInComponent:0]];
		minmap.neededProvided = self.needProvided.selectedSegmentIndex == 1;
		minmap.location = self.myLocation;
		minmap.formattedDateString = [self getFormattedDate];
		NSLog (@"%@, %@, %@, %@", minmap.category, @(minmap.neededProvided), minmap.location, minmap.formattedDateString);
		}
	
}
@end
