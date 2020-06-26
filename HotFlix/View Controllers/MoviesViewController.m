//
//  MoviesViewController.m
//  HotFlix
//
//  Created by Mercy Bickell on 6/24/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"  // Allows us to pull in poster images directly from URL
#import "MBProgressHUD.h"


/**
 * A view controller for the main part of the HotFlix app.
 */
@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredMovies;


@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Use the MoviesViewController as the data source and delegate for the tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.searchBar.delegate = self;
    
    // Make network call
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Refreshes the movie list each time the user pulls down
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

// Makes network call to fetch information on currently playing movies
- (void)fetchMovies {
    
    // Show activity indicator on screen
    MBProgressHUD *activityIndicator = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    activityIndicator.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    // Allows things to go on in the background while the HUD is animating
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        // Fetch movie data
        NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
        
        // Allows reloads
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        // This section of the code runs once the network request returns.
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
                [self createNetworkAlert];
                
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                self.movies = dataDictionary[@"results"];
                self.filteredMovies = self.movies;
                
                // Reload the table view data since network calls can take
                // longer than the rest of the code
                [self.tableView reloadData];
            }
            
            // Stops the refreshing symbol once the movies have been refreshed
            [self.refreshControl endRefreshing];
            
            // Stops and hides the activity indicator when
            // the movies are done loading
            [activityIndicator hideAnimated:YES];
            
        }];
        [task resume];
    });
}

// Creates a number of rows corresponding to the number of movie entries
// or the number of entries matching search query
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

// Configures each movie cell with title, image, and synopsis
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Creates an instance of MovieCell(UITableViewCell) and uses cells with identifier MovieCell
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    // Associates right movie with the right row
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    
    // Assigns the title and overview for each movie to that movie's cell
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
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

// Filters movies shown based on search query
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if(searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.tableView reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

// Hides the search bar and clears it if user cancels
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.filteredMovies = self.movies;
    [self.tableView reloadData];
}

// Hides the search bar when search complete
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

// Creates a network alert on the screen
- (void)createNetworkAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot get movies"
                                                                   message:@"The internet connection appears to be offline."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // Create a Try Again action
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
        [self fetchMovies];  // Retry
    }];
    
    // Add the Try Again action to the alert controller
    [alert addAction:tryAgainAction];
    
    // Create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        // Simply dismisses the view
    }];
    
    // Add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // Show the alert
    [self presentViewController:alert animated:YES completion:^{
    }];
    
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    
    // Passes in the movie associated with the cell to the next view controller
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}


@end
