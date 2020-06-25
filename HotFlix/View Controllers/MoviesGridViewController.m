//
//  MoviesGridViewController.m
//  HotFlix
//
//  Created by Mercy Bickell on 6/25/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *movies;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchMovies];
}

// Makes network call to fetch information on currently playing movies
- (void)fetchMovies {
    
    // Fetch movie data
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
   
    // Allows reloads
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // This section of the code runs once the network request returns.
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);

           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               // Prints out the resulting dataDictionary to terminal
               NSLog(@"%@", dataDictionary);
               
               self.movies = dataDictionary[@"results"];
               
               [self.collectionView reloadData];
           }
        
       }];
    [task resume];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    // Associates right movie with the right item in the collection view
    NSDictionary *movie = self.movies[indexPath.item];

   NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
   NSString *posterURLString = movie[@"poster_path"];
   NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
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
