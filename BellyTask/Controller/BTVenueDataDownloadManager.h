//
//  BTVenueDataDownloadManager.h
//  BellyTask
//
//  Created by Nan Wang on 5/17/14.
//
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(NSData *data, NSError *error);

@interface BTVenueDataDownloadManager : NSObject

-(void)downloadVenueDataWithLat:(float)latitude andLong:(float)longitude completionBlock:(CompletionBlock)block;


@end
