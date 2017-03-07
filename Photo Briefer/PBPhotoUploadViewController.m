//
//  PBPhotoUploadViewController.m
//  Photo Briefer
//
//  Created by yonglim on 3/6/17.
//  Copyright © 2017 u023. All rights reserved.
//

#import "PBPhotoUploadViewController.h"

@interface PBPhotoUploadViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadImageButton;

@end

@implementation PBPhotoUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectImageButtonPressed:(id)sender
{
    [self showActionSheet];
}

- (IBAction)uploadImageButtonPressed:(id)sender
{
    
}

- (void)camera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)photoLibrary
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showActionSheet
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Action Sheet" message:@"Using the alert controller" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self camera];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self photoLibrary];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
