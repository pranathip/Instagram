//
//  ComposePostViewController.m
//  Instagram
//
//  Created by Pranathi Peri on 7/6/20.
//  Copyright © 2020 Pranathi Peri. All rights reserved.
//

#import "ComposePostViewController.h"
#import "Post.h"
@import MBProgressHUD;

@interface ComposePostViewController () <UITextViewDelegate>

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.captionTextView.delegate = self;
    [self.captionTextView addSubview:self.placeholderLabel];
}
- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    
}
- (IBAction)postButtonTapped:(id)sender {
    NSLog(@"tapped");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Post postUserImage: [self resizeImage:self.postImageView.image withSize:CGSizeMake(170, 170)] withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError *_Nullable error) {
        if (error) {
            NSLog(@"Error posting: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully posted image!");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}
- (IBAction)imageTapped:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    //UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.postImageView.image = originalImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void) textViewDidChange:(UITextView *)theTextView
{
    if(![self.captionTextView hasText]) {
        NSLog(@"no text");
        [UIView animateWithDuration:0.15 animations:^{
            [self.captionTextView addSubview:self.placeholderLabel];
            self.placeholderLabel.alpha = 1.0;
        }];
    } else if ([[self.captionTextView subviews] containsObject:self.placeholderLabel]) {
        [UIView animateWithDuration:0.15 animations:^{
            self.placeholderLabel.alpha = 0.0;
            
    } completion:^(BOOL finished) {
        //[self.placeholderLabel removeFromSuperview];
    }];
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
