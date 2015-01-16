//
//  LocationTracker.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location All rights reserved.
//

#import "LocationTracker.h"
#import "WBSQLBuffer.h"
#import "WBDatabaseService.h"
#import "SWLOCATION.h"

#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define DistanceFilter 100.0f

NSString * const KNewLocationProducedNotification = @"KNewLocationProducedNotification";

@implementation LocationTracker

+ (CLLocationManager *)sharedLocationManager {
	static CLLocationManager *_locationManager;
	
	@synchronized(self) {
		if (_locationManager == nil) {
			_locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
		}
	}
	return _locationManager;
}

- (id)init {
	if (self==[super init]) {
        //Get the share model and also initialize myLocationArray
        self.shareModel = [LocationShareModel sharedModel];
        self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
	}
	return self;
}

-(void)applicationEnterBackground{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = DistanceFilter;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    //Use the BackgroundTaskManager to manage all the background Task
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
}

- (void) restartLocationUpdates
{
    NSLog(@"restartLocationUpdates");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = DistanceFilter;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}


- (void)startLocationTracking {
    NSLog(@"startLocationTracking");

	if ([CLLocationManager locationServicesEnabled] == NO) {
        NSLog(@"locationServicesEnabled false");
//		UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[servicesDisabledAlert show];
	} else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
        } else {
            NSLog(@"authorizationStatus authorized");
            CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            locationManager.distanceFilter = DistanceFilter;
            
            if(IS_OS_8_OR_LATER) {
              [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
        }
	}
}


- (void)stopLocationTracking {
    NSLog(@"stopLocationTracking");
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
	CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
	[locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"locationManager didUpdateLocations");
    
    for(int i=0;i<locations.count;i++){
        CLLocation * newLocation = [locations objectAtIndex:i];
//        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
//		
//        if (locationAge > 30.0)
//        {
//            continue;
//        }
		
        //Select only valid location and also location with good accuracy
        if(newLocation!=nil&&newLocation.horizontalAccuracy>0
           &&newLocation.horizontalAccuracy<2000
           &&(!(newLocation.coordinate.latitude==0.0&&newLocation.coordinate.longitude==0.0))){
            
            //Add the vallid location with good accuracy into an array
            //Every 1 minute, I will select the best location based on accuracy and send to server
            [self.shareModel.myLocationArray addObject:newLocation];
        }
    }
    
    //If the timer still valid, return it (Will not run the code below)
    if (self.shareModel.timer) {
        return;
    }
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
    
    //Restart the locationMaanger after 1 minute
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:LocationTimeInterval target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    
    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
    //The location manager will only operate for 10 seconds to save battery
    if (self.shareModel.delay10Seconds) {
        [self.shareModel.delay10Seconds invalidate];
        self.shareModel.delay10Seconds = nil;
    }
    
    self.shareModel.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:10 target:self
                                                    selector:@selector(stopLocationDelayBy10Seconds)
                                                    userInfo:nil
                                                     repeats:NO];

}


//Stop the locationManager
-(void)stopLocationDelayBy10Seconds{
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
	
	[self updateLocationToServer];
	
    NSLog(@"locationManager stop Updating");
}


- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
   // NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
        }
            break;
        case kCLErrorDenied:{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Service" message:@"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}


//Send the location to Server
- (void)updateLocationToServer {
    
    NSLog(@"updateLocationToServer");
    
    // Find the best location from the array based on accuracy
    CLLocation *myBestLocation = nil;
    
    for(int i=0;i<self.shareModel.myLocationArray.count;i++){
        CLLocation *currentLocation = [self.shareModel.myLocationArray objectAtIndex:i];
        
        if(i==0)
            myBestLocation = currentLocation;
        else{
            if(currentLocation.horizontalAccuracy <= myBestLocation.horizontalAccuracy) {
                myBestLocation = currentLocation;
            }
        }
    }
    
    //If the array is 0, get the last location
    //Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
    if(!myBestLocation)
    {
        NSLog(@"Unable to get location, use the last known location");
        return;
	} else {
		NSLog(@"My Best location:%@",myBestLocation);
	}
		
    CLLocationDegrees latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:LATITUDE];
    CLLocationDegrees longitude = [[NSUserDefaults standardUserDefaults] doubleForKey:LONGITUDE];
    
    CLLocation *lastBestLocation = nil;
    if (latitude != 0.0f && longitude != 0.0f) {
        lastBestLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    }
    
    if ([myBestLocation distanceFromLocation:lastBestLocation] >= DistanceFilter || !lastBestLocation) {
        
        //TODO: Your code to send the self.myLocation and self.myLocationAccuracy to your server
        
        NSString *currentDateString = [[NSDate date] stringWithFormat:@"yyyyMMdd"];
        WBSQLBuffer *sql = [[WBSQLBuffer alloc] init];
        sql.INSERT(DBLOCATION._tableName).SET(DBLOCATION._dateymd,currentDateString).SET(DBLOCATION._longitude,@(myBestLocation.coordinate.longitude)).SET(DBLOCATION._latitude,@(myBestLocation.coordinate.latitude));
        WBDatabaseTransaction *transaction = [[WBDatabaseTransaction alloc] initWithSQLBuffer:sql];
        [[WBDatabaseService defaultService] writeWithTransaction:transaction completionBlock:^{
        }];
        if (transaction.resultSet.resultCode == HTDatabaseResultSucceed) {
            NSLog(@"Send to Server: Latitude(%f) Longitude(%f) Accuracy(%f)",myBestLocation.coordinate.latitude, myBestLocation.coordinate.longitude,myBestLocation.horizontalAccuracy);
        }
        [[NSUserDefaults standardUserDefaults] setDouble:myBestLocation.coordinate.latitude forKey:LATITUDE];
        [[NSUserDefaults standardUserDefaults] setDouble:myBestLocation.coordinate.longitude forKey:LONGITUDE];
        [[NSUserDefaults standardUserDefaults] synchronize];
		
		CLLocation *location = [[CLLocation alloc] initWithLatitude:myBestLocation.coordinate.latitude longitude:myBestLocation.coordinate.longitude];
		[[NSNotificationCenter defaultCenter] postNotificationName:KNewLocationProducedNotification object:location];
    }
    
    //After sending the location to the server successful, remember to clear the current array with the following code. It is to make sure that you clear up old location in the array and add the new locations from locationManager
    [self.shareModel.myLocationArray removeAllObjects];
    self.shareModel.myLocationArray = nil;
    self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
}




@end
