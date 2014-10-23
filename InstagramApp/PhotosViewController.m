//
//  PhotosViewController.m
//  InstagramApp
//
//  Created by Rohan Aurora on 6/14/14.
//  Copyright (c) 2014 Rohan Aurora. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import <SimpleAuth/SimpleAuth.h>
#import "DetailViewController.h"

@interface PhotosViewController ()

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSArray *photos;

@end

@implementation PhotosViewController

-(instancetype) init {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;

    return (self = [super initWithCollectionViewLayout:layout]);
}


-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PayPal Mobile Take Home Exercise";
    
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    if (self.accessToken == nil) {
        
        [SimpleAuth authorize:@"instagram" options:@{@"scope":@[@"likes"]} completion:^(NSDictionary *responseObject, NSError *error) {
            
            self.accessToken = responseObject[@"credentials"][@"token"];
            
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
            
            [self refresh];
        }];
    } else {
        [self refresh];
    }
}
    
-(void) refresh {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *myString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/mountains/media/recent?access_token=%@", self.accessToken];
    
    NSURL *urlString = [NSURL URLWithString:myString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlString];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *myData = [[NSData alloc] initWithContentsOfURL:location];
        
        NSDictionary *myJSON = [NSJSONSerialization JSONObjectWithData:myData options:kNilOptions error:nil];
        
        self.photos = [myJSON valueForKeyPath:@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    
    [task resume];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return  self.photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.photo = self.photos[indexPath.row];
    return  cell;
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *photo = self.photos[indexPath.row];
    DetailViewController *viewController = [[DetailViewController alloc] init];
    
    viewController.photo = photo;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

@end






