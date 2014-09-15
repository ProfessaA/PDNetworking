#import <Foundation/Foundation.h>


@class KSPromise;
@protocol PDNetworkResource;


@protocol PDDomainObjectClient <NSObject>

- (KSPromise *)promiseWithNetworkResource:(id<PDNetworkResource>)networkResource
                        requestParameters:(id)requestParameters;

@end
