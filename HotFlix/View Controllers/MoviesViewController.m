//
//  MoviesViewController.m
//  HotFlix
//
//  Created by Mercy Bickell on 6/24/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "MoviesViewController.h"

@interface MoviesViewController ()

@property (nonatomic, strong) NSArray *movies; //like a private field in Java with auto getter and setter methods. Strong keyword will preserve values

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

               NSLog(@"%@", dataDictionary); //%@ specifies an object
               // TODO: Get the array of movies
               self.movies = dataDictionary[@"results"]; //give the key as results
               
               //iterate through the movies, print the titles
               for (NSDictionary *movie in self.movies){
                   NSLog(@"%@", movie[@"title"]);
               }
               
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           } //lines inside block are called once network call is finished
       }];
    [task resume];
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
