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

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
