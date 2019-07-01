//
//	CoreLocationSource.m
//	ControlPlaneX
//
//	Created by David Jennes on 03/09/11.
//	Copyright 2011. All rights reserved.
//
//  Code rework and improvements by Vladimir Beloborodov (VladimirTechMan) on 1 September 2013.
//
//  IMPORTANT: This code is intended to be compiled for the ARC mode
//

#import "CoreLocationSource.h"
#import "DSLogger.h"


@implementation CLLocation (CustomExtensions)

- (id)initWithText:(NSString *)text {
    NSArray *comp = [text componentsSeparatedByString:@","];
	if ([comp count] != 2) {
		return nil;
    }
	return [self initWithLatitude:[comp[0] doubleValue] longitude:[comp[1] doubleValue]];
}

- (NSString *)convertToText {
	return [NSString stringWithFormat:@"%f, %f", self.coordinate.latitude, self.coordinate.longitude];
}

@end


@implementation CoreLocationSource

- (id)init {
    self = [super initWithNibNamed:@"CoreLocationRule"];
    if (!self) {
        return nil;
    }
    
	// for custom panel
	self.address = @"";
	self.coordinates = @"0.0, 0.0";

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    locationManager.distanceFilter = 500; // meters

    geocoder = [[CLGeocoder alloc] init];
    
    [locationManager requestLocation];

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    
    selectedRuleAnn = [[MKPointAnnotation alloc] init];
    [self.mapView addAnnotation:selectedRuleAnn];
    
    MKCoordinateRegion theRegion = self.mapView.region;
    theRegion.span.longitudeDelta = .01;
    theRegion.span.latitudeDelta = .01;
    [self.mapView setRegion:theRegion animated:NO];

}

- (NSString *)description {
    return NSLocalizedString(@"Create rules based on your current location using OS X's Core Location framework.", @"");
}

- (void)dealloc {
    [self stop];
}

- (void)start {
	if (self.running) {
		return;
    }
    
    [locationManager startUpdatingLocation];
	self.running = YES;
}

- (void)stop {
	if (!self.running) {
		return;
    }
    
    [locationManager stopUpdatingLocation];
	self.running = NO;
}

- (NSMutableDictionary *)readFromPanel {
	NSMutableDictionary *dict = [super readFromPanel];
	
	// store values
	dict[@"parameter"] = self.coordinates;
	if (!dict[@"description"]) {
		dict[@"description"] = self.address;
    }
	
	return dict;
}

- (void)writeToPanel:(NSDictionary *)dict usingType:(NSString *)type {
	[super writeToPanel: dict usingType: type];
	
	// do we already have settings?
	if (dict[@"parameter"]) {
		selectedRule = [[CLLocation alloc] initWithText:dict[@"parameter"]];
    }
	else {
		selectedRule = [locationManager location];
    }
	
	// get corresponding address
    [self geocodeLocation:selectedRule toAddress:nil];
	
	// show values
    self.coordinates = [selectedRule convertToText];
    
    [self updateMap];
}

- (NSString *)name {
	return @"CoreLocation";
}

- (BOOL)doesRuleMatch:(NSDictionary *)rule {
    
    if (current) {
        // get coordinates of rule
        CLLocation *ruleLocation = [[CLLocation alloc] initWithText:rule[@"parameter"]];
        if (ruleLocation) {
            // match if distance is smaller than accuracy
            return ([ruleLocation distanceFromLocation:current] <= current.horizontalAccuracy);
        }
    } else {
        [locationManager requestLocation];
    }
    
    return NO;
}

- (IBAction)showCoreLocation:(id)sender {
	selectedRule = [locationManager location];
    [self geocodeLocation:selectedRule toAddress:nil];
	
	// show values
    self.coordinates = [selectedRule convertToText];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(current.coordinate.latitude, current.coordinate.longitude) animated:YES];
}

#pragma mark -
#pragma mark UI Validation

- (BOOL)validateAddress:(inout NSString **)newValue error:(out NSError **)outError {

    [geocoder geocodeAddressString:*newValue completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            CLPlacemark* placemark = placemarks[0];
            CLLocation *loc = [placemark location];
            
            self->selectedRule = loc;
            self.coordinates = [loc convertToText];
            [self updateMap];
        }
    }];
    
    return YES;
}

- (BOOL)validateCoordinates:(inout NSString **)newValue error:(out NSError **)outError {
	// check coordinates
	CLLocation *loc = [[CLLocation alloc] initWithText:*newValue];
	if (!loc) {
        return NO;
    }
    
    selectedRule = loc;
    
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            CLPlacemark* placemark = [placemarks objectAtIndex:0];
            self.address = [placemark thoroughfare];
            
            self.coordinates = [self->selectedRule convertToText];
            [self updateMap];
        }
    }];

	return YES;
}

#pragma mark -
#pragma mark CoreLocation callbacks

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    if (newLocation != nil) {
        
        current = [newLocation copy];
        CLLocationAccuracy acc = current.horizontalAccuracy;
#ifdef DEBUG_MODE
        CLLocationDegrees lat = current.coordinate.latitude;
        CLLocationDegrees lon = current.coordinate.longitude;
        DSLog(@"New location: (%f, %f) with accuracy %f", lat, lon, acc);
#endif
        self.accuracy = [NSString stringWithFormat:@"%d m", (int) acc];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DSLog(@"Location manager failed with error: %@", [error localizedDescription]);

    switch (error.code) {
        case kCLErrorDenied:
            DSLog(@"Core Location denied!");
            [self stop];
            break;

        default:
            break;
    }
}

#pragma mark MapView delegate

- (void)mapViewDidChangeVisibleRegion:(MKMapView *)mapView
{
    self->selectedRule = [[CLLocation alloc] initWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
    self.coordinates = [self->selectedRule convertToText];
    [self geocodeLocation:self->selectedRule toAddress:nil];
    self->selectedRuleAnn.coordinate = self->selectedRule.coordinate;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
//    if ([annotation isKindOfClass:[MyCustomAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView*    pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"SelectedRulePinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"SelectedRulePinAnnotationView"];
            pinView.pinTintColor = [MKPinAnnotationView purplePinColor];
//            pinView.animatesDrop = YES;
//            pinView.canShowCallout = YES;
            
            // If appropriate, customize the callout by adding accessory views (code not shown).
        }
        else
            pinView.annotation = annotation;
        
        return pinView;
    }
    
    return nil;
}

#pragma mark -
#pragma mark Helper functions

- (void)updateMap {
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(selectedRule.coordinate.latitude, selectedRule.coordinate.longitude)];
}


- (BOOL)geocodeLocation:(CLLocation *)location toAddress:(NSString **)addr {
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            CLPlacemark* placemark = [placemarks objectAtIndex:0];
            self.address = [placemark thoroughfare];
        }
    }];

	return YES;
}

- (NSString *)friendlyName {
    return NSLocalizedString(@"Current Location", @"");
}

@end
