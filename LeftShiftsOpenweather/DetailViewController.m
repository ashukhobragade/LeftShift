//
//  DetailViewController.m
//  LeftShiftsOpenweather
//
//  Created by AshU on 3/18/15.
//  Copyright (c) 2015 Ashish Khobragade. All rights reserved.
//

#import "DetailViewController.h"
#import "NetworkUtility.h"
#import "CityModel.h"
#import "CityDataModel.h"
#import "MBProgressHUD.h"

#define KELVIN  273.15

@interface DetailViewController ()<NetworkUtilityDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UILabel *cityName;
@property(nonatomic,strong)UILabel *cityMaxTemp;
@property(nonatomic,strong)UILabel *cityMinTemp;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        NetworkUtility *networkUtility = [[NetworkUtility alloc] init];
        [networkUtility setNetworkUtilitydelegate:(id)self];
        [networkUtility requestUrl:_detailItem];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)configureView {
    
    _cityName =[[UILabel alloc] initWithFrame:CGRectMake(0,80, self.view.frame.size.width, 40)];
    [_cityName setTextColor:[UIColor blueColor]];
    [_cityName setText:_detailItem];
    [_cityName setTextAlignment:NSTextAlignmentCenter];
    [_cityName setContentMode:UIViewContentModeCenter];
    [self.view addSubview:_cityName];
    
    _cityMaxTemp =[[UILabel alloc] initWithFrame:CGRectMake(0,120, self.view.frame.size.width, 40)];
    [_cityMaxTemp setTextColor:[UIColor blueColor]];
    [_cityMaxTemp setTextAlignment:NSTextAlignmentCenter];
    [_cityMaxTemp setContentMode:UIViewContentModeCenter];
    [self.view addSubview:_cityMaxTemp];
    
    
    _cityMinTemp =[[UILabel alloc] initWithFrame:CGRectMake(0,160, self.view.frame.size.width, 40)];
    [_cityMinTemp setTextColor:[UIColor blueColor]];
    [_cityMinTemp setTextAlignment:NSTextAlignmentCenter];
    [_cityMinTemp setContentMode:UIViewContentModeCenter];
    [self.view addSubview:_cityMinTemp];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-200, self.view.frame.size.width, 200)];
    
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_scrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendSuccessMessage:(NSString *)successMessage withReponseData:(NSDictionary *)responseDict {
    
    if ([[responseDict valueForKey:@"cod"] isEqualToString:@"404"]) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"No Data Found."
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil] show];
            
        });
    }
    else{
        CityModel*cityModel=  [CityModel cityModelFromDictionary:responseDict];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.cityMaxTemp setText:[NSString stringWithFormat:@"Maximum : %0.2f°C",[[[cityModel.cityTemperatureDetailsArray objectAtIndex:1] maxTemp] floatValue]-KELVIN]];
            [self.cityMinTemp setText:[NSString stringWithFormat:@"Minimum : %0.2f°C",[[[cityModel.cityTemperatureDetailsArray objectAtIndex:1] minTemp] floatValue]-KELVIN]];
            
            for (int i=0; i<cityModel.cityTemperatureDetailsArray.count; i++) {
                
                CityDataModel *cityDataModel =[cityModel.cityTemperatureDetailsArray objectAtIndex:i];
                
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((i*150)+1*i,0, 150, self.scrollView.frame.size.height)];
                [label setTextColor:[UIColor blueColor]];
                [label setNumberOfLines:2];
                [label setBackgroundColor:[UIColor lightGrayColor]];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setContentMode:UIViewContentModeCenter];
                [label setText:[NSString stringWithFormat:@"Max : %0.2f°C \n Min : %0.2f°C",[cityDataModel.maxTemp floatValue]-KELVIN,[cityDataModel.minTemp floatValue]-KELVIN]];
                
                UILabel * dateLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,0, label.frame.size.width, 30)];
                [dateLabel setTextColor:[UIColor blueColor]];
                [dateLabel setBackgroundColor:[UIColor grayColor]];
                [dateLabel setTextAlignment:NSTextAlignmentCenter];
                [dateLabel setContentMode:UIViewContentModeCenter];
                [label addSubview:dateLabel];
                NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
                [dtFormatter setDateFormat:@"dd-MM-yyyy"];
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[cityDataModel.date integerValue]];
                if (i==0) {
                    [dateLabel setText:@"Yesterday"];
                } else  if (i==1) {
                    [dateLabel setText:@"Today"];
                } else  if (i==2){
                    [dateLabel setText:@"Tomorrow"];
                }else{
                    [dateLabel setText:[dtFormatter stringFromDate:date]];
                }
                
                [_scrollView addSubview:label];
            }
            [_scrollView setContentSize:CGSizeMake(cityModel.cityTemperatureDetailsArray.count*150, self.scrollView.frame.size.height)];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    }
}

- (void)sendFailureMessage:(NSString *)failureMessage{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"SOME NETWORK ERROR!."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
        
    });
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
