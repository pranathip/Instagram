//
//  ProfileViewController.m
//  Instagram
//
//  Created by Pranathi Peri on 7/7/20.
//  Copyright © 2020 Pranathi Peri. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    NSLog(@"called");
    [super viewDidLoad];
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


@end
