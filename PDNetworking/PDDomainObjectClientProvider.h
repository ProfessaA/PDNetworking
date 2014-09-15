#import <Foundation/Foundation.h>


@protocol PDDomainObjectClient;
@protocol PDURLSessionClientDelegate;
@protocol PDRequestProvider;


@interface PDDomainObjectClientProvider : NSObject

- (id<PDDomainObjectClient>)domainObjectClientWithURLSession:(NSURLSession *)urlSession
                                    urlSessionClientDelegate:(id<PDURLSessionClientDelegate>)urlSessionClientDelegate
                                   acceptableHTTPStatusCodes:(NSIndexSet *)acceptableHTTPStatusCodes
                                             requestProvider:(id<PDRequestProvider>)requestProvider
                                             httpErrorDomain:(NSString *)httpErrorDomain
                                                       queue:(NSOperationQueue *)queue;

@end
