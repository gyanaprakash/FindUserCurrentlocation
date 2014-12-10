//
//  ViewController.h
//  YAACLocation
//
//  Created by Bsetecip10 on 09/12/14.
//  Copyright (c) 2014 gyana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    BOOL istype;
}
@property (weak, nonatomic) IBOutlet UILabel *lat;
@property (weak, nonatomic) IBOutlet UILabel *longnitude;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIButton *maptype;

- (IBAction)findCurrentLocation:(UIButton *)sender;

@end

