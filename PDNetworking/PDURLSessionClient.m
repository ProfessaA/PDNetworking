#import "PDURLSessionClient.h"
#import "KSDeferred.h"
#import "PDURLSessionClientDelegate.h"
#import "KSNetworkClient.h"


@interface PDURLSessionClient ()

@property (nonatomic) NSURLSession *URLSession;

@end


@implementation PDURLSessionClient

- (instancetype)initWithURLSession:(NSURLSession *)URLSession
{
    self = [super init];
    if (self) {
        self.URLSession = URLSession;
    }
    return self;
}

#pragma mark - <PDRequester>

- (KSPromise *)promiseWithRequest:(NSURLRequest *)request
{
    KSDeferred *deferred = [KSDeferred defer];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [self.URLSession dataTaskWithRequest:request
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          __strong typeof(weakSelf) strongSelf = weakSelf;
                                          
                                          [strongSelf.URLSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
                                              [strongSelf.delegate URLSessionClient:strongSelf didUpdateDataTasks:dataTasks uploadTasks:uploadTasks downloadTasks:downloadTasks];
                                          }];
                                          
                                          if (error) {
                                              [deferred rejectWithError:error];
                                          }
                                          else {
                                              KSNetworkResponse *networkResponse = [KSNetworkResponse networkResponseWithURLResponse:response data:data];
                                              [deferred resolveWithValue:networkResponse];
                                          }
                                      }];
    [dataTask resume];
    [self.delegate URLSessionClient:self didSendRequest:request];
    return deferred.promise;
}

#pragma mark - NSObject

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
