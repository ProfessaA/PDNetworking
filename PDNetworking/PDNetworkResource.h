#import <Foundation/Foundation.h>


@protocol PDRequestParametersSerializer;
@protocol PDDeserializer;


@protocol PDNetworkResource <NSObject>

@property (nonatomic, readonly) NSString *HTTPMethod;
@property (nonatomic, readonly) id <PDRequestParametersSerializer> requestParametersSerializer;
@property (nonatomic, readonly) id <PDDeserializer> deserializer;
@property (nonatomic, copy) NSString * (^pathConfigurationBlock)(id requestParameters);

@end
