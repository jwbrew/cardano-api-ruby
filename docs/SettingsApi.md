# SwaggerClient::SettingsApi

All URIs are relative to *https://127.0.0.1:8090*

Method | HTTP request | Description
------------- | ------------- | -------------
[**api_v1_node_settings_get**](SettingsApi.md#api_v1_node_settings_get) | **GET** /api/v1/node-settings | Retrieves the static settings for this node.


# **api_v1_node_settings_get**
> WalletResponseNodeSettings api_v1_node_settings_get

Retrieves the static settings for this node.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::SettingsApi.new

begin
  #Retrieves the static settings for this node.
  result = api_instance.api_v1_node_settings_get
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling SettingsApi->api_v1_node_settings_get: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**WalletResponseNodeSettings**](WalletResponseNodeSettings.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json;charset=utf-8



