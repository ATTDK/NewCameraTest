//
//  Camera.m
//  new_camera_test
//
//  Created by Inje Cho on 2020/04/27.
//  Copyright © 2020 Inje Cho. All rights reserved.
//
#import "ViewController.h"
#import "Camera.h"
#import <Photos/Photos.h>

@interface Camera()

@end


@implementation Camera

@synthesize m_timer = m_timer;
AVCaptureSession *session;
AVCaptureStillImageOutput *StillImageOutput;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self locationStart];
    [self setTimer];
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)setTimer {
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerComplete:) userInfo:nil repeats:NO];
}

- (void)timerComplete:(NSTimer *)p_timer {
    NSLog(@"timer complete");
    if (m_timer != nil) {
        [m_timer invalidate];
        m_timer = nil;
    }
    [self checkLocation];
    
}

-(void)checkLocation{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            
            // 권한 확인 전
            NSLog(@"JH 권한 획득 여부를 확인하지 않았음.");
            m_timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerComplete:) userInfo:nil repeats:NO];
            break;
            
        case kCLAuthorizationStatusRestricted:
            
            // 위치 정보를 사용한다고 말을 하지 않은 앱. 개발자가 프로젝트에 이 앱은 위치 정보를 사용한다고 설정을 해두지 않은 경우이다
            NSLog(@"JH This app is Restricted");
            
        case kCLAuthorizationStatusDenied:
            
            // 권한 획득 안되었을 경우. 설정에서 off를 하였을 경우에도 포함됨.
            NSLog(@"JH NO or truned off location in Settings");
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
            
            // 7이하 버전 권한 획득시, 8이상 버전 백그라운드에서도 사용 가능
            NSLog(@"JH YES. User autohrized background use.");
            
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            
            // 8이상 버전 앱을 사용중일 경우에만 사용 가능
            NSLog(@"JH YES. User has autohrized use only when the app is in the foreground.");
            break;
            
        default:
            break;
    }
}

- (void)locationStart
{
    NSLog(@"locationStart");
    [[MBLocationManager sharedManager] startLocationUpdates:kMBLocationManagerModeStandardWhenInUse
                                             distanceFilter:kCLDistanceFilterNone
                                                   accuracy:kCLLocationAccuracyBest];
}

-(void)viewWillAppear:(BOOL)animated{
    session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];

    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];

    CGRect frame = _frameforcapture.frame;

    [previewLayer setFrame:frame];
    [rootLayer insertSublayer:previewLayer above:0];

    StillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecTypeJPEG,AVVideoCodecKey, nil];
    [StillImageOutput setOutputSettings:outputSettings];
    [session addOutput:StillImageOutput];
    [session startRunning];
    

}

- (IBAction)Shot:(id)sender {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in StillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
                videoConnection = connection;
                break;
            }
        }
    }
        
    [StillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error)
    {
        CFDictionaryRef exifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyCIFFDictionary, NULL);
        if(exifAttachments){
            NSDictionary *dictExif = (__bridge NSDictionary *)exifAttachments;
            for(NSString *key in dictExif){
                NSLog(@"%@: %@",key,[dictExif valueForKey:key]);
            }
        }
        if (imageDataSampleBuffer != NULL)
        {
            //이미지 데이터 버퍼가 존재한다면
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            //UIImageWriteToSavedPhotosAlbum(image,
            //                               self,
            //                               @selector(image:didFinishSavingWithError:contextInfo:),
            //                               nil);
            UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
        writeImageDataToSavedPhotosAlbum:metadata:nil;
            
            //self->_imageV.image = image;
        }
            
    }];
        
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error){
        NSLog(@"error: %@",[error localizedDescription]);
    }else{
        NSLog(@"saved");
    }
}




@end



