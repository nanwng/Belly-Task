//
//  BTAppProperties.h
//  BellyTask
//
//  Created by Nan Wang on 5/17/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class BTVenueData;
@interface BTAppProperties : NSObject

@property (nonatomic, strong) NSArray *venueList;
@property (nonatomic, strong) CLLocation *currentLocation;

+(id)sharedInstance;

-(void)storeData;
-(void)loadVenueListFromDownloadData:(NSData*)data;

@end
