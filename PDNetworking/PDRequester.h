#import <Foundation/Foundation.h>


@class KSPromise;


@protocol PDRequester <NSObject>

- (KSPromise *)promiseWithRequest:(NSURLRequest *)request;

@end
