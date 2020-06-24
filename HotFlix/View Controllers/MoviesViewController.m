//
//  MoviesViewController.m
//  HotFlix
//
//  Created by Mercy Bickell on 6/24/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

/**
 * A view controller for the main part of the HotFlix app.
 */
@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Use the MoviesViewController as the data source and delegate for the tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Make network call
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged]; //calls fetchMovies method every time user pulls down to refresh
    
    [self.tableView addSubview:self.refreshControl];
}

// Makes network call to fetch information on currently playing movies
- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
   
    // Allows reloads
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               // Prints out the resulting dataDictionary to terminal
               NSLog(@"%@", dataDictionary);
               
               self.movies = dataDictionary[@"results"];
               
               //iterate through the movies, print the titles
               for (NSDictionary *movie in self.movies){
                   NSLog(@"%@", movie[@"title"]);
               }
               
               // Reload the table view data since network calls can take
               // longer than the rest of the code
               [self.tableView reloadData];
               
           }
       }];
    [task resume];
}

// Creates a number of rows corresponding to the number of movie entries
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

// Configures each row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Creates an instance of MovieCell(UITableViewCell) and uses cells with identifier MovieCell
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    // Associates right movie with the right row
    NSDictionary *movie = self.movies[indexPath.row];
    
    // Assigns the title and overview for each movie to that movie's cell
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"]; //pulls from the API
    
    // Default prefix for the poster image URLS
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    // NSURL is basically a string that check to see if it's a valid URL
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    // Prevent any possible flickering effects by clearing out previous image
    cell.posterView.image = nil;
    
    // Assign the image from the posterURL to the posterView for each cell
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
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
