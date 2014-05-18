//
//  BTVenueData.m
//  BellyTask
//
//  Created by Nan Wang on 5/16/14.
//
//

#import "BTVenueData.h"
#import "BTAppProperties.h"
#import "BTCommon.h"

@implementation BTVenueData

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        _venueID = [decoder decodeObjectForKey:@"venueID"];
        _venueName = [decoder decodeObjectForKey:@"venueName"];
        _location = [decoder decodeObjectForKey:@"location"];
        _address = [decoder decodeObjectForKey:@"address"];
        _categories = [decoder decodeObjectForKey:@"categories"];
        _hours = [decoder decodeObjectForKey:@"hours"];
        _distance = [decoder decodeObjectForKey:@"distance"];
        _iconLink = [decoder decodeObjectForKey:@"iconLink"];
        _isOpen = [decoder decodeObjectForKey:@"isOpen"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_venueID forKey:@"venueID"];
    [encoder encodeObject:_venueName forKey:@"venueName"];
    [encoder encodeObject:_location forKey:@"location"];
    [encoder encodeObject:_address forKey:@"address"];
    [encoder encodeObject:_categories forKey:@"categories"];
    [encoder encodeObject:_hours forKey:@"hours"];
    [encoder encodeObject:_distance forKey:@"distance"];
    [encoder encodeObject:_iconLink forKey:@"iconLink"];
    [encoder encodeObject:_isOpen forKey:@"isOpen"];
}

#pragma mark - load data funcitons
-(void)loadDataFromDictionary:(NSDictionary *)dict{
    
    _venueName = [dict objectForKey:@"name"];
    _venueID = [dict objectForKey:@"id"];
    
    _categories = [dict objectForKey:@"types"];
    
    NSDictionary *loc = [dict objectForKey:@"geometry"];
    NSNumber *latitude = [[loc objectForKey:@"location"] objectForKey:@"lat"];
    NSNumber *longitude = [[loc objectForKey:@"location"] objectForKey:@"lng"];
    _location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
    CLLocationDistance between = [[[BTAppProperties sharedInstance] currentLocation] distanceFromLocation:_location];
    _distance = [NSNumber numberWithFloat:between/1609.344];
    
    if ([dict objectForKey:@"photos"]) {
        NSArray *photos = [dict objectForKey:@"photos"];
        NSDictionary *photoinfo = [photos objectAtIndex:0];
        _iconLink = [NSString stringWithFormat:VenuePhotoRequestURL, [photoinfo objectForKey:@"photo_reference"]];
    }
    
    if ([dict objectForKey:@"opening_hours"]) {
        _isOpen = [[dict objectForKey:@"opening_hours"] objectForKey:@"open_now"];
    }
    
    _address = [dict objectForKey:@"vicinity"];
}

#pragma mark - MKAnnotation
-(CLLocationCoordinate2D)coordinate{
    return _location.coordinate;
}

-(NSString *)title{
    return _venueName;
}

@end
