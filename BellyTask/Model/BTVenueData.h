//
//  BTVenueData.h
//  BellyTask
//
//  Created by Nan Wang on 5/16/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BTVenueData : NSObject<MKAnnotation>

@property (nonatomic, strong) NSString *venueID;
@property (nonatomic, strong) NSString *venueName;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *hours;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *iconLink;
@property (nonatomic, strong) NSNumber *isOpen;

-(void)loadDataFromDictionary:(NSDictionary*)dict;

@end
