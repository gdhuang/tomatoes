//
//  MovieDetailsViewController.m
//  RottenTomatoes
//
//  Created by GD Huang on 6/14/15.
//  Copyright (c) 2015 gdhuang. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import <UIImageView+AFNetworking.h>


@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = [self.movie valueForKey:@"title"];
    self.synopsisLabel.text = [self.movie valueForKey:@"synopsis"];
    
    NSURL *imageURL = [NSURL URLWithString:[self.movie valueForKeyPath:@"posters.detailed"]];
    [self.imageView setImageWithURL:imageURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
