//
//  VehicalMapViewController.h
//  MyTeaxiExercise
//
//  Created by aathavale on 10/28/17.
//  Copyright © 2017 MyTaxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyTeaxiExercise-Swift.h"

@interface VehicalMapViewController : UIViewController <MKMapViewDelegate, ServiceLayerDelegate> {
    IBOutlet MKMapView *mapView;
    VehicalModel *model;
    Vehical *selectedVehical;
    ServiceLayer *serviceLayer;
}

@end
