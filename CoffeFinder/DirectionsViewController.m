//
//  DirectionsViewController.m
//  CoffeFinder
//
//  Created by ALIREZA TABRIZI on 3/4/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

// part 5
#import "DirectionsViewController.h"

@interface DirectionsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *directionTextView;

@end

@implementation DirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.coffeeShop.mapItem.name;
    [self getDirectionFrom: self.userLocation.coordinate withDestinatin:self.coffeeShop.mapItem.placemark.location.coordinate];
}

-(void) getDirectionFrom:(CLLocationCoordinate2D)sourceCoordinate withDestinatin:(CLLocationCoordinate2D)destinationCoordinate{
    
    //create a source place mark and then sets the mark on the map
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc]initWithCoordinate:sourceCoordinate addressDictionary:nil];
    MKMapItem *sourceMapItem = [[MKMapItem alloc]initWithPlacemark:sourcePlacemark];
    
    //create a destination place mark and then sets the mark on the map
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc]initWithCoordinate:destinationCoordinate addressDictionary:nil];
    MKMapItem *destinationMapItem = [[MKMapItem alloc]initWithPlacemark:destinationPlacemark];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:sourceMapItem];
    [request setDestination:destinationMapItem];
    //request.source = sourceMapItem;
    //request.destination = destinationMapItem;
    [request setTransportType:MKDirectionsTransportTypeWalking];
    request.requestsAlternateRoutes = NO;
   
    //redo this whole portion... lots of looking up happened
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        MKRoute *route = response.routes.lastObject;
       
        NSString * allSteps = [[NSString alloc]init];
        
        for (int i = 0; i<route.steps.count; i++) {
            MKRouteStep *step = [route.steps objectAtIndex:i];
            NSString *newStepString = step.instructions;
            
            allSteps = [allSteps stringByAppendingString:[NSString stringWithFormat:@"%@ \n", newStepString]];
        }
        self.directionTextView.text = allSteps;
    }];
}

@end
