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
    
    // Set the other properties from the dictionary
    
    return self;
}

@end
