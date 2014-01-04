//
//  CityViewController.m
//  WeatherHistory
//
//  Created by Gauri Mankar on 31/12/13.
//
//

#import "CityViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CityViewController ()

@end

@implementation CityViewController

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
    [cityTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    cityNamesArray = [[NSMutableArray alloc] init];
    screenSizeResult = [[UIScreen mainScreen] bounds].size;
    
    if (screenSizeResult.height == 480) {
        
        [cityTableView setFrame:CGRectMake(0, 150, 320, 310)];
        [activityIndicatorView setFrame:CGRectMake(142, 222, 37, 37)];
    }
    if (screenSizeResult.height == 568) {
        
        [cityTableView setFrame:CGRectMake(0, 150, 320, 398)];
        [activityIndicatorView setFrame:CGRectMake(142, 255, 37, 37)];
    }
    
    [lblCityName setHidden:YES];
    [activityIndicatorView setHidden:YES];
    
    btnAdd.layer.cornerRadius = 5.0f;
    
    iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (iOSVersion == 7.0)
    {
        btnAdd.layer.borderWidth = 1;
        btnAdd.layer.borderColor = [[UIColor whiteColor] CGColor];
        [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [cityTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    else
    {
        btnAdd.titleLabel.textColor = [UIColor colorWithRed:46/255.0 green:89/255.0 blue:123/255.0 alpha:1];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [activityIndicatorView stopAnimating];
    [activityIndicatorView setHidden:YES];
    
    [txtCity resignFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods

-(IBAction)btnAddClicked:(id)sender
{
    if (![txtCity.text isEqualToString:@""]) {
        
        NSString *strCityName = txtCity.text;
        
        [txtCity setText:@""];
        
        [cityNamesArray addObject:strCityName];
        [cityTableView reloadData];
        [cityTableView setNeedsDisplay];
    }
    else
    {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@""
                                                       message:@"Please enter city name."
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    if (cityNamesArray.count>0) {
        
        [lblCityName setHidden:NO];
    }
}

-(void)showWeatherHistoryViewWithIndex:(NSString *)index
{
    weatherHistoryViewController = [[WeatherHistoryViewController alloc] initWithNibName:@"WeatherHistoryViewController" bundle:nil];
    weatherHistoryViewController.city = [cityNamesArray objectAtIndex:[index intValue]];
    weatherHistoryViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:weatherHistoryViewController animated:YES completion:nil];
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cityNamesArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size :16]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.text = [cityNamesArray objectAtIndex:indexPath.row];
    
    NSLog(@"%@",cell.textLabel.text);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [txtCity resignFirstResponder];
    [self.view bringSubviewToFront:activityIndicatorView];
    [activityIndicatorView setHidden:NO];
    [activityIndicatorView startAnimating];
    
    NSString *index = [NSString stringWithFormat:@"%d",indexPath.row];
    [self performSelector:@selector(showWeatherHistoryViewWithIndex:) withObject:index afterDelay:0.1f];
    
    
}


#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
