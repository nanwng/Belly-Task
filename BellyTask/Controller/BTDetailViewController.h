//
//  BTDetailViewController.h
//  BellyTask
//
//  Created by Nan Wang on 5/17/14.
//
//

#import <UIKit/UIKit.h>

@class BTVenueData;
@interface BTDetailViewController : UIViewController


-(id)initWithVenueData:(BTVenueData*)data;
-(void)setupView:(BTVenueData*)data;

@end
