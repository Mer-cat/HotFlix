//
//  Movie.m
//  HotFlix
//
//  Created by Mercy Bickell on 7/1/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.title = dictionary[@"title"];
    self.synopsis = dictionary[@"overview"];
    self.voteAverage = dictionary[@"vote_average"];
    self.movieID = dictionary[@"id"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = dictionary[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    self.posterUrl = [NSURL URLWithString:fullPosterURLString];
    
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    self.backdropUrl = [NSURL URLWithString:fullBackdropURLString];

    return self;
}

+ (NSMutableArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    return movies;
}

@end
