//
//  MyPhotosViewController.m
//  Photo Briefer
//
//  Created by yonglim on 3/4/17.
//  Copyright © 2017 u023. All rights reserved.
//

#import "MyPhotosViewController.h"

@interface MyPhotosViewController ()

@end

@implementation MyPhotosViewController
@synthesize myPhotoURLs = _myPhotoURLs;

- (id)initWithURLArray:(NSArray *)urlArray
{
    self = [super init];
    if (self) {
        self.myPhotoURLs = urlArray;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (NSURL *url in self.myPhotoURLs) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            [self addImageToView:image];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
