//
//  BTVenueDataDownloadManager.m
//  BellyTask
//
//  Created by Nan Wang on 5/17/14.
//
//

#import "BTVenueDataDownloadManager.h"
#import "BTCommon.h"

@implementation BTVenueDataDownloadManager

-(void)downloadVenueDataWithLat:(float)latitude andLong:(float)longitude completionBlock:(CompletionBlock)block{
    NSString *urlstr = [NSString stringWithFormat:VenueRequestURL,latitude, longitude];
    
    NSURL *url = [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               block(data, error);
                           }];
}



@end
