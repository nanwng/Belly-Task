//
//  BTDetailViewController.m
//  BellyTask
//
//  Created by Nan Wang on 5/17/14.
//
//

#import "BTDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "BTVenueData.h"
#import "BTCommon.h"

@interface BTDetailViewController (){
    BTVenueData *currVenue;
}

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end

@implementation BTDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithVenueData:(BTVenueData *)data{
    self = [self initWithNibName:@"BTDetailViewController" bundle:nil];
    if (self) {
        currVenue = data;
    }
    
    return self;
}

-(void)setupView:(BTVenueData*)data{
    [_thumbImageView setImage:[UIImage imageNamed:@"placeholder"]];
    if (data.iconLink) {
        [_thumbImageView setImageWithURL:[NSURL URLWithString:data.iconLink]
                        placeholderImage:[UIImage imageNamed:@"placeholder"]
                                 options:SDWebImageRefreshCached];
    }
    
    _titleLabel.text = data.venueName;
    
    _addressLabel.text = data.address;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(isIOS7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    [self setupView:currVenue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
