//
//  MoviesGridViewController.m
//  HotFlix
//
//  Created by Mercy Bickell on 6/25/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Movie.h"
#import "MovieAPIManager.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *movies;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchMovies];
    
    // Setup for layout of collection view
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat postersPerLine = 2;
    
    // Width of each movie posters that accounts for space between posters
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth , itemHeight);
    
}

// Makes network call to fetch information on currently playing movies
- (void)fetchMovies {
    MovieAPIManager *manager = [MovieAPIManager new];
    [manager fetchNowPlaying:^(NSMutableArray *movies, NSError *error) {
        if(movies){
            self.movies = movies;
            [self.collectionView reloadData];
        }
    }];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    // Associates right movie with the right item in the collection view
    Movie *movie = self.movies[indexPath.item];
    
    // Prevent any possible flickering effects by clearing out previous image
    cell.posterView.image = nil;
    
    // Assign the image from the posterURL to the posterView for each cell
    if (movie.posterUrl != nil){
        [cell.posterView setImageWithURL:movie.posterUrl];
    }
    
    return cell;
}





 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     UICollectionViewCell *tappedCell = sender;
     NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
     
     // Passes in the movie associated with the cell to the next view controller
     Movie *movie = self.movies[indexPath.row];
     DetailsViewController *detailsViewController = [segue destinationViewController];
     detailsViewController.movie = movie;
     
 }
 



@end
