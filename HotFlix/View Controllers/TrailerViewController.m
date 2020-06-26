//
//  TrailerViewController.m
//  HotFlix
//
//  Created by Mercy Bickell on 6/26/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "TrailerViewController.h"
#import "WebKit/WebKit.h"

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *trailerWebView;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (nonatomic, strong) NSArray *video;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchTrailer];
}

- (IBAction)dismissTrailerView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)fetchTrailer {
    
    // First fetches the key for the particular movie being looked at
    NSURL *url = [NSURL URLWithString:self.trailerURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.video = dataDictionary[@"results"];
            
            NSString *baseURLString = @"https://www.youtube.com/watch?v=";
            NSString *trailerPath = self.video[0][@"key"];
            NSString *fullTrailerURLString = [baseURLString stringByAppendingString:trailerPath];
            
            NSURL *fullTrailerURL = [NSURL URLWithString:fullTrailerURLString];
            
            // Fetch the trailer video
            NSURLRequest *request = [NSURLRequest requestWithURL:fullTrailerURL
                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
            timeoutInterval:10.0];
            
            [self.trailerWebView loadRequest:request];
        }
    }];
    [task resume];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}
*/

@end
