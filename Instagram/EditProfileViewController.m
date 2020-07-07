//
//  EditProfileViewController.m
//  Instagram
//
//  Created by Pranathi Peri on 7/7/20.
//  Copyright © 2020 Pranathi Peri. All rights reserved.
//

#import "EditProfileViewController.h"
@import Parse;

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profilePicView.layer.cornerRadius = 50;
    PFUser *currentUser = [PFUser currentUser];
    self.userNameTextView.text = currentUser.username;
    if ([currentUser objectForKey:@"name"]) {
        self.nameTextView.text = [currentUser objectForKey:@"name"];
    }
    if ([currentUser objectForKey:@"bio"]) {
        self.bioTextView.text = [currentUser objectForKey:@"bio"];
    }
    // Do any additional setup after loading the view.
}
- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didEditNameField:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"name"] = self.nameTextView.text;
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Name updated");
        } else {
            NSLog(@"Error updating name: %@", error.localizedDescription);
        }
    }];
}
- (IBAction)didEditUsernameField:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    currentUser.username = self.userNameTextView.text;
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"username updated");
        } else {
            NSLog(@"Error updating username: %@", error.localizedDescription);
        }
    }];
}
- (IBAction)didEditBioField:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"bio"] = self.bioTextView.text;
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Bio updated");
        } else {
            NSLog(@"Error updating bio: %@", error.localizedDescription);
        }
    }];
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
