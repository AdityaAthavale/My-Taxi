//
//  VehicalMapViewController.m
//  MyTeaxiExercise
//
//  Created by aathavale on 10/28/17.
//  Copyright © 2017 MyTaxi. All rights reserved.
//

#import "VehicalMapViewController.h"
#import "MyTaxiAnnotation.h"


@interface VehicalMapViewController ()

@end

@implementation VehicalMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [VehicalModel sharedInstance];
    serviceLayer = [ServiceLayer sharedInstance];
    [mapView setDelegate:self];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    MKCoordinateRegion region = MKCoordinateRegionMake([model.locationCenter coordinate], MKCoordinateSpanMake(0.1, 0.1));
    [mapView setRegion: region animated: YES];
    [self dropPinsForVehicals];

    //In case this view is loaded before Service call returns this will update the data.
    [serviceLayer setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"ShowVehicalDetails"]) {
        VehicalDetailsViewController *details = (VehicalDetailsViewController *)segue.destinationViewController;

        if (details) {
            details.vehical = selectedVehical;
        }
    }
}

- (void)dropPinsForVehicals {

    //Remove previous annotations.
    for (MyTaxiAnnotation *annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    //Add new annotations.
    for (Vehical *vehical in model.vehicals) {
        MyTaxiAnnotation *annotation = [[MyTaxiAnnotation alloc] init];
        [annotation setCoordinate:vehical.location.coordinate];
        [annotation setTitle:vehical.type];
        [annotation setSubtitle:vehical.state];
        [annotation setVehical:vehical];
        [mapView addAnnotation:annotation];
    }
}

#pragma mark:  Map View
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"loc"];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    //Load details for selected Annotations.
    selectedVehical = [(MyTaxiAnnotation *)view.annotation vehical];
    [self performSegueWithIdentifier:@"ShowVehicalDetails" sender:self];
}


#pragma - mark service layer delegate
-(void) receivedData {
    [self dropPinsForVehicals];
}

-(void) receivedError:(NSError *)error response:(NSURLResponse *)response {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Something went wrong." preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction: [UIAlertAction actionWithTitle:@"Retry" style: UIAlertActionStyleDefault handler:^
        (UIAlertAction *action) {
            [serviceLayer getVehicalData];
    }]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
