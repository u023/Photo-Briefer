//
//  ViewController.h
//  Photo Briefer
//
//  Created by yonglim on 2/16/17.
//  Copyright © 2017 u023. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *photostreamButton;
@property (weak, nonatomic) IBOutlet UIButton *authButton;
@property (weak, nonatomic) IBOutlet UILabel *authLabel;
@property (weak, nonatomic) IBOutlet UILabel *todaysInterestingLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchText;

- (IBAction)authButtonPressed:(id)sender;
- (IBAction)loadTodaysInterestingPressed:(id)sender;
- (IBAction)photostreamButtonPressed:(id)sender;
- (IBAction)choosePhotoPressed:(id)sender;
- (IBAction)searchErrorPressed:(id)sender;
- (IBAction)searchPressed:(id)sender;

@end
