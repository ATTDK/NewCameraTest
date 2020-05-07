//
//  Result.h
//  new_camera_test
//
//  Created by Inje Cho on 2020/04/28.
//  Copyright © 2020 Inje Cho. All rights reserved.
//

#ifndef Result_h
#define Result_h


#endif /* Result_h */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Result : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *ResultView;

- (IBAction)Save:(id)sender;


- (IBAction)Cancel:(id)sender;


@end
