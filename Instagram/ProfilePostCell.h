//
//  ProfilePostCell.h
//  Instagram
//
//  Created by Pranathi Peri on 7/8/20.
//  Copyright © 2020 Pranathi Peri. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ProfilePostCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@end

NS_ASSUME_NONNULL_END
