//
//  ViewController.m
//  CoffeFinder
//
//  Created by ALIREZA TABRIZI on 3/1/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "ViewController.h"
//part 1- Obtain User Location
//adding t0 plist = NSLocationAlwaysDescritpion...
// and adding Privacy - Location Usage Description
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
//step 2 import
#import "CoffeeShop.h"
//part 5
#import "DirectionsViewController.h"

@interface ViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property CLLocationManager *locationManager;
@property CLLocation *userLocation;
@property NSArray *cofeeShops;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

//part 4 starts
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cofeeShops.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CoffeeShop *coffeeshop = [self.cofeeShops objectAtIndex:indexPath.row];
    cell.textLabel.text = coffeeshop.mapItem.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f miles away", coffeeshop.distance];
    return cell;
}
//part 4 ends

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.userLocation = locations.firstObject;
    [self.locationManager stopUpdatingLocation];
    [self findCoffeePlaces:self.userLocation];
}
//part 1 ended
// part 2 - Determine Multile Locations

-(void) findCoffeePlaces: (CLLocation *)location{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc]init];
    request.naturalLanguageQuery = @"coffee";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.05, 0.05));
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        NSArray *mapItems = response.mapItems;
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for (int i=0; i<5; i++) {
            MKMapItem *mapItem = [mapItems objectAtIndex:i];
            CLLocationDistance distance = [mapItem.placemark.location distanceFromLocation:self.userLocation];
            float milesDistance = distance/1609.43;
            CoffeeShop *coffeeShop = [[CoffeeShop alloc]init];
            coffeeShop.mapItem = mapItem;
            coffeeShop.distance = milesDistance;
            [tempArray addObject:coffeeShop];
        }
        //Part 3
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:true];
        NSArray *sortedArray = [tempArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        self.cofeeShops = [NSArray arrayWithArray:sortedArray];
        for (CoffeeShop *cofeeshop in self.cofeeShops) {
            NSLog(@"%f", cofeeshop.distance);
        }
        [self.tableView reloadData];
    }];
}
//part 2 ends

//part 5 begins
// create the new destViewController, made segue, .h .m files, and identifier
//make a view coonect to both files... now time to create a segue function

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //same as [segue destinationViewController]
    DirectionsViewController *dvc = segue.destinationViewController;
    dvc.coffeeShop = [self.cofeeShops objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    dvc.userLocation = self.userLocation;
}

// part 5 ends

@end
