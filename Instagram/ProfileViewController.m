//
//  ProfileViewController.m
//  Instagram
//
//  Created by Pranathi Peri on 7/7/20.
//  Copyright © 2020 Pranathi Peri. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import "Post.h"
#import "ProfilePostCell.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *userPosts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    NSLog(@"called");
    [super viewDidLoad];
    self.collectionsView.dataSource = self;
    self.collectionsView.delegate = self;
    
    self.profilePicView.layer.cornerRadius = 50;
    self.editProfileButton.layer.borderWidth = 0.5;
    self.editProfileButton.layer.cornerRadius = 2;
    self.editProfileButton.layer.borderColor = UIColor.darkGrayColor.CGColor;
    
    PFUser *currentUser = [PFUser currentUser];
    self.nameLabel.text = [currentUser objectForKey:@"name"];
    self.bioLabel.text = [currentUser objectForKey:@"bio"];
    self.profilePicView.file = [currentUser objectForKey:@"profilePicture"];
    [self.profilePicView loadInBackground];
    // Do any additional setup after loading the view.
    [self fetchUserPosts];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionsView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    CGFloat postersPerLine = 3;
    //CGFloat itemWidth = (self.collectionsView.frame.size.width - (layout.minimumInteritemSpacing + 28)* (postersPerLine - 1)) / postersPerLine;
    CGFloat itemWidth = self.collectionsView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"called viewwillappear");
    self.profilePicView.layer.cornerRadius = 50;
    self.editProfileButton.layer.borderWidth = 0.5;
    self.editProfileButton.layer.cornerRadius = 2;
    self.editProfileButton.layer.borderColor = UIColor.darkGrayColor.CGColor;
    
    PFUser *currentUser = [PFUser currentUser];
    self.nameLabel.text = [currentUser objectForKey:@"name"];
    self.bioLabel.text = [currentUser objectForKey:@"bio"];
    self.profilePicView.file = [currentUser objectForKey:@"profilePicture"];
    [self.profilePicView loadInBackground];
}

- (void) fetchUserPosts {
    // construct PFQuery
      PFQuery *postQuery = [Post query];
      [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
      [postQuery orderByDescending:@"createdAt"];
      [postQuery includeKey:@"author"];
      postQuery.limit = 20;

      // fetch data asynchronously
      [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
          if (posts) {
              // do something with the data fetched
              self.userPosts = [NSMutableArray arrayWithArray:posts];
              [self.collectionsView reloadData];
              //NSLog(@"%lu", posts.count);
          }
          else {
              // handle error
              NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
          }
      }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navigationController = [segue destinationViewController];
    EditProfileViewController *editProfileController = (EditProfileViewController*)navigationController.topViewController;
    editProfileController.delegate = self;
}
 */


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfilePostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profilePostCell" forIndexPath:indexPath];
    Post *post = self.userPosts[indexPath.row];
    cell.postImage.file = post[@"image"];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPosts.count;
}

@end
