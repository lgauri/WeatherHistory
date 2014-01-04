//
//  CustomCell.h
//  WeatherHistory
//
//  Created by Pradnya on 01/01/14.
//
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
{
    IBOutlet UILabel *lblTemp;
    IBOutlet UILabel *lblDescription;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblHumidity;
    IBOutlet UILabel *lblPressure;
    IBOutlet UIImageView *iconImageView;
}

@property(nonatomic,retain) IBOutlet UILabel *lblTemp;
@property(nonatomic,retain) IBOutlet UILabel *lblDescription;
@property(nonatomic,retain) IBOutlet UILabel *lblDate;
@property(nonatomic,retain) IBOutlet UILabel *lblHumidity;
@property(nonatomic,retain) IBOutlet UILabel *lblPressure;
@property(nonatomic,retain) IBOutlet UIImageView *iconImageView;

@end
