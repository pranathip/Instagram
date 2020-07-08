//
//  EditProfileViewController.m
//  Instagram
//
//  Created by Pranathi Peri on 7/7/20.
//  Copyright © 2020 Pranathi Peri. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Post.h"
@import Parse;

@interface EditProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profilePicView.layer.cornerRadius = 50;
    PFUser *currentUser = [PFUser currentUser];
    self.userNameTextView.text = currentUser.username;
    if ([currentUser objectForKey:@"profilePicture"]) {
        self.profilePicView.file = [currentUser objectForKey:@"profilePicture"];
        [self.profilePicView loadInBackground];
    }
    if ([currentUser objectForKey:@"name"]) {
        self.nameTextView.text = [currentUser objectForKey:@"name"];
    }
    if ([currentUser objectForKey:@"bio"]) {
        self.bioTextView.text = [currentUser objectForKey:@"bio"];
    }
    // Do any additional setup after loading the view.
}
- (IBAction)changeProfileButtonTapped:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    //UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.profilePicView.image = originalImage;
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"profilePicture"] = [Post getPFFileFromImage:[self resizeImage:self.profilePicView.image withSize:CGSizeMake(100, 100)]];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Profile picture updated");
        } else {
            NSLog(@"Error updating profile picture: %@", error.localizedDescription);
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonTapped:(id)sender {
    //[self performSegueWithIdentifier:@"backToProfileSegue" sender:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
