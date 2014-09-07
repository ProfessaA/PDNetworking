#import <Foundation/Foundation.h>


@class PDURLSessionClient;


@protocol PDURLSessionClientDelegate <NSObject>

- (void)URLSessionClient:(PDURLSessionClient *)client
          didSendRequest:(NSURLRequest *)request;

- (void)URLSessionClient:(PDURLSessionClient *)client
      didUpdateDataTasks:(NSArray *)dataTasks
             uploadTasks:(NSArray *)uploadTasks
           downloadTasks:(NSArray *)downloadTasks;

@end
