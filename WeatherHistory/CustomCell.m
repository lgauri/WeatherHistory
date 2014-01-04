//
//  CustomCell.m
//  WeatherHistory
//
//  Created by Pradnya on 01/01/14.
//
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize lblTemp,lblDescription,lblDate,lblHumidity,lblPressure,iconImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
