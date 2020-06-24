//
//  MoviesViewController.m
//  HotFlix
//
//  Created by Mercy Bickell on 6/24/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h" //allows us to use MovieCell as object in this file
#import "UIImageView+AFNetworking.h" // allows us to import images for the posters

//this class implements the protocols inside the arrows -> needs certain functions implemented
@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies; //like a private field in Java with auto getter and setter methods. Strong keyword will preserve values

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self; //points back at itself
    self.tableView.delegate = self;
    
    //make network call
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"]; //could simply change the url to be whatever you wanna get, doesn't need to be now playing
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0]; //we want to always be able to see it reload
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else { //API gives something back
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               //prints out the resulting dataDictionary to terminal
               NSLog(@"%@", dataDictionary); //%@ specifies an object
               
               self.movies = dataDictionary[@"results"]; //give the key as results
               
               //iterate through the movies, print the titles
               for (NSDictionary *movie in self.movies){
                   NSLog(@"%@", movie[@"title"]);
               }
               
               //Reload the table view data
               [self.tableView reloadData];
               
           } //lines inside block are called once network call is finished
       }];
    [task resume];
}

//Creates a row for each movie
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count; //number of movie entries
}

//Configures each row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"]; //creates an instance of MovieCell (UITableViewCell) and uses cells with identifier MovieCell
    
    NSDictionary *movie = self.movies[indexPath.row]; //associates right movie with the right row
    
    //assigns the title and overview for each movie to that movie's cell
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"]; //pulls from the API
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500"; //default prefix for the poster image URLS
    NSString *posterURLString = movie[@"poster_path"]; //backdrop is the bigger one
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString]; //get full URL by appending poster path to  URL
    //NSURL is basically a string that check to see if it's a valid URL
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil; //prevent any possible flickering effects by clearing out previous image
    [cell.posterView setImageWithURL:posterURL]; //could also use a different method to specify a default image
    
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
