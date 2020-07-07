//
//  FeedViewController.m
//  Instagram
//
//  Created by Pranathi Peri on 7/6/20.
//  Copyright © 2020 Pranathi Peri. All rights reserved.
//

#import "FeedViewController.h"
#import "PostCell.h"
#import "Post.h"
#import <Parse/Parse.h>

@interface FeedViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self fetchPosts];
    
    //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fetchPosts) userInfo:nil repeats:true];

}

- (void) fetchPosts {
    // construct PFQuery
      PFQuery *postQuery = [Post query];
      [postQuery orderByDescending:@"createdAt"];
      [postQuery includeKey:@"author"];
      postQuery.limit = 20;

      // fetch data asynchronously
      [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
          if (posts) {
              // do something with the data fetched
              self.posts = [NSMutableArray arrayWithArray:posts];
              [self.tableView reloadData];
              //NSLog(@"%lu", posts.count);
          }
          else {
              // handle error
              NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
          }
          [self.refreshControl endRefreshing];
      }];
}

- (IBAction)logOutButtonTapped:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        [self performSegueWithIdentifier:@"logOutSegue" sender:nil];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}*/


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];
    PFUser *currentUser = [PFUser currentUser];
    cell.post = post;
    cell.usernameLabel.text = currentUser.username;
    cell.likesCountLabel.text = [NSString stringWithFormat: @"%@", post.likeCount];
    cell.captionLabel.text = post.caption;
    cell.postImageView.file = post[@"image"];
    [cell.postImageView loadInBackground];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}



@end
