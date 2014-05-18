//
//  BTTestDownload.m
//  BellyTask
//
//  Created by Nan Wang on 5/17/14.
//
//

#import <XCTest/XCTest.h>
#import "BTVenueDataDownloadManager.h"

@interface BTTestDownload : XCTestCase

@end

@implementation BTTestDownload

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDownload{
    
    float latitude = 40.7;
    float longitude = -74;
    
    BTVenueDataDownloadManager *downloader = [[BTVenueDataDownloadManager alloc] init];
    // Set the flag to YES
    __block BOOL waitingForBlock = YES;
    
    // Call the asynchronous method with completion block
    [downloader downloadVenueDataWithLat:latitude
                                 andLong:longitude
                         completionBlock:^(NSData *data, NSError *error) {
                             // Set the flag to NO to break the loop
                             waitingForBlock = NO;
                             
                             // Assert the nil error
                             XCTAssertNil(error, @"There is error");
                         }];
    
    // Run the loop
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
}


@end
