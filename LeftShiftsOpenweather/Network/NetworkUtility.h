//
//  NetworkUtility.h

#import <Foundation/Foundation.h>

@protocol NetworkUtilityDelegate <NSObject>



- (void)sendSuccessMessage:(NSString *)successMessage withReponseData:(NSDictionary *)responseDict;

- (void)sendFailureMessage:(NSString *)failureMessage;

@end

@interface NetworkUtility : NSObject <NSURLSessionTaskDelegate,NSURLSessionDelegate>

@property (nonatomic, assign) id<NetworkUtilityDelegate> networkUtilitydelegate;

- (void)requestUrl:(NSString *)requestUrl;

@end
