//
//  ViewController.m
//  YAACLocation
//
//  Created by Bsetecip10 on 09/12/14.
//  Copyright (c) 2014 gyana. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocation *location;

}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)maptype:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    istype = 0;
    [super viewDidLoad];
    [_mapView setHidden:YES];
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    location =[[CLLocation alloc]init];
}

- (IBAction)findCurrentLocation:(UIButton *)sender
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    locationManager.distanceFilter = 200.0f;
    
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    
    [_mapView setHidden:NO];
    [_mapView setRotateEnabled:YES];
    [_mapView setShowsBuildings:YES];
    [_mapView setMultipleTouchEnabled:YES];
    [_mapView setDelegate:self];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        _lat.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _longnitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
        
    [locationManager stopUpdatingLocation];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            _detail.text = [NSString stringWithFormat:@"%@ %@\n%@\n%@,\n%@,\n%@\n%@\n%@", placemark.locality, placemark.administrativeArea, placemark.country,placemark.postalCode,placemark.subLocality,placemark.subAdministrativeArea,placemark.accessibilityHint,placemark.country];
        } else {
            NSLog(@"complete");
        }
    } ];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [_lat.text intValue];
    zoomLocation.longitude= [_longnitude.text intValue];
 
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 5, 5);
    [mapView setRegion:viewRegion animated:YES];
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title =[[UIDevice currentDevice]systemName];
    point.subtitle =placemark.locality.capitalizedString;
    
    [mapView addAnnotation:point];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
