//
//  PBPhotosViewController.m
//  Photo Briefer
//
//  Created by yonglim on 2/24/17.
//  Copyright © 2017 u023. All rights reserved.
//

#import "FlickrKit.h"

#import "PBPhotosViewController.h"

@interface PBPhotosViewController ()
@property (nonatomic, retain) FKFlickrNetworkOperation *todaysInterestingOp;
@property (nonatomic, retain) NSMutableArray *photoURLs;
@end

@implementation PBPhotosViewController
//@synthesize photoURLs = _photoURLs;

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
    
    [self getPhotoURLs];
    
    for (NSURL *url in self.photoURLs) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            [self addImageToView:image];
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.todaysInterestingOp cancel];
}

- (void) dealloc
{
    [self.todaysInterestingOp cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getPhotoURLs
{
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    interesting.per_page = @"15";
    self.todaysInterestingOp = [[FlickrKit sharedFlickrKit] call:interesting completion:^(NSDictionary<NSString *,id> * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response) {
                self.photoURLs = [NSMutableArray array];
                for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"]) {
                    NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
                    [self.photoURLs addObject:url];
                }
                
                //TODO add PBPhotosViewController to display these photo here.
                // When I do this route, I can't get the imageScrollView working somehow :(
                //                PBPhotosViewController *photosView = [[PBPhotosViewController alloc] initWithURLArray:photoURLs];
                //                [self.navigationController pushViewController:photosView animated:YES];
//                [self performSegueWithIdentifier:@"SegueToPhotos" sender:self];
                
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
