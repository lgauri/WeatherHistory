//
//  CityViewController.h
//  WeatherHistory
//
//  Created by Gauri Mankar on 31/12/13.
//
//

#import <UIKit/UIKit.h>
#import "WeatherHistoryViewController.h"

@interface CityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    IBOutlet UITableView *cityTableView;
    IBOutlet UIActivityIndicatorView *activityIndicatorView;
    IBOutlet UITextField *txtCity;
    IBOutlet UILabel *lblCityName;
    IBOutlet UIButton *btnAdd;
    
    CGSize screenSizeResult;
    NSMutableArray *cityNamesArray;
    
    WeatherHistoryViewController *weatherHistoryViewController;
    float iOSVersion;
}

-(void)showWeatherHistoryViewWithIndex:(NSString *)index;

@end
