//
//  PBPhotosViewController.h
//  Photo Briefer
//
//  Created by yonglim on 2/24/17.
//  Copyright © 2017 u023. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBPhotosViewController : UIViewController

- (id)initWithURLArray:(NSMutableArray *)urlArray;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
//@property (nonatomic, retain) NSArray *photoURLs;

@end
