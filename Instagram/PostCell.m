//
//  PostCell.m
//  Instagram
//
//  Created by Pranathi Peri on 7/6/20.
//  Copyright © 2020 Pranathi Peri. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didLike:(id)sender {
    if (self.post.liked == YES) {
        self.post.liked = NO;
        self.post.likeCount = [NSNumber numberWithInt:[self.post.likeCount intValue] - 1];
        self.likeButton.selected = NO;
        self.likeButton.tintColor = [UIColor blackColor];
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Post updated");
            } else {
                NSLog(@"Error updating post: %@", error.localizedDescription);
            }
        }];
        [self refreshCell];
    } else {
        self.post.liked = YES;
        self.post.likeCount = [NSNumber numberWithInt:[self.post.likeCount intValue] + 1];
        self.likeButton.selected = YES;
        self.likeButton.tintColor = [UIColor redColor];
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Post updated");
            } else {
                NSLog(@"Error updating post: %@", error.localizedDescription);
            }
        }];
        [self refreshCell];
    }
}

- (void) refreshCell {
    self.likesCountLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
}

@end
