//
//  NetworkUtility.m
//  Neperia
//


#import "NetworkUtility.h"
#import "AppDelegate.h"

#define BASE_URL @"http://api.openweathermap.org/data/2.5/forecast/daily?cnt=14&APPID=%@&q=%@"
#define API_KEY @"a5322210c32ae7d4b3700ef5f4e47190"

@implementation NetworkUtility



- (void)requestUrl:(NSString *)requestUrl{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:BASE_URL,API_KEY,requestUrl]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (response == nil) {
            
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Network seems to be offline."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil] show];
            
        }else {
            
            [self sendResponse:response data:data error:error requestUrl:requestUrl];
            
        }
        
        
    }];

    [postDataTask resume];
        
}

- (void)sendResponse:(NSURLResponse *)response
                data:(NSData *)data
               error:(NSError *)error
          requestUrl:(NSString *)requestUrl {
    
    
    NSString *string = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"======================\nResponse from Server = %@======================\n",string);
    
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
    
   
    [self.networkUtilitydelegate sendSuccessMessage:nil withReponseData:responseDict];

}



@end
