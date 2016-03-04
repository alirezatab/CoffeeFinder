//
//  DirectionsViewController.h
//  CoffeFinder
//
//  Created by ALIREZA TABRIZI on 3/4/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

//part 5
#import <UIKit/UIKit.h>
#import "CoffeeShop.h"
#import <CoreLocation/CoreLocation.h>

@interface DirectionsViewController : UIViewController

@property CoffeeShop *coffeeShop;
@property CLLocation *userLocation;

@end
