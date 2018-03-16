# SwaggerClient::AccountsApi

All URIs are relative to *https://127.0.0.1:8090*

Method | HTTP request | Description
------------- | ------------- | -------------
[**api_v1_wallets_wallet_id_accounts_account_index_delete**](AccountsApi.md#api_v1_wallets_wallet_id_accounts_account_index_delete) | **DELETE** /api/v1/wallets/{walletId}/accounts/{accountIndex} | Deletes an Account.
[**api_v1_wallets_wallet_id_accounts_account_index_get**](AccountsApi.md#api_v1_wallets_wallet_id_accounts_account_index_get) | **GET** /api/v1/wallets/{walletId}/accounts/{accountIndex} | Retrieves a specific Account.
[**api_v1_wallets_wallet_id_accounts_account_index_put**](AccountsApi.md#api_v1_wallets_wallet_id_accounts_account_index_put) | **PUT** /api/v1/wallets/{walletId}/accounts/{accountIndex} | Update an Account for the given Wallet.
[**api_v1_wallets_wallet_id_accounts_get**](AccountsApi.md#api_v1_wallets_wallet_id_accounts_get) | **GET** /api/v1/wallets/{walletId}/accounts | Retrieves the full list of Accounts.
[**api_v1_wallets_wallet_id_accounts_post**](AccountsApi.md#api_v1_wallets_wallet_id_accounts_post) | **POST** /api/v1/wallets/{walletId}/accounts | Creates a new Account for the given Wallet.


# **api_v1_wallets_wallet_id_accounts_account_index_delete**
> api_v1_wallets_wallet_id_accounts_account_index_delete(wallet_id, account_index)

Deletes an Account.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::AccountsApi.new

wallet_id = "wallet_id_example" # String | 

account_index = 56 # Integer | 


begin
  #Deletes an Account.
  api_instance.api_v1_wallets_wallet_id_accounts_account_index_delete(wallet_id, account_index)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AccountsApi->api_v1_wallets_wallet_id_accounts_account_index_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **wallet_id** | **String**|  | 
 **account_index** | **Integer**|  | 

### Return type

nil (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json;charset=utf-8



# **api_v1_wallets_wallet_id_accounts_account_index_get**
> WalletResponseAccount api_v1_wallets_wallet_id_accounts_account_index_get(wallet_id, account_index)

Retrieves a specific Account.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::AccountsApi.new

wallet_id = "wallet_id_example" # String | 

account_index = 56 # Integer | 


begin
  #Retrieves a specific Account.
  result = api_instance.api_v1_wallets_wallet_id_accounts_account_index_get(wallet_id, account_index)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AccountsApi->api_v1_wallets_wallet_id_accounts_account_index_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **wallet_id** | **String**|  | 
 **account_index** | **Integer**|  | 

### Return type

[**WalletResponseAccount**](WalletResponseAccount.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json;charset=utf-8



# **api_v1_wallets_wallet_id_accounts_account_index_put**
> WalletResponseAccount api_v1_wallets_wallet_id_accounts_account_index_put(wallet_id, account_index, body)

Update an Account for the given Wallet.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::AccountsApi.new

wallet_id = "wallet_id_example" # String | 

account_index = 56 # Integer | 

body = SwaggerClient::AccountUpdate.new # AccountUpdate | 


begin
  #Update an Account for the given Wallet.
  result = api_instance.api_v1_wallets_wallet_id_accounts_account_index_put(wallet_id, account_index, body)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AccountsApi->api_v1_wallets_wallet_id_accounts_account_index_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **wallet_id** | **String**|  | 
 **account_index** | **Integer**|  | 
 **body** | [**AccountUpdate**](AccountUpdate.md)|  | 

### Return type

[**WalletResponseAccount**](WalletResponseAccount.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json;charset=utf-8
 - **Accept**: application/json;charset=utf-8



# **api_v1_wallets_wallet_id_accounts_get**
> WalletResponseAccount api_v1_wallets_wallet_id_accounts_get(wallet_id, opts)

Retrieves the full list of Accounts.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::AccountsApi.new

wallet_id = "wallet_id_example" # String | 

opts = { 
  page: 1, # Integer | The page number to fetch for this request. The minimum is **1**.  If nothing is specified, **this value defaults to 1** and always shows the first entries in the requested collection. 
  per_page: 10 # Integer | The number of entries to display for each page. The minimum is **1**, whereas the maximum is **50**. If nothing is specified, **this value defaults to 10**. 
}

begin
  #Retrieves the full list of Accounts.
  result = api_instance.api_v1_wallets_wallet_id_accounts_get(wallet_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AccountsApi->api_v1_wallets_wallet_id_accounts_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **wallet_id** | **String**|  | 
 **page** | **Integer**| The page number to fetch for this request. The minimum is **1**.  If nothing is specified, **this value defaults to 1** and always shows the first entries in the requested collection.  | [optional] [default to 1]
 **per_page** | **Integer**| The number of entries to display for each page. The minimum is **1**, whereas the maximum is **50**. If nothing is specified, **this value defaults to 10**.  | [optional] [default to 10]

### Return type

[**WalletResponseAccount**](WalletResponseAccount.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json;charset=utf-8



# **api_v1_wallets_wallet_id_accounts_post**
> WalletResponseAccount api_v1_wallets_wallet_id_accounts_post(wallet_id, body)

Creates a new Account for the given Wallet.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::AccountsApi.new

wallet_id = "wallet_id_example" # String | 

body = SwaggerClient::NewAccount.new # NewAccount | 


begin
  #Creates a new Account for the given Wallet.
  result = api_instance.api_v1_wallets_wallet_id_accounts_post(wallet_id, body)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AccountsApi->api_v1_wallets_wallet_id_accounts_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **wallet_id** | **String**|  | 
 **body** | [**NewAccount**](NewAccount.md)|  | 

### Return type

[**WalletResponseAccount**](WalletResponseAccount.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json;charset=utf-8
 - **Accept**: application/json;charset=utf-8



