# SwaggerClient::AddressesApi

All URIs are relative to *https://127.0.0.1:8090*

Method | HTTP request | Description
------------- | ------------- | -------------
[**api_v1_addresses_address_validity_get**](AddressesApi.md#api_v1_addresses_address_validity_get) | **GET** /api/v1/addresses/{address}/validity | Checks the validity of an address.
[**api_v1_addresses_get**](AddressesApi.md#api_v1_addresses_get) | **GET** /api/v1/addresses | Returns all the addresses.
[**api_v1_addresses_post**](AddressesApi.md#api_v1_addresses_post) | **POST** /api/v1/addresses | Creates a new Address.


# **api_v1_addresses_address_validity_get**
> WalletResponseAddressValidity api_v1_addresses_address_validity_get(address)

Checks the validity of an address.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::AddressesApi.new

address = "address_example" # String | 


begin
  #Checks the validity of an address.
  result = api_instance.api_v1_addresses_address_validity_get(address)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AddressesApi->api_v1_addresses_address_validity_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **address** | **String**|  | 

### Return type

[**WalletResponseAddressValidity**](WalletResponseAddressValidity.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json;charset=utf-8



# **api_v1_addresses_get**
> WalletResponseAddress api_v1_addresses_get(opts)

Returns all the addresses.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::AddressesApi.new

opts = { 
  page: 1, # Integer | The page number to fetch for this request. The minimum is **1**.  If nothing is specified, **this value defaults to 1** and always shows the first entries in the requested collection. 
  per_page: 10 # Integer | The number of entries to display for each page. The minimum is **1**, whereas the maximum is **50**. If nothing is specified, **this value defaults to 10**. 
}

begin
  #Returns all the addresses.
  result = api_instance.api_v1_addresses_get(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AddressesApi->api_v1_addresses_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **Integer**| The page number to fetch for this request. The minimum is **1**.  If nothing is specified, **this value defaults to 1** and always shows the first entries in the requested collection.  | [optional] [default to 1]
 **per_page** | **Integer**| The number of entries to display for each page. The minimum is **1**, whereas the maximum is **50**. If nothing is specified, **this value defaults to 10**.  | [optional] [default to 10]

### Return type

[**WalletResponseAddress**](WalletResponseAddress.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json;charset=utf-8



# **api_v1_addresses_post**
> WalletResponseWalletAddress api_v1_addresses_post(body)

Creates a new Address.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::AddressesApi.new

body = SwaggerClient::NewAddress.new # NewAddress | 


begin
  #Creates a new Address.
  result = api_instance.api_v1_addresses_post(body)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AddressesApi->api_v1_addresses_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**NewAddress**](NewAddress.md)|  | 

### Return type

[**WalletResponseWalletAddress**](WalletResponseWalletAddress.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json;charset=utf-8
 - **Accept**: application/json;charset=utf-8



