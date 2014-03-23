//
//  TagViewController.m
//  MinMap
//
//  Created by Lori Hill on 3/22/14.
//  Copyright (c) 2014 Lori Hill. All rights reserved.
//

#import "TagViewController.h"
#import "MBProgressHUD.h"
#import "MinMapData.h"


@interface TagViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardShownConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultConstraint;

@end

@implementation TagViewController

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
    // Do any additional setup after loading the view.
	self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
	self.textView.layer.borderWidth = 1.f;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(onKeyboardWillHide:)
												 name:UIKeyboardWillHideNotification object:nil];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		return NO;
	}
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) sendToServer {

		MinMapData *minmap = [MinMapData sharedInstance];
		
		NSCharacterSet *separaters = [NSCharacterSet characterSetWithCharactersInString:@" ,;"];
		
		NSArray *separatedTags = [self.textView.text componentsSeparatedByCharactersInSet:separaters];
		NSError *error = nil;
		NSData *jsonData = [NSJSONSerialization dataWithJSONObject:
		@{@"lonlat":@[@(minmap.location.coordinate.longitude), @(minmap.location.coordinate.latitude)],
		@"tag":separatedTags,
		@"dateTime": minmap.formattedDateString,
		@"channel":@"judges",
		@"neededProvided":minmap.neededProvided ? @"provided" : @"needed"} options:0 error:&error];
		

//	NSString *dataString = [NSString stringWithFormat: @"{\"lonlat\" : [%f, %f],\"tag\" : [\"food\", \"family\"],\"dateTime\" : \"%@\",\"channel\" : \"iOS\",\"category\" : \"%@\",\"neededProvided\" : \"%@\"}", minmap.location.coordinate.longitude, minmap.location.coordinate.latitude, minmap.formattedDateString, minmap.category, ];
	
    // Show progress window
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Uploading...";
    
    // Start NSURLSession
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    // POST parameters
    NSURL *url = [NSURL URLWithString:@"http://elasticsearch-imprint.rhcloud.com/minmap/checkin/"];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
		//set request content type we MUST set this value.
	[urlRequest setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	
    
    // NSURLSessionDataTask returns data, response, and error
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                      completionHandler:^(NSData *data,
                                                                          NSURLResponse *response,
                                                                          NSError *error) {
                                                          
                                                          // Remove progress window
                                                          [MBProgressHUD hideHUDForView:self.view animated:YES];

                                                          // Handle response
//                                                          NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//                                                          NSInteger statusCode = [httpResponse statusCode];
//                                                          if(error == nil) {
//                                                              
//                                                              if (statusCode == 200) {
//                                                                  
//                                                                  // Parse out the JSON data
//                                                                  NSError *jsonError;
//                                                                  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
//                                                                                                                       options:kNilOptions
//                                                                                                                         error:&jsonError];
//                                                                  
//                                                                  NSString* unlockCode = [json objectForKey:@"unlock_code"];
//                                                                  
//                                                                  // JSON data parsed, continue handling response
//                                                                  if ([unlockCode compare:@"com.razeware.test.unlock.cake"] == NSOrderedSame) {
//                                                                      _textView.text = @"The cake is a lie!";
//                                                                  } else {
//                                                                      _textView.text = [NSString stringWithFormat:@"Received unexpected unlock code: %@", unlockCode];
//                                                                  }
//                                                                  
//                                                              } else {
//                                                                  _textView.text = @"Check-in complete";
//                                                              }
//                                                          
//                                                          } else {
//                                                              _textView.text = @"Check-in complete!";
//                                                          }
                                                          
                                                      }];

    [dataTask resume];

//    return TRUE;

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[self sendToServer];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onKeyboardWillShow:(NSNotification *) notification {
	self.defaultConstraint.priority = UILayoutPriorityDefaultLow;
	self.keyboardShownConstraint.priority = UILayoutPriorityDefaultHigh;
	[self layoutIfNeededAnimatedWithNotification:notification];
}

- (void)onKeyboardWillHide:(NSNotification *)notification
{
	self.keyboardShownConstraint.priority = UILayoutPriorityDefaultLow;
	self.defaultConstraint.priority = UILayoutPriorityDefaultHigh;
	[self layoutIfNeededAnimatedWithNotification:notification];
}

- (void)layoutIfNeededAnimatedWithNotification:(NSNotification *)note
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
	// iOS 7 animates via an undocumented curve value (7); this value can not be set via "UIView animateWitOptions:..."
	[UIView setAnimationCurve:[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	[self.view layoutIfNeeded];
	
	[UIView commitAnimations];
}

@end
