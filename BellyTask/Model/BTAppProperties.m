//
//  BTAppProperties.m
//  BellyTask
//
//  Created by Nan Wang on 5/17/14.
//
//

#import "BTAppProperties.h"
#import "BTCommon.h"
#import "BTVenueData.h"

@implementation BTAppProperties

+ (id)sharedInstance {
    static BTAppProperties *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        if ([self getData]) {
            self = [self getData];
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        _venueList = [decoder decodeObjectForKey:@"venueList"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_venueList forKey:@"venueList"];
}

-(void)storeData{
    NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:archivedObject forKey:VENUELISTKEY];
    [defaults synchronize];
}

-(id)getData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *archivedObject = [defaults objectForKey:VENUELISTKEY];
    return [NSKeyedUnarchiver unarchiveObjectWithData:archivedObject];
}

#pragma mark - load data 
-(void)loadVenueListFromDownloadData:(NSData *)data{
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
        
        NSArray *venueArray = [json objectForKey:@"results"];
        
        if (venueArray==nil || venueArray.count < 1) {
            NSLog(@"Failed downloading, no data");
            return;
        }
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in venueArray) {
            BTVenueData *venue = [[BTVenueData alloc] init];
            [venue loadDataFromDictionary:dict];
            [array addObject:venue];
        }
        
        // sort the array
        NSArray *sortedArray;
        sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSNumber *first = [(BTVenueData*)a distance];
            NSNumber *second = [(BTVenueData*)b distance];
            return [first compare:second];
        }];
        
        _venueList = sortedArray;
        
        // cache data
        [self storeData];
    }
}

@end
