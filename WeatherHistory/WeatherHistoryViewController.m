//
//  WeatherHistoryViewController.m
//  WeatherHistory
//
//  Created by Gauri Mankar on 31/12/13.
//
//

#import "WeatherHistoryViewController.h"
#import "SBJSON.h"
#import "CustomCell.h"
#import <QuartzCore/QuartzCore.h>

#define APP_ID @"e555fcfd9538c89f90d2aedbee8f46db"

@interface WeatherHistoryViewController ()

@end

@implementation WeatherHistoryViewController

@synthesize city;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ImageBackground.jpg"]];
    
    weatherHistoryArray = [[NSMutableArray alloc] init];
    screenSizeResult = [[UIScreen mainScreen] bounds].size;
    
    if (screenSizeResult.height == 480) {
        
        [weatherHistoryTableView setFrame:CGRectMake(0, 91, 320, 369)];
    }
    if (screenSizeResult.height == 568) {
        
        [weatherHistoryTableView setFrame:CGRectMake(0, 91, 320, 457)];
    }
    
    [weatherHistoryTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    btnCities.layer.cornerRadius = 5.0f;
    
    iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (iOSVersion == 7.0)
    {
        btnCities.layer.borderWidth = 1;
        btnCities.layer.borderColor = [[UIColor whiteColor] CGColor];
        [btnCities setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [weatherHistoryTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    else
    {
        btnCities.titleLabel.textColor = [UIColor colorWithRed:46/255.0 green:89/255.0 blue:123/255.0 alpha:1];
    }
      
    //Webservice call given to fetch last 30 days weather history data of city
    NSString *responseString = [self fetchWeatherHistoty];
    
    [self performSelectorOnMainThread:@selector(fetchWeatherHistotyProcessFinished:) withObject:responseString waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Webservice related Methods

-(NSString *)fetchWeatherHistoty
{
    NSDate *now = [NSDate date];
    NSLog(@"Current Date : %@",now);
    NSString *strCurrentDate = [NSString stringWithFormat:@"%.0f", [now timeIntervalSince1970]];
    NSLog(@"Unix Time : %@",strCurrentDate);
    
    NSDate *lastDay = [now dateByAddingTimeInterval:-1*24*60*60];

    NSString *strLastDay = [NSString stringWithFormat:@"%.0f", [lastDay timeIntervalSince1970]];
     
    NSDate *thirtyDaysAgo = [lastDay dateByAddingTimeInterval:-30*24*60*60];

    NSString *strThirtyDaysAgo = [NSString stringWithFormat:@"%.0f", [thirtyDaysAgo timeIntervalSince1970]];

    
    //Webservice call with start & end date in unix time format
    NSString *weatherHistoryURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/history/city?q=%@&APPID=%@&type=day&start=%@&end=%@",city,APP_ID,strThirtyDaysAgo,strLastDay];
          
    NSLog(@"weatherHistoryURL : %@",weatherHistoryURL);
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:weatherHistoryURL]];
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return responseString;
}

-(void)fetchWeatherHistotyProcessFinished:(NSString *)responseString
{
    @try {
        
        NSError *error;
        SBJSON *json = [SBJSON new] ;
        NSArray *responseArray = [json objectWithString:responseString error:&error];
        
        if ((responseArray == nil)||(responseString == nil))
        {
            UIAlertView * resetLogAlert= [[UIAlertView alloc] initWithTitle:@""
                                                                    message:[error localizedDescription]
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
            [resetLogAlert show];
        }
        else
        {
            if ([[responseArray valueForKey:@"cod"] isEqualToString:@"200"])
            {
                [lblCityName setText:city];
                
                weatherHistoryArray = [(NSMutableDictionary *)responseArray valueForKey:@"list"];

            }
            else
            {
                UIAlertView * resetLogAlert= [[UIAlertView alloc] initWithTitle:@""
                                                                        message:[responseArray valueForKey:@"message"]
                                                                       delegate:self
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"OK", nil];
                [resetLogAlert show];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"catching %@ reason %@", [exception name], [exception reason]);
    }
    @finally {
        
    }
}

#pragma mark - IBAction Methods

-(IBAction)btnCitiesClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [weatherHistoryArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CustomCell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    float temp = [[[[weatherHistoryArray objectAtIndex:indexPath.row] valueForKey:@"main"] valueForKey:@"temp"] floatValue];
    
    //To convert temp from Kelvin to celcius
    float tempInCelcius = temp - 273.15;
    cell.lblTemp.text = [NSString stringWithFormat:@"%.2f°",tempInCelcius];
    
    //Weather icon image shown
    UIImage *iconImage;
  
    NSString *strIconImage = [[[[weatherHistoryArray objectAtIndex:indexPath.row] valueForKey:@"weather"] objectAtIndex:0] valueForKey:@"icon"];
    
    if ([strIconImage isEqualToString:@"01d"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"01d" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"01n"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"01n" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"02d"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"02d" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"02n"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"02n" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"03d"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"03d" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"03n"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"03n" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"04d"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"04d" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"04n"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"04n" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"09d"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"09d" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"09n"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"09n" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"10d"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"10d" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"10n"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"10n" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"11d"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"11d" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"11n"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"11n" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"13d"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"13d" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"13n"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"13n" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"50d"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"50d" ofType:@"png"]];
    }
    else if ([strIconImage isEqualToString:@"50n"]) {
        
        iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"50n" ofType:@"png"]];
    }
    
    dispatch_queue_t imgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(imgQueue, ^{
              
        dispatch_async(dispatch_get_main_queue(), ^{

                [cell.iconImageView setImage:iconImage];

        });
    });
    
    cell.lblDescription.text = [[[[weatherHistoryArray objectAtIndex:indexPath.row] valueForKey:@"weather"] objectAtIndex:0] valueForKey:@"main"];
    
    NSString *strHumidity = [NSString stringWithFormat:@"%@%%",[[[weatherHistoryArray objectAtIndex:indexPath.row] valueForKey:@"main"] valueForKey:@"humidity"]];
    cell.lblHumidity.text = strHumidity;
    
    //Pressure converted from kPa (kiloPascals) to in (inches)
    float pressureInInches = [[[[weatherHistoryArray objectAtIndex:indexPath.row] valueForKey:@"main"] valueForKey:@"pressure"] floatValue]*0.295300;
     NSString *strPressure = [NSString stringWithFormat:@"%.0fin",pressureInInches];
    cell.lblPressure.text = strPressure;
    
   float createdDate = [[[weatherHistoryArray objectAtIndex:indexPath.row] valueForKey:@"dt"] floatValue];
    
    NSTimeInterval _interval=createdDate;
    NSDate *createdDate_ = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM dd, yyyy, HH:mm:ss a";
    NSString *strDate = [dateFormatter stringFromDate:createdDate_];
    cell.lblDate.text = strDate;
    
    return cell;
}

@end
