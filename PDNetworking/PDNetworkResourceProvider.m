#import "PDNetworkResourceProvider.h"
#import "PDNetworkResource.h"


@interface _PDNetworkResource : NSObject <PDNetworkResource>

@property (nonatomic, copy) NSString * (^pathConfigurationBlock)(id requestParameters);
@property (nonatomic, copy) NSString *HTTPVerb;
@property (nonatomic) id<PDRequestParametersSerializer> requestParametersSerializer;
@property (nonatomic) id<PDDeserializer> deserializer;

@end


@implementation _PDNetworkResource
@synthesize pathConfigurationBlock = _pathConfigurationBlock;
@synthesize requestParametersSerializer = _requestParametersSerializer;
@synthesize deserializer = _deserializer;
@synthesize HTTPVerb = _HTTPVerb;

- (instancetype)initWithPathConfigurationBlock:(NSString * (^)(id))pathConfigurationBlock
                   requestParametersSerializer:(id<PDRequestParametersSerializer>)requestParametersSerializer
                                  deserializer:(id<PDDeserializer>)deserializer
                                      HTTPVerb:(NSString *)HTTPVerb
{
    self = [super init];
    if (self) {
        self.pathConfigurationBlock = pathConfigurationBlock;
        self.requestParametersSerializer = requestParametersSerializer;
        self.deserializer = deserializer;
        self.HTTPVerb = HTTPVerb;
    }
    return self;
}

#pragma mark - <PDNetworkResource>

- (NSString *)HTTPMethod
{
    return self.HTTPVerb;
}

#pragma mark - NSObject

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end


@implementation PDNetworkResourceProvider

- (id<PDNetworkResource>)detailResourceWithPathConfigurationBlock:(NSString * (^)(id))pathConfigurationBlock
                                      requestParametersSerializer:(id<PDRequestParametersSerializer>)requestParametersSerializer
                                                     deserializer:(id<PDDeserializer>)deserializer
{
    _PDNetworkResource *resource = [[_PDNetworkResource alloc] initWithPathConfigurationBlock:pathConfigurationBlock
                                                                  requestParametersSerializer:requestParametersSerializer
                                                                                 deserializer:deserializer
                                                                                     HTTPVerb:@"GET"];
    return resource;
}

- (id<PDNetworkResource>)collectionResourceWithPathConfigurationBlock:(NSString * (^)(id))pathConfigurationBlock
                                          requestParametersSerializer:(id<PDRequestParametersSerializer>)requestParametersSerializer
                                                         deserializer:(id<PDDeserializer>)deserializer
{
    _PDNetworkResource *resource = [[_PDNetworkResource alloc] initWithPathConfigurationBlock:pathConfigurationBlock
                                                                  requestParametersSerializer:requestParametersSerializer
                                                                                 deserializer:deserializer
                                                                                     HTTPVerb:@"GET"];
    return resource;
}

- (id<PDNetworkResource>)creationResourceWithPathConfigurationBlock:(NSString * (^)(id))pathConfigurationBlock
                                        requestParametersSerializer:(id<PDRequestParametersSerializer>)requestParametersSerializer
                                                       deserializer:(id<PDDeserializer>)deserializer
{
    _PDNetworkResource *resource = [[_PDNetworkResource alloc] initWithPathConfigurationBlock:pathConfigurationBlock
                                                                  requestParametersSerializer:requestParametersSerializer
                                                                                 deserializer:deserializer
                                                                                     HTTPVerb:@"POST"];
    return resource;
}

- (id<PDNetworkResource>)deletionResourceWithPathConfigurationBlock:(NSString * (^)(id))pathConfigurationBlock
                                        requestParametersSerializer:(id<PDRequestParametersSerializer>)requestParametersSerializer
                                                       deserializer:(id<PDDeserializer>)deserializer
{
    _PDNetworkResource *resource = [[_PDNetworkResource alloc] initWithPathConfigurationBlock:pathConfigurationBlock
                                                                  requestParametersSerializer:requestParametersSerializer
                                                                                 deserializer:deserializer
                                                                                     HTTPVerb:@"DELETE"];
    return resource;
}

- (id<PDNetworkResource>)updateResourceWithPathConfigurationBlock:(NSString * (^)(id))pathConfigurationBlock
                                        requestParametersSerializer:(id<PDRequestParametersSerializer>)requestParametersSerializer
                                                       deserializer:(id<PDDeserializer>)deserializer
{
    _PDNetworkResource *resource = [[_PDNetworkResource alloc] initWithPathConfigurationBlock:pathConfigurationBlock
                                                                  requestParametersSerializer:requestParametersSerializer
                                                                                 deserializer:deserializer
                                                                                     HTTPVerb:@"PUT"];
    return resource;
}

@end
