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
#import "Movie.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.movie.posterUrl != nil) {
        [self.posterView setImageWithURL:self.movie.posterUrl];
    }
    
    // Check for null backdrop
    if (self.movie.backdropUrl != nil) {
        [self.backdropView setImageWithURL:self.movie.backdropUrl];
    }
    
    // Retrieve movie title and synopsis and put in appropriate spots
    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.synopsis;
    // Retrieve movie rating
    CGFloat ratingValue =  [self.movie.voteAverage floatValue];
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
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", self.movie.movieID];
    
    // Passes the URL for this movie to the video player
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.trailerURL = urlString;
    
}


@end
