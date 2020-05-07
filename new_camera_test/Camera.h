//
//  Camera.h
//  new_camera_test
//
//  Created by Inje Cho on 2020/04/27.
//  Copyright © 2020 Inje Cho. All rights reserved.
//
#ifndef camera_h
#define camera_h


#endif /* camera_h */
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "MBLocationManager.h"


@interface Camera : UIViewController<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}


- (IBAction)Shot:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *frameforcapture;
@property (weak, nonatomic) NSTimer *m_timer;


@end


