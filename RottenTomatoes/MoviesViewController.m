//
//  MoviewViewController.m
//  RottenTomatoes
//
//  Created by GD Huang on 6/12/15.
//  Copyright (c) 2015 gdhuang. All rights reserved.
//

#import "MoviesViewController.h"
#import "MoviesTableViewCell.h"
#import "MovieDetailsViewController.h"
#import "MBProgressHUD.h"
#import <UIImageView+AFNetworking.h>


@interface MoviesViewController ()

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    [self setupRefreshControl];
    [self updateMovies];
}

- (void) setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void) setupRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refreshTableView:)
             forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull To Refresh"];
    self.refreshControl = refreshControl;
    [self.tableView insertSubview:self.refreshControl atIndex:0];

}

- (void)refreshTableView:(id)sender {
    [self updateMovies];
}

- (void) updateMovies {
    NSString *rottenTomatoesURLString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dagqdghwaq3e3mxyrp7kmmj5";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:rottenTomatoesURLString]];
    
    
    if(self.refreshControl.isHidden) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if([data length] > 0 && connectionError == nil){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            self.movies = dict[@"movies"];
            
            [self.tableView reloadData];
        }else if ([data length] == 0 && connectionError == nil){
            //沒有資料，而且連線沒錯誤
        }else if(connectionError != nil){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.movies)
        return [self.movies count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"MovieCell";
    MoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MoviesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = [movie valueForKey:@"title"] ;
    cell.synopsisLabel.text = [movie valueForKey:@"synopsis"];
    
    NSURL *imageURL = [NSURL URLWithString:[movie valueForKeyPath:@"posters.thumbnail"]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageURL];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [cell.posterImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        if(request!=nil && response!=nil)
        {
            UIImageView *imageView = cell.posterImageView;
            
            imageView.hidden = NO;
            imageView.alpha = 0.0f;
            [UIView animateWithDuration:1.0 delay:0 options:0 animations:^{
                imageView.alpha = 1.0f;
            } completion:^(BOOL finished) {}];
        }
        cell.posterImageView.image = image;
        
    } failure:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    MovieDetailsViewController *movieDetailsViewController = segue.destinationViewController;
    movieDetailsViewController.movie = movie;
    
}


@end
