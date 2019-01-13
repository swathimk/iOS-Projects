//
//  DetailViewController.m
//  SharkFeed
//
//  Created by Swathi Bhattiprolu on 1/5/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

#import "DetailViewController.h"
#import "FlickrNetwork.h"

@interface DetailViewController (){
    FlickrNetwork *flickrnetwork;
    NSString *openInFlickrURL;
    CGFloat lastScale;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.isSavedImage){
        self.sharkImageView.image = [UIImage imageWithData:[self.selectedPhoto objectAtIndex:3]];
    }
    
    self.sharkImageScrollView.minimumZoomScale=1.0;
    self.sharkImageScrollView.maximumZoomScale=6.0;
    self.sharkImageScrollView.contentSize=CGSizeMake(1280, 960);
    self.sharkImageScrollView.delegate=self;
    
    flickrnetwork = [[FlickrNetwork alloc] init];
    [self fetchSharkImage];
    [self fetchSharkTextData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.sharkImageView;
}

- (void) fetchSharkImage {
    NSString *HQ = [self.selectedPhoto objectAtIndex:0];
    NSString *orig = [self.selectedPhoto objectAtIndex:1];
    if(HQ && ![HQ isEqualToString:@""]){
        orig = HQ;
    }
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:orig]];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sharkImageView setImage:[UIImage imageWithData:data]];
        });
    }];
    [dataTask resume];
}

- (void) fetchSharkTextData
{
    [flickrnetwork getImageDetails:[self.selectedPhoto objectAtIndex:2] withCompletionBlock:^(NSDictionary *data){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *description = [[[data valueForKey:@"photo"] valueForKey:@"description"] valueForKey:@"_content"];
            NSString *title = [[[data valueForKey:@"photo"] valueForKey:@"title"] valueForKey:@"_content"];
            self.story.text = [NSString stringWithFormat:@"%@ \n %@",title,description];
            self->openInFlickrURL = [[[[[data valueForKey:@"photo"] valueForKey:@"urls"] valueForKey:@"url"] objectAtIndex:0] valueForKey:@"_content"];
        });
    }];
}

- (IBAction) close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) downloadPhoto:(id)sender {
    UIImage *image = self.sharkImageView.image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSLog(@"Reached Here");
    if (!error)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Saved Successfully!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction) openInFlickr:(id)sender {
    NSLog(@"url is %@",openInFlickrURL);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openInFlickrURL]];

}


@end
