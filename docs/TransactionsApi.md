# SwaggerClient::TransactionsApi

All URIs are relative to *https://127.0.0.1:8090*

Method | HTTP request | Description
------------- | ------------- | -------------
[**api_v1_transactions_fees_post**](TransactionsApi.md#api_v1_transactions_fees_post) | **POST** /api/v1/transactions/fees | Estimate the fees which would originate from the payment.
[**api_v1_transactions_post**](TransactionsApi.md#api_v1_transactions_post) | **POST** /api/v1/transactions | Generates a new transaction from the source to one or multiple target addresses.
[**api_v1_transactions_wallet_id_get**](TransactionsApi.md#api_v1_transactions_wallet_id_get) | **GET** /api/v1/transactions/{walletId} | Returns the transaction history, i.e the list of all the past transactions.


# **api_v1_transactions_fees_post**
> WalletResponseEstimatedFees api_v1_transactions_fees_post(body)

Estimate the fees which would originate from the payment.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::TransactionsApi.new

body = SwaggerClient::Payment.new # Payment | 


begin
  #Estimate the fees which would originate from the payment.
  result = api_instance.api_v1_transactions_fees_post(body)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TransactionsApi->api_v1_transactions_fees_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Payment**](Payment.md)|  | 

### Return type

[**WalletResponseEstimatedFees**](WalletResponseEstimatedFees.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json;charset=utf-8
 - **Accept**: application/json;charset=utf-8



# **api_v1_transactions_post**
> WalletResponseTransaction api_v1_transactions_post(body)

Generates a new transaction from the source to one or multiple target addresses.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::TransactionsApi.new

body = SwaggerClient::Payment.new # Payment | 


begin
  #Generates a new transaction from the source to one or multiple target addresses.
  result = api_instance.api_v1_transactions_post(body)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TransactionsApi->api_v1_transactions_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | [**Payment**](Payment.md)|  | 

### Return type

[**WalletResponseTransaction**](WalletResponseTransaction.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json;charset=utf-8
 - **Accept**: application/json;charset=utf-8



# **api_v1_transactions_wallet_id_get**
> WalletResponseTransaction api_v1_transactions_wallet_id_get(wallet_id, opts)

Returns the transaction history, i.e the list of all the past transactions.

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::TransactionsApi.new

wallet_id = "wallet_id_example" # String | 

opts = { 
  account_index: 56, # Integer | 
  address: "address_example", # String | 
  page: 1, # Integer | The page number to fetch for this request. The minimum is **1**.  If nothing is specified, **this value defaults to 1** and always shows the first entries in the requested collection. 
  per_page: 10 # Integer | The number of entries to display for each page. The minimum is **1**, whereas the maximum is **50**. If nothing is specified, **this value defaults to 10**. 
}

begin
  #Returns the transaction history, i.e the list of all the past transactions.
  result = api_instance.api_v1_transactions_wallet_id_get(wallet_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling TransactionsApi->api_v1_transactions_wallet_id_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **wallet_id** | **String**|  | 
 **account_index** | **Integer**|  | [optional] 
 **address** | **String**|  | [optional] 
 **page** | **Integer**| The page number to fetch for this request. The minimum is **1**.  If nothing is specified, **this value defaults to 1** and always shows the first entries in the requested collection.  | [optional] [default to 1]
 **per_page** | **Integer**| The number of entries to display for each page. The minimum is **1**, whereas the maximum is **50**. If nothing is specified, **this value defaults to 10**.  | [optional] [default to 10]

### Return type

[**WalletResponseTransaction**](WalletResponseTransaction.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json;charset=utf-8



