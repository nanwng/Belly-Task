//
//  BTCommon.h
//  BellyTask
//
//  Created by Nan Wang on 5/17/14.
//
//

#ifndef BellyTask_BTCommon_h
#define BellyTask_BTCommon_h

#define GoogleAPIKey            @"AIzaSyD6c3nN4cR1yg--kcqYQVMDzPd4QpegtQw"
#define AppFont(sz)             [UIFont fontWithName:@"HelveticaNeue-Light" size:sz]
#define isIOS7                  [UIDevice currentDevice].systemVersion.floatValue >= 7.0

// webservice
#define VenueRequestURL         @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&sensor=false&key=" GoogleAPIKey
#define VenuePhotoRequestURL    @"https://maps.googleapis.com/maps/api/place/photo?maxwidth=300&photoreference=%@&sensor=true&key=" GoogleAPIKey

// Dictionary keys
#define VENUELISTKEY            @"BTVenueListKey"

#endif
