//
//  WeatherHistoryViewController.h
//  WeatherHistory
//
//  Created by Gauri Mankar on 31/12/13.
//
//

#import <UIKit/UIKit.h>

@interface WeatherHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UILabel *lblCityName;
    IBOutlet UITableView *weatherHistoryTableView;
    IBOutlet UIButton *btnCities;
    
    NSMutableArray *weatherHistoryArray;
    
    CGSize screenSizeResult;
    float iOSVersion;
}

@property(nonatomic,retain) NSString *city;

-(NSString *)fetchWeatherHistoty;
-(void)fetchWeatherHistotyProcessFinished:(NSString *)responseString;

@end
