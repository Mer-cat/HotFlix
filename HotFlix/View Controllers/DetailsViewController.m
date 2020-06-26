//
//  DetailsViewController.m
//  HotFlix
//
//  Created by Mercy Bickell on 6/24/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Retrieves the URL for the movie poster and sets it to the poster view
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    
    // Check for null poster
    if([[NSNull null] isEqual:posterURLString]) {
        NSLog(@"Null poster");
    }
    else {
        NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
        NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        [self.posterView setImageWithURL:posterURL];
    }
    
    // Retrieves the URL for the movie backdrop and sets it to the backdrop view
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    
    // Check for null backdrop
    if([[NSNull null] isEqual:backdropURLString]) {
        NSLog(@"Null backdrop");
    }
    else {
        NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
        [self.backdropView setImageWithURL:backdropURL];
    }
    
    // Retrieve movie title and synopsis and put in appropriate spots
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    
    // Retrieve movie rating
    CGFloat ratingValue =  [self.movie[@"vote_average"] floatValue];
    NSString *ratingText = [NSString stringWithFormat:@"Rating: %.1f / 10", ratingValue];
    self.ratingLabel.text = ratingText;
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
}

- (IBAction)onTap:(id)sender {
    [self performSegueWithIdentifier:@"trailerSegue" sender:nil];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", self.movie[@"id"]];
    
    // Passes the URL for this movie to the video player
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.trailerURL = urlString;
    
}


@end
