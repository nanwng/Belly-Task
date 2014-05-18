//
//  BTMainViewController.m
//  BellyTask
//
//  Created by Nan Wang on 5/17/14.
//
//

#import "BTMainViewController.h"
#import "bTCommon.h"
#import "BTVenueDataDownloadManager.h"
#import "BTAppProperties.h"
#import "BTListTableViewCell.h"
#import "BTVenueData.h"
#import "UIImageView+WebCache.h"
#import "BTDetailViewController.h"

@interface BTMainViewController ()<UITableViewDataSource, UITabBarDelegate, CLLocationManagerDelegate, MKMapViewDelegate>{
    BTVenueDataDownloadManager *downloadManager;
    CGRect mapViewFrame;
    UIBarButtonItem *closeMapButton;
    UIBarButtonItem *refreshButton;
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet MKMapView *listMapView;
@property (weak, nonatomic) IBOutlet UIView *mapOverlay;

@end

@implementation BTMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(isIOS7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    self.title = @"Locations";
    
    // load cached data
    [self setupAnnotations];
    
    downloadManager = [[BTVenueDataDownloadManager alloc] init];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    
    // add tap to mapview
    mapViewFrame = _listMapView.frame;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMapView:)];
    [_mapOverlay addGestureRecognizer:tap];
    closeMapButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeMapButtonCLicked:)];
    
    // setup refresh button
    refreshButton = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(refreshLocations:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - refresh function
-(void)refreshLocations:(id)sender{
    [_locationManager stopUpdatingLocation];
    [_locationManager startUpdatingLocation];
}

#pragma mark - mapview tap
-(void)tapOnMapView:(id)sender{
    NSLog(@"Tap on map");
    
    [_mapOverlay setHidden:YES];
    [UIView animateWithDuration:0.3
                     animations:^{
                         _listMapView.frame = self.view.bounds;
                     } completion:^(BOOL finished) {
                         [self zoomMapToFitAnnotations];
                         self.navigationItem.rightBarButtonItem = closeMapButton;
                     }];
    

}

-(void)closeMapButtonCLicked:(id)sender{
    
    float dur = 0.3;
    
    if (sender == nil) {
        dur = 0;
    }
    
    [UIView animateWithDuration:dur
                     animations:^{
                         _listMapView.frame = mapViewFrame;
                     } completion:^(BOOL finished) {
                         [_mapOverlay setHidden:NO];
                         for (NSObject<MKAnnotation> *annotation in [_listMapView selectedAnnotations]) {
                             [_listMapView deselectAnnotation:(id <MKAnnotation>)annotation animated:NO];
                         }
                         [self zoomMapToFitAnnotations];
                         self.navigationItem.rightBarButtonItem = refreshButton;
                     }];
}

#pragma mark - tableview delegate/datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[BTAppProperties sharedInstance] venueList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BTListTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    BTVenueData *listData = [[[BTAppProperties sharedInstance] venueList] objectAtIndex:indexPath.row];
    cell.titleLabel.text = listData.venueName;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.02f miles away", [listData.distance floatValue]];
    NSString *catString = @"";
    for (NSString *str in listData.categories) {
        if ([str isEqualToString:@"establishment"]) {
            continue;
        }
        catString  = [catString stringByAppendingString:str];
        catString  = [catString stringByAppendingString:@" & "];
    }
    if (catString.length >= 3) {
        catString  = [catString substringToIndex:catString.length-3];
    }
    cell.categoryLabel.text = catString;
    
    if (listData.isOpen != nil) {
        cell.openLabel.hidden = NO;
        if ([listData.isOpen boolValue]) {
            cell.openLabel.text = @"OPEN";
            cell.openLabel.textColor = [UIColor greenColor];
        }else{
            cell.openLabel.text = @"CLOSE";
            cell.openLabel.textColor = [UIColor redColor];
        }
    }else{
        cell.openLabel.hidden = YES;
    }
    
    if (listData.iconLink) {
        [cell.thumbImageView setImageWithURL:[NSURL URLWithString:listData.iconLink] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageCacheMemoryOnly];
    }else{
        cell.thumbImageView.image = [UIImage imageNamed:@"placeholder"];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BTVenueData *venue = [[[BTAppProperties sharedInstance] venueList] objectAtIndex:indexPath.row];
    BTDetailViewController *detailView = [[BTDetailViewController alloc] initWithVenueData:venue];
    [self.navigationController pushViewController:detailView animated:YES];
}

#pragma mark - CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    [_locationManager stopUpdatingLocation];
    
    [[BTAppProperties sharedInstance] setCurrentLocation:newLocation];
    
    [downloadManager downloadVenueDataWithLat:newLocation.coordinate.latitude
                                      andLong:newLocation.coordinate.longitude
                              completionBlock:^(NSData *data, NSError *error) {
                                  
                                  NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                  NSLog(@"response: %@", response);
                                  
                                  if (!error) {
                                      
                                      [[BTAppProperties sharedInstance] loadVenueListFromDownloadData:data];
                                      
                                      [self setupAnnotations];
                                      
                                      [_listTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                                  }
                              }];

}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [_locationManager stopUpdatingLocation];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Failed updating your current location" delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - MapView functions

-(void)zoomMapToFitAnnotations{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in _listMapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [_listMapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(10, 10, 10, 10) animated:YES];
}

- (void)setupAnnotations{
    
    [_listMapView removeAnnotations:_listMapView.annotations];
    [_listMapView addAnnotations:[[BTAppProperties sharedInstance] venueList]];
    [self zoomMapToFitAnnotations];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *identifier = @"BTAnnotation";
    
    if([annotation isKindOfClass:[BTVenueData class]]){
        MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(!annotationView){
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"pin"];
            UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            leftView.contentMode = UIViewContentModeScaleAspectFill;
            leftView.clipsToBounds = YES;
            annotationView.leftCalloutAccessoryView = leftView;
            
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
        UIImageView *left = (UIImageView*)annotationView.leftCalloutAccessoryView;
        left.image = [UIImage imageNamed:@"placeholder"];
        
        BTVenueData *venue = (BTVenueData*)annotation;
        if (venue.iconLink) {
            [left setImageWithURL:[NSURL URLWithString:venue.iconLink]
                     placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
        }
        
        return annotationView;
    }
    return nil;

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    BTVenueData *venue = (BTVenueData*)view.annotation;
    [self closeMapButtonCLicked:nil];
    BTDetailViewController *detailView = [[BTDetailViewController alloc] initWithVenueData:venue];
    [self.navigationController pushViewController:detailView animated:YES];
}




@end
