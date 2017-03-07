//
//  ViewController.m
//  Photo Briefer
//
//  Created by yonglim on 2/16/17.
//  Copyright © 2017 u023. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrKit.h"

#import "ViewController.h"
#import "PBAuthViewController.h"
#import "PBPhotosViewController.h"
#import "MyPhotosViewController.h"

@interface ViewController ()

@property (nonatomic, retain) FKFlickrNetworkOperation *todaysInterestingOp;
@property (nonatomic, retain) FKFlickrNetworkOperation *myPhotostreamOp;
@property (nonatomic, retain) FKDUNetworkOperation *completeAuthOp;
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;
@property (nonatomic, retain) FKImageUploadNetworkOperation *uploadOp;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSMutableArray *photoURLs;
@property (nonatomic, retain) NSMutableArray *myPhotoURLs;

@end

@implementation ViewController
@synthesize photoURLs = _photoURLs;
@synthesize myPhotoURLs = _myPhotoURLs;

- (void) dealloc
{
    [self.todaysInterestingOp cancel];
    [self.myPhotostreamOp cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticationCallback:) name:@"UserAuthCallbackNotification" object:nil];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Cancel any operations when you leave views
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.todaysInterestingOp cancel];
    [self.myPhotostreamOp cancel];
    [self.completeAuthOp cancel];
    [self.checkAuthOp cancel];
    [self.uploadOp cancel];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Auth

- (void)userAuthenticationCallback:(NSNotification *)notification
{
    
    //TODO: need to figure out why we want to call this...?
    NSURL *callbackURL = notification.object;
    
    self.completeAuthOp = [[FlickrKit sharedFlickrKit] completeAuthWithURL:callbackURL completion:^(NSString * _Nullable userName, NSString * _Nullable userId, NSString * _Nullable fullName, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self userLoggedIn:userName userID:userId];
            } else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];

            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
}

- (void)userLoggedIn:(NSString *)username userID:(NSString *)userID
{
    self.userID = userID;
    [self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
    self.authLabel.text = [NSString stringWithFormat:@"You are logged in as %@", username];
}

- (void)userLoggedOut
{
    [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
    self.authLabel.text = @"Login to flickr";
}


- (IBAction)authButtonPressed:(id)sender
{
    if ([FlickrKit sharedFlickrKit].isAuthorized) {
        [[FlickrKit sharedFlickrKit] logout];
        [self userLoggedOut];
    } else {
//        PBAuthViewController *authView = [[PBAuthViewController alloc] init];
//        [self.navigationController pushViewController:authView animated:YES];
        
         [self performSegueWithIdentifier:@"SegueToAuth" sender:self];
    }
}

- (IBAction)loadTodaysInterestingPressed:(id)sender
{
    /* 
     Example using the modell objects
     */
    
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    interesting.per_page = @"15";
    self.todaysInterestingOp = [[FlickrKit sharedFlickrKit] call:interesting completion:^(NSDictionary<NSString *,id> * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response) {
                _photoURLs = [NSMutableArray array];
                for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                    NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
                    [_photoURLs addObject:url];
                }
                
                //TODO add PBPhotosViewController to display these photo here.
                // When I do this route, I can't get the imageScrollView working somehow :(
//                PBPhotosViewController *photosView = [[PBPhotosViewController alloc] initWithURLArray:photoURLs];
//                [self.navigationController pushViewController:photosView animated:YES];
                [self performSegueWithIdentifier:@"SegueToPhotos" sender:self];
                
            } else {
                //Error handling
                switch (error.code) {
                    case FKFlickrInterestingnessGetListError_ServiceCurrentlyUnavailable:
                        
                        break;
                        
                    default:
                        break;
                }
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        });
    }];
}

- (IBAction)photostreamButtonPressed:(id)sender
{
    if ([FlickrKit sharedFlickrKit].isAuthorized) {
        
        //NSDictionary *args = @{ @"user_id": self.userID, @"per_page": @"15" };
        
        self.myPhotostreamOp = [[FlickrKit sharedFlickrKit] call:@"flickr.photos.search" args:@{@"user_id": self.userID, @"per_page": @"15"} maxCacheAge:FKDUMaxAgeNeverCache completion:^(NSDictionary<NSString *,id> * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response) {
                    _myPhotoURLs = [NSMutableArray array];
                    
                    for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                        NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
                        [_myPhotoURLs addObject:url];
                    }
                    
//                    PBPhotosViewController *photosView = [[PBPhotosViewController alloc] initWithURLArray:_myPhotoURLs];
//                    [self.navigationController pushViewController:photosView animated:YES];
                    // segue to
                    [self performSegueWithIdentifier:@"SegueToMyPhotos" sender:self];
                    
                } else {
                    [self showErrorAlertWithMessage:error];
                }
            });
        }];
    } else {
        [self showLoginError];
    }
}

- (IBAction)choosePhotoPressed:(id)sender
{
    if ([FlickrKit sharedFlickrKit].isAuthorized) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
//        NSString *msg = @"Please login first";
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:msg preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [alert dismissViewControllerAnimated:YES completion:nil];
//        }];
//        [alert addAction:cancel];
//        [self presentViewController:alert animated:YES completion:nil];
        [self showLoginError];
    }
}

- (IBAction)searchErrorPressed:(id)sender
{
}

- (IBAction)searchPressed:(id)sender
{
    [self.view endEditing:YES];
    
    FKFlickrPhotosSearch *search = [[FKFlickrPhotosSearch alloc] init];
    search.text = self.searchText.text;
    search.per_page = @"15";
    [[FlickrKit sharedFlickrKit] call:search completion:^(NSDictionary<NSString *,id> * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response) {
                NSMutableArray *photoURLs = [NSMutableArray array];
                for (NSDictionary *photoDict in [response valueForKeyPath:@"photos.photo"]) {
                    NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDict];
                    [photoURLs addObject:url];
                }
                
                [self performSegueWithIdentifier:@"SegueToPhotos" sender:self];
            } else {
                [self showErrorAlertWithMessage:error];
            }
        });
    }];
}

#pragma mark - Error Message Dialog

- (void)showErrorAlertWithMessage:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showLoginError
{
    NSString *msg = @"Please login first";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Progress KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        self.progress.progress = progress;
        //[super observeValueForKeyPath:keyPath, ofObject:object change:change context:context];
    });
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    NSURL* imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    NSDictionary *uploadArgs = @{@"title": @"Test Photo", @"description": @"A Test Photo via FlickrKitDemo", @"is_public": @"0", @"is_friend": @"0", @"is_family": @"0", @"hidden": @"2"};
    
    self.progress.progress = 0.0;
    self.uploadOp = [[FlickrKit sharedFlickrKit] uploadAssetURL:imageURL args:uploadArgs completion:^(NSString * _Nullable imageID, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else {
                NSString *msg = [NSString stringWithFormat:@"Uploaded image ID %@", imageID];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Done" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
            [self.uploadOp removeObserver:self forKeyPath:@"uploadProgress" context:NULL];
        });
    }];
    
    [self.uploadOp addObserver:self forKeyPath:@"uploadProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"SegueToPhotos"]) {
        PBPhotosViewController *photosView = [segue destinationViewController];
        photosView.photoURLs = _photoURLs;
    } else if ([segue.identifier isEqualToString:@"SegueToMyPhotos"]) {
        MyPhotosViewController *myPhotosView = [segue destinationViewController];
        myPhotosView.myPhotoURLs = _myPhotoURLs;
    }
}


@end
