//
//  MovieAPIManager.h
//  HotFlix
//
//  Created by Mercy Bickell on 7/1/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieAPIManager : NSObject

- (id)init;
- (void)fetchNowPlaying:(void(^)(NSMutableArray *movies, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
