//
//  PBPhotoUploadViewController.h
//  Photo Briefer
//
//  Created by yonglim on 3/6/17.
//  Copyright © 2017 u023. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBPhotoUploadViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end
