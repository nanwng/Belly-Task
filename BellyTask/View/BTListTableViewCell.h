//
//  BTListTableViewCell.h
//  BellyTask
//
//  Created by Nan Wang on 5/17/14.
//
//

#import <UIKit/UIKit.h>

@interface BTListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *openLabel;
@end
