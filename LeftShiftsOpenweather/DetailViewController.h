//
//  DetailViewController.h
//  LeftShiftsOpenweather
//
//  Created by AshU on 3/18/15.
//  Copyright (c) 2015 Ashish Khobragade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

