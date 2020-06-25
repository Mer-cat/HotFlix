//
//  DetailsViewController.h
//  HotFlix
//
//  Created by Mercy Bickell on 6/24/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) NSDictionary *movie;  // Gives the Details view access to a movie property

@end

NS_ASSUME_NONNULL_END
