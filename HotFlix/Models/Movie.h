//
//  Movie.h
//  HotFlix
//
//  Created by Mercy Bickell on 7/1/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *posterUrl;
@property (nonatomic, strong) NSURL *backdropUrl;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *movieID;
@property (nonatomic, strong) NSString *voteAverage;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
