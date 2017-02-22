//
//  ViewController.m
//  Photo Briefer
//
//  Created by yonglim on 2/16/17.
//  Copyright © 2017 u023. All rights reserved.
//

#import "FlickrKit.h"

#import "ViewController.h"
#import "PBAuthViewController.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    // Cancel any operations when you leave views
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.todaysInterestingOp cancel];
    [self.myPhotostreamOp cancel];
    [self.completeAuthOp cancel];
    [self.checkAuthOp cancel];
    [self.uploadOp cancel];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Auth

- (void)userAuthenticationCallback:(NSNotification *)notification {
    
    //TODO: need to figure out why we want to call this...?
    NSURL *callbackURL = notification.object;
    
    self.completeAuthOp = [[FlickrKit sharedFlickrKit] completeAuthWithURL:callbackURL completion:^(NSString * _Nullable userName, NSString * _Nullable userId, NSString * _Nullable fullName, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self userLoggedIn:userName userID:userId];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
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
    if ([FlickrKit sharedFlickrKit].isAuthorized) {
        [[FlickrKit sharedFlickrKit] logout];
        [self userLoggedOut];
    } else {
        PBAuthViewController *authView = [[PBAuthViewController alloc] init];
        [self.navigationController pushViewController:authView animated:YES];
    }
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
