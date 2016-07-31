//
//  AddViewController.m
//  WeatherApp
//
//  Created by Teodora on 7/29/16.
//  Copyright © 2016 Teodora. All rights reserved.
//

#import "AddViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"

@interface AddViewController ()



@end

@implementation AddViewController

#pragma mark - Properties

-(DataManager *) dataManager {
    return [DataManager sharedInstance];
}

- (void)saveCustomObject:(NSMutableArray *)object key:(NSString *)key {
   
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (NSMutableArray *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

#pragma mark - View Lifecycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
}





#pragma mark - Actions


- (IBAction)saveButtonTapped:(UIButton *)sender {
    
    [self findCoordinates:self.cityNameTextField.text];
    
}




-(IBAction)doneButtonTapped {

    NSLog(@"%@", self.cityNameTextField.text);
    
  
    City *city = [[City alloc]initWithName:self.cityNameTextField.text andLongitude:self.longitude andLatitude:self.latitude];
    NSLog(@"%@, %f, %f", city.name, city.latitude, city.longitude);
    [self.dataManager.itemsArray addObject: city];
    [self.cityNameTextField resignFirstResponder];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSArray *array= [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:LIST_OF_CITIES]];
     NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
    [newArray addObject:city];
    
    [self saveCustomObject:newArray key:LIST_OF_CITIES];

    
}

-(void)findCoordinates:(NSString *)name {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:name completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error);
        } else {
            
            CLPlacemark *placemark = [placemarks lastObject];
            
            NSLog(@"%@", placemark.location.description);
            CLLocationDegrees  latitude = (double) placemark.location.coordinate.latitude;
            self.latitude = latitude;
            NSLog(@"%f", latitude);
            CLLocationDegrees  longitude = (double) placemark.location.coordinate.longitude;
            NSLog(@"%f", longitude);
            self.longitude = longitude;
            
        }
    }];
    
}


@end


