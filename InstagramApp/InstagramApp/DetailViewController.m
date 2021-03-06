//
//  DetailViewController.m
//  InstagramApp
//
//  Created by Rohan Aurora on 6/14/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotoController.h"

@interface DetailViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:self.imageView];


    [PhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    CGSize size = self.view.bounds.size;
    CGSize imageSize = CGSizeMake(size.width, size.width);
    
    self.imageView.frame = CGRectMake(0.0, (size.height - imageSize.height) /2.0, imageSize.width, imageSize.height);
}
    
-(void) close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
