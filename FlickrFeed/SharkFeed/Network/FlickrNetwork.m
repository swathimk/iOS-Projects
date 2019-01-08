//
//  FlickrNetwork.m
//  SharkFeed
//
//  Created by Swathi Bhattiprolu on 1/3/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

#import "FlickrNetwork.h"

NSString *APIKey = @"949e98778755d1982f537d56236bbb42";
NSString *searchText = @"shark";


@implementation FlickrNetwork


- (void) getFlickrImages: (int)pagenum withCompletionBlock:(void (^)(NSDictionary *response)) success {
    NSString *imageSetURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&format=json&nojsoncallback=1&page=%d&extras=url_t,url_c,url_l,url_o",APIKey,searchText,pagenum];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:imageSetURL]];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary *responseDictionary;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        }
        else
        {
            NSLog(@"Error");
        }
        success(responseDictionary);
    }];
    [dataTask resume];
    
}


- (void) getImageDetails: (NSString *)photoID withCompletionBlock:(void (^)(NSDictionary *response)) success {
    NSString *imageSetURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=%@&photo_id=%@&format=json&nojsoncallback=1",APIKey,photoID];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:imageSetURL]];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          NSDictionary *responseDictionary;
                                          if(httpResponse.statusCode == 200)
                                          {
                                              NSError *parseError = nil;
                                              responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                          }
                                          else
                                          {
                                              NSLog(@"Error");
                                          }
                                          success(responseDictionary);
                                      }];
    [dataTask resume];
    
}






@end
