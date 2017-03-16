//
//  MyPhotosViewController.m
//  Photo Briefer
//
//  Created by yonglim on 3/4/17.
//  Copyright © 2017 u023. All rights reserved.
//

#import "FlickrKit.h"

#import "MyPhotosViewController.h"

@interface MyPhotosViewController ()
@property (nonatomic, retain) FKFlickrNetworkOperation *myPhotostreamOp;
@property (nonatomic, retain) NSMutableArray *photoURLs;
@end

@implementation MyPhotosViewController
//@synthesize myPhotoURLs = _myPhotoURLs;

//- (id)initWithURLArray:(NSArray *)urlArray
//{
//    self = [super init];
//    if (self) {
//        self.photoURLs = urlArray;
//    }
//    return self;
//}

- (id)init
{
    self = [super init];
    if (self) {
        self.photoURLs = _photoURLs;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getMyPhotoURLs];
    
    for (NSURL *url in self.photoURLs) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            [self addImageToView:image];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.myPhotostreamOp cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) dealloc
{
    [self.myPhotostreamOp cancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addImageToView:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat width = CGRectGetWidth(self.imageScrollView.frame);
    CGFloat imageRatio = image.size.width / image.size.height;
    CGFloat height = width / imageRatio;
    CGFloat x = 0;
    CGFloat y = self.imageScrollView.contentSize.height;
    
    imageView.frame = CGRectMake(x, y, width, height);
    
    CGFloat newHeight = self.imageScrollView.contentSize.height + height;
    self.imageScrollView.contentSize = CGSizeMake(320, newHeight);
    
    [self.imageScrollView addSubview:imageView];
}

- (void)getMyPhotoURLs
{
    if ([FlickrKit sharedFlickrKit].isAuthorized) {
        
        self.myPhotostreamOp = [[FlickrKit sharedFlickrKit] call:@"flickr.photos.search" args:@{@"user_id": [FlickrKit sharedFlickrKit].userID, @"per_page": @"15"} maxCacheAge:FKDUMaxAgeNeverCache completion:^(NSDictionary<NSString *,id> * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response) {
                    //self.myPhotoURLs = [NSMutableArray array];
                    self.photoURLs = [NSMutableArray array];
                    
                    for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                        NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
                        [self.photoURLs addObject:url];
                    }
                    
                    //                    PBPhotosViewController *photosView = [[PBPhotosViewController alloc] initWithURLArray:_myPhotoURLs];
                    //                    [self.navigationController pushViewController:photosView animated:YES];
                    // segue to
//                    [self performSegueWithIdentifier:@"SegueToMyPhotos" sender:self];
                    
                } else {
//                    [self showErrorAlertWithMessage:error];
                }
            });
        }];
    } else {
//        [self showLoginError];
    }
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
