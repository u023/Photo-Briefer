//
//  ViewController.m
//  Photo Briefer
//
//  Created by yonglim on 2/16/17.
//  Copyright © 2017 u023. All rights reserved.
//

#import "FlickrKit.h"

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, retain) FKFlickrNetworkOperation *todaysInterestingOp;
@property (nonatomic, retain) FKFlickrNetworkOperation *myPhotostreamOp;
@property (nonatomic, retain) FKDUNetworkOperation *completeAuthOp;
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;
@property (nonatomic, retain) FKImageUploadNetworkOperation *uploadOp;
@property (nonatomic, retain) NSString *userID;

@end

@implementation ViewController

- (void) dealloc {
    [self.todaysInterestingOp cancel];
    [self.myPhotostreamOp cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticateCallback:) name:@"UserAuthCallbackNotification" object:nil];
    
    // Check if there is a stored token
    // You should do this once on app launch
    self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self userLoggedIn:userName userID:userId];
            } else {
                [self userLoggedOut];
            }
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)userLoggedIn:(NSString *)username userID:(NSString *)userID {
    self.userID = userID;
    [self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
    self.authLabel.text = [NSString stringWithFormat:@"You are logged in as %@", username];
}

- (void)userLoggedOut {
    [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
    self.authLabel.text = @"Login to flickr";
}


- (IBAction)authButtonPressed:(id)sender {
}

- (IBAction)loadTodaysInterestingPressed:(id)sender {
}

- (IBAction)photostreamButtonPressed:(id)sender {
}

- (IBAction)choosePhotoPressed:(id)sender {
}

- (IBAction)searchErrorPressed:(id)sender {
}

- (IBAction)searchPressed:(id)sender {
}

@end
