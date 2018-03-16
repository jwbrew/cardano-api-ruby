# SwaggerClient::WalletsApi

All URIs are relative to *https://127.0.0.1:8090*

Method | HTTP request | Description
------------- | ------------- | -------------
[**api_v1_wallets_get**](WalletsApi.md#api_v1_wallets_get) | **GET** /api/v1/wallets | Returns all the available wallets.
[**api_v1_wallets_post**](WalletsApi.md#api_v1_wallets_post) | **POST** /api/v1/wallets | Creates a new or restores an existing Wallet.
[**api_v1_wallets_wallet_id_delete**](WalletsApi.md#api_v1_wallets_wallet_id_delete) | **DELETE** /api/v1/wallets/{walletId} | Deletes the given Wallet and all its accounts.
[**api_v1_wallets_wallet_id_get**](WalletsApi.md#api_v1_wallets_wallet_id_get) | **GET** /api/v1/wallets/{walletId} | Returns the Wallet identified by the given walletId.
[**api_v1_wallets_wallet_id_password_put**](WalletsApi.md#api_v1_wallets_wallet_id_password_put) | **PUT** /api/v1/wallets/{walletId}/password | Updates the password for the given Wallet.
[**api_v1_wallets_wallet_id_put**](WalletsApi.md#api_v1_wallets_wallet_id_put) | **PUT** /api/v1/wallets/{walletId} | Update the Wallet identified by the given walletId.


# **api_v1_wallets_get**
> WalletResponseWallet api_v1_wallets_get(opts)

Returns all the available wallets.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::WalletsApi.new

opts = { 
  page: 1, # Integer | The page number to fetch for this request. The minimum is **1**.  If nothing is specified, **this value defaults to 1** and always shows the first entries in the requested collection. 
  per_page: 10, # Integer | The number of entries to display for each page. The minimum is **1**, whereas the maximum is **50**. If nothing is specified, **this value defaults to 10**. 
  wallet_id: "wallet_id_example", # String | A **FILTER** operation on a Wallet.
  balance: "balance_example", # String | A **FILTER** operation on a Wallet.
  sort_by: "sort_by_example" # String | A **SORT** operation on this Wallet. Allowed keys: `balance`. 
}

begin
  #Returns all the available wallets.
  result = api_instance.api_v1_wallets_get(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling WalletsApi->api_v1_wallets_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **Integer**| The page number to fetch for this request. The minimum is **1**.  If nothing is specified, **this value defaults to 1** and always shows the first entries in the requested collection.  | [optional] [default to 1]
 **per_page** | **Integer**| The number of entries to display for each page. The minimum is **1**, whereas the maximum is **50**. If nothing is specified, **this value defaults to 10**.  | [optional] [default to 10]
 **wallet_id** | **String**| A **FILTER** operation on a Wallet. | [optional] 
 **balance** | **String**| A **FILTER** operation on a Wallet. | [optional] 
 **sort_by** | **String**| A **SORT** operation on this Wallet. Allowed keys: &#x60;balance&#x60;.  | [optional] 

### Return type

[**WalletResponseWallet**](WalletResponseWallet.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json;charset=utf-8



# **api_v1_wallets_post**
> WalletResponseWallet api_v1_wallets_post(body)

Creates a new or restores an existing Wallet.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::WalletsApi.new

body = SwaggerClient::NewWallet.new # NewWallet | 


begin
  #Creates a new or restores an existing Wallet.
  result = api_instance.api_v1_wallets_post(body)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling WalletsApi->api_v1_wallets_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**NewWallet**](NewWallet.md)|  | 

### Return type

[**WalletResponseWallet**](WalletResponseWallet.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json;charset=utf-8
 - **Accept**: application/json;charset=utf-8



# **api_v1_wallets_wallet_id_delete**
> api_v1_wallets_wallet_id_delete(wallet_id)

Deletes the given Wallet and all its accounts.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::WalletsApi.new

wallet_id = "wallet_id_example" # String | 


begin
  #Deletes the given Wallet and all its accounts.
  api_instance.api_v1_wallets_wallet_id_delete(wallet_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling WalletsApi->api_v1_wallets_wallet_id_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **wallet_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json;charset=utf-8



# **api_v1_wallets_wallet_id_get**
> WalletResponseWallet api_v1_wallets_wallet_id_get(wallet_id)

Returns the Wallet identified by the given walletId.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::WalletsApi.new

wallet_id = "wallet_id_example" # String | 


begin
  #Returns the Wallet identified by the given walletId.
  result = api_instance.api_v1_wallets_wallet_id_get(wallet_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling WalletsApi->api_v1_wallets_wallet_id_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **wallet_id** | **String**|  | 

### Return type

[**WalletResponseWallet**](WalletResponseWallet.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json;charset=utf-8



# **api_v1_wallets_wallet_id_password_put**
> WalletResponseWallet api_v1_wallets_wallet_id_password_put(wallet_id, body)

Updates the password for the given Wallet.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::WalletsApi.new

wallet_id = "wallet_id_example" # String | 

body = SwaggerClient::PasswordUpdate.new # PasswordUpdate | 


begin
  #Updates the password for the given Wallet.
  result = api_instance.api_v1_wallets_wallet_id_password_put(wallet_id, body)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling WalletsApi->api_v1_wallets_wallet_id_password_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **wallet_id** | **String**|  | 
 **body** | [**PasswordUpdate**](PasswordUpdate.md)|  | 

### Return type

[**WalletResponseWallet**](WalletResponseWallet.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json;charset=utf-8
 - **Accept**: application/json;charset=utf-8



# **api_v1_wallets_wallet_id_put**
> WalletResponseWallet api_v1_wallets_wallet_id_put(wallet_id, body)

Update the Wallet identified by the given walletId.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::WalletsApi.new

wallet_id = "wallet_id_example" # String | 

body = SwaggerClient::WalletUpdate.new # WalletUpdate | 


begin
  #Update the Wallet identified by the given walletId.
  result = api_instance.api_v1_wallets_wallet_id_put(wallet_id, body)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling WalletsApi->api_v1_wallets_wallet_id_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **wallet_id** | **String**|  | 
 **body** | [**WalletUpdate**](WalletUpdate.md)|  | 

### Return type

[**WalletResponseWallet**](WalletResponseWallet.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json;charset=utf-8
 - **Accept**: application/json;charset=utf-8



