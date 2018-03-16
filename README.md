# swagger_client

SwaggerClient - the Ruby gem for the Cardano Wallet API

This is the specification for the Cardano Wallet API, automatically generated as a [Swagger](https://swagger.io/) spec from the [Servant](http://haskell-servant.readthedocs.io/en/stable/) API of [Cardano](https://github.com/input-output-hk/cardano-sl).  Software Version   | Git Revision -------------------|------------------- cardano-sl:0 | 07e1b7860fec59f94844a3f424603af07da54978  > **Warning**: This version is currently a **BETA-release** which is still under testing before its final stable release. Should you encounter any issues or have any remarks, please let us know; your feedback is highly appreciated.   Getting Started ===============  In the following examples, we will use *curl* to illustrate request to an API running on the default port **8090**.  Please note that wallet web API uses TLS for secure communication. Requests to the API need to send a client CA certificate that was used when launching the node and identifies the client as being permitted to invoke the server API.  Creating a New Wallet ---------------------  You can create your first wallet using the `POST /api/v1/wallets` endpoint as follow:  ``` curl -X POST https://localhost:8090/api/v1/wallets                     \\      -H \"Content-Type: application/json; charset=utf-8\"                \\      -H \"Accept: application/json; charset=utf-8\"                      \\      --cacert ./scripts/tls-files/ca.crt                               \\      -d '{                                                             \\   \"operation\": \"create\",                                               \\   \"backupPhrase\": [\"squirrel\", \"material\", \"silly\", \"twice\", \"direct\", \\     \"slush\", \"pistol\", \"razor\", \"become\", \"junk\", \"kingdom\", \"flee\"],  \\   \"assuranceLevel\": \"normal\",                                          \\   \"name\": \"MyFirstWallet\"                                              \\ }' ```  > **Warning**: Those 12 mnemonic words given for the backup phrase act as an example. **Do not** use them on a production system. See the section below about mnemonic codes for more information.  As a response, the API provides you with a wallet `id` used in subsequent requests to uniquely identity the wallet. Make sure to store it / write it down. Note that every API response is [jsend-compliant](https://labs.omniti.com/labs/jsend); Cardano also augments responses with meta-data specific to pagination. More details in the section below about *Pagination*.  ```json {     \"status\": \"success\",     \"data\": {         \"id\": \"Ae2tdPwUPE...8V3AVTnqGZ\",         \"name\": \"MyFirstWallet\",         \"balance\": 0     },     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 1,             \"totalEntries\": 1         }     } } ```  You have just created your first wallet. Information about this wallet can be retrieved using the `GET /api/v1/wallets/{walletId}` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}} \\      -H \"Accept: application/json; charset=utf-8\"              \\      --cacert ./scripts/tls-files/ca.crt                       \\ ```  Receiving Money ---------------  To receive money from other users you should provide your address. This address can be obtained from an account. Each wallet contains at least one account, you can think of account as a pocket inside of your wallet. Besides, you can view all existing accounts of a wallet by using the `GET /api/v1/wallets/{{walletId}}/accounts` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}}/accounts?page=1&per_page=10 \\      -H \"Accept: application/json; charset=utf-8\"                                          \\      --cacert ./scripts/tls-files/ca.crt                                                   \\ ```  Since you have, for now, only a single wallet, you'll see something like this:  ```json {     \"status\": \"success\",     \"data\": [         {             \"index\": 2147483648,             \"addresses\": [                 \"DdzFFzCqrh...fXSru1pdFE\"             ],             \"amount\": 0,             \"name\": \"Initial account\",             \"walletId\": \"Ae2tdPwUPE...8V3AVTnqGZ\"         }     ],     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 10,             \"totalEntries\": 1         }     } } ```  Each account has at least one address, all listed under the `addresses` field. You can communicate one of these addresses to receive money on the associated account.   Sending Money -------------  In order to send money from one of your account to another address, you can create a new payment transaction using the `POST /api/v1/transactions` endpoint as follow:  ``` curl -X POST https://localhost:8090/api/v1/transactions \\      -H \"Content-Type: application/json; charset=utf-8\" \\      -H \"Accept: application/json; charset=utf-8\"       \\      --cacert ./scripts/tls-files/ca.crt                \\      -d '{                                              \\   \"destinations\": [{                                    \\     \"amount\": 14,                                       \\     \"address\": \"A7k5bz1QR2...Tx561NNmfF\"                \\   }],                                                   \\   \"source\": {                                           \\     \"accountIndex\": 0,                                  \\     \"walletId\": \"Ae2tdPwUPE...8V3AVTnqGZ\"               \\   }                                                     \\ }' ```  Note that, in order to perform a transaction, you need to have some existing coins on the source account! Beside, the Cardano API is designed to accomodate multiple recipients payments out-of-the-box; notice how `destinations` is a list of addresses.  When the transaction succeeds, funds are becomes unavailable from the sources addresses, and available to the destinations in a short delay.  Note that, you can at any time see the status of your wallets by using the `GET /api/v1/transactions/{{walletId}}` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}}?account_index=0  \\      -H \"Accept: application/json; charset=utf-8\"                               \\      --cacert ./scripts/tls-files/ca.crt                                        \\ ```  We have here constrainted the request to a specific account, with our previous transaction the output should look roughly similar to this:  ```json {     \"status\": \"success\",     \"data\": [         {             \"amount\": 14,             \"inputs\": [{               \"amount\": 14,               \"address\": \"DdzFFzCqrh...fXSru1pdFE\"             }],             \"direction\": \"outgoing\",             \"outputs\": [{               \"amount\": 14,               \"address\": \"A7k5bz1QR2...Tx561NNmfF\"             }],             \"confirmations\": 42,             \"id\": \"43zkUzCVi7...TT31uDfEF7\",             \"type\": \"local\"         }     ],     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 10,             \"totalEntries\": 1         }     } } ```  In addition, and because it is not possible to _preview_ a transaction, one can lookup a transaction's fees using the `POST /api/v1/transactions/fees` endpoint to get an estimation of those fees.   Pagination ==========  **All GET requests of the API are paginated by default**. Whilst this can be a source of surprise, is the best way of ensuring the performance of GET requests is not affected by the size of the data storage.  Version `V1` introduced a different way of requesting information to the API. In particular, GET requests which returns a _collection_ (i.e. typically a JSON array of resources) lists extra parameters which can be used to modify the shape of the response. In particular, those are:  * `page`: (Default value: **1**). * `per_page`: (Default value: **10**)  For a more accurate description, see the section `Parameters` of each GET request, but as a brief overview the first two control how many results and which results to access in a paginated request.   Filtering and sorting =====================  `GET` endpoints which list collection of resources supports filters & sort operations, which are clearly marked in the swagger docs with the `FILTER` or `SORT` labels. The query format is quite simple, and it goes this way:   Filter operators ----------------  | Operator | Description                                                               | Example                | |----------|---------------------------------------------------------------------------|------------------------| | -        | If **no operator** is passed, this is equivalent to `EQ` (see below).     | `balance=10`           | | `EQ`     | Retrieves the resources with index _equal_ to the one provided.           | `balance=EQ[10]`       | | `LT`     | Retrieves the resources with index _less than_ the one provided.          | `balance=LT[10]`       | | `LTE`    | Retrieves the resources with index _less than equal_ the one provided.    | `balance=LTE[10]`      | | `GT`     | Retrieves the resources with index _greater than_ the one provided.       | `balance=GT[10]`       | | `GTE`    | Retrieves the resources with index _greater than equal_ the one provided. | `balance=GTE[10]`      | | `RANGE`  | Retrieves the resources with index _within the inclusive range_ [k,k].    | `balance=RANGE[10,20]` |  Sort operators --------------  | Operator | Description                                                               | Example                | |----------|---------------------------------------------------------------------------|------------------------| | `ASC`    | Sorts the resources with the given index in _ascending_ order.            | `sort_by=ASC[balance]` | | `DES`    | Sorts the resources with the given index in _descending_ order.           | `sort_by=DES[balance]` | | -        | If **no operator** is passed, this is equivalent to `DES` (see above).    | `sort_by=balance`      |   Errors ======  In case a request cannot be served by the API, a non-2xx HTTP response will be issue, together with a [JSend-compliant](https://labs.omniti.com/labs/jsend) JSON Object describing the error in detail together with a numeric error code which can be used by API consumers to implement proper error handling in their application. For example, here's a typical error which might be issued:  ``` json {     \"status\": \"error\",     \"diagnostic\": {},     \"message\": \"WalletNotFound\" } ```  Existing wallet errors ----------------------  Error Name | HTTP Error code | Example -----------|-----------------|--------- `NotEnoughMoney`|403|`{\"status\":\"error\",\"diagnostic\":{\"needMore\":1400},\"message\":\"NotEnoughMoney\"}` `OutputIsRedeem`|403|`{\"status\":\"error\",\"diagnostic\":{\"address\":\"b10b24203f1f0cadffcfd16277125cf7f3ad598983bef9123be80d93\"},\"message\":\"OutputIsRedeem\"}` `SomeOtherError`|418|`{\"status\":\"error\",\"diagnostic\":{\"foo\":\"foo\",\"bar\":14},\"message\":\"SomeOtherError\"}` `MigrationFailed`|422|`{\"status\":\"error\",\"diagnostic\":{\"description\":\"migration\"},\"message\":\"MigrationFailed\"}` `JSONValidationFailed`|400|`{\"status\":\"error\",\"diagnostic\":{\"validationError\":\"Expected String, found Null.\"},\"message\":\"JSONValidationFailed\"}` `WalletNotFound`|404|`{\"status\":\"error\",\"diagnostic\":{},\"message\":\"WalletNotFound\"}`   Mnemonic Codes ==============  The full list of accepted mnemonic codes to secure a wallet is defined by the [BIP-39 specifications](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki). Note that picking up 12 random words from the list **is not enough** and leads to poor security. Make sure to carefully follow the steps described in the protocol when you generate words for a new wallet.   Versioning & Legacy ===================  The API is **versioned**, meaning that is possible to access different versions of the API by adding the _version number_ in the URL.  **For the sake of backward compatibility, we expose the legacy version of the API, available simply as unversioned endpoints.**  This means that _omitting_ the version number would call the old version of the API. Deprecated endpoints are currently grouped under an appropriate section; they would be removed in upcoming released, if you're starting a new integration with Cardano-SL, please ignore these.  Note that Compatibility between major versions is not _guaranteed_, i.e. the request & response formats might differ.   Disable TLS (Not Recommended) -----------------------------  If needed, you can disable TLS by providing the `--no-tls` flag to the wallet or by running a wallet in debug mode with `--wallet-debug` turned on. 

This SDK is automatically generated by the [Swagger Codegen](https://github.com/swagger-api/swagger-codegen) project:

- API version: cardano-sl:0
- Package version: 1.0.0
- Build package: io.swagger.codegen.languages.RubyClientCodegen

## Installation

### Build a gem

To build the Ruby code into a gem:

```shell
gem build swagger_client.gemspec
```

Then either install the gem locally:

```shell
gem install ./swagger_client-1.0.0.gem
```
(for development, run `gem install --dev ./swagger_client-1.0.0.gem` to install the development dependencies)

or publish the gem to a gem hosting service, e.g. [RubyGems](https://rubygems.org/).

Finally add this to the Gemfile:

    gem 'swagger_client', '~> 1.0.0'

### Install from Git

If the Ruby gem is hosted at a git repository: https://github.com/GIT_USER_ID/GIT_REPO_ID, then add the following in the Gemfile:

    gem 'swagger_client', :git => 'https://github.com/GIT_USER_ID/GIT_REPO_ID.git'

### Include the Ruby code directly

Include the Ruby code directly using `-I` as follows:

```shell
ruby -Ilib script.rb
```

## Getting Started

Please follow the [installation](#installation) procedure and then run the following code:
```ruby
# Load the gem
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

## Documentation for API Endpoints

All URIs are relative to *https://127.0.0.1:8090*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*SwaggerClient::AccountsApi* | [**api_v1_wallets_wallet_id_accounts_account_index_delete**](docs/AccountsApi.md#api_v1_wallets_wallet_id_accounts_account_index_delete) | **DELETE** /api/v1/wallets/{walletId}/accounts/{accountIndex} | Deletes an Account.
*SwaggerClient::AccountsApi* | [**api_v1_wallets_wallet_id_accounts_account_index_get**](docs/AccountsApi.md#api_v1_wallets_wallet_id_accounts_account_index_get) | **GET** /api/v1/wallets/{walletId}/accounts/{accountIndex} | Retrieves a specific Account.
*SwaggerClient::AccountsApi* | [**api_v1_wallets_wallet_id_accounts_account_index_put**](docs/AccountsApi.md#api_v1_wallets_wallet_id_accounts_account_index_put) | **PUT** /api/v1/wallets/{walletId}/accounts/{accountIndex} | Update an Account for the given Wallet.
*SwaggerClient::AccountsApi* | [**api_v1_wallets_wallet_id_accounts_get**](docs/AccountsApi.md#api_v1_wallets_wallet_id_accounts_get) | **GET** /api/v1/wallets/{walletId}/accounts | Retrieves the full list of Accounts.
*SwaggerClient::AccountsApi* | [**api_v1_wallets_wallet_id_accounts_post**](docs/AccountsApi.md#api_v1_wallets_wallet_id_accounts_post) | **POST** /api/v1/wallets/{walletId}/accounts | Creates a new Account for the given Wallet.
*SwaggerClient::AddressesApi* | [**api_v1_addresses_address_validity_get**](docs/AddressesApi.md#api_v1_addresses_address_validity_get) | **GET** /api/v1/addresses/{address}/validity | Checks the validity of an address.
*SwaggerClient::AddressesApi* | [**api_v1_addresses_get**](docs/AddressesApi.md#api_v1_addresses_get) | **GET** /api/v1/addresses | Returns all the addresses.
*SwaggerClient::AddressesApi* | [**api_v1_addresses_post**](docs/AddressesApi.md#api_v1_addresses_post) | **POST** /api/v1/addresses | Creates a new Address.
*SwaggerClient::InfoApi* | [**api_v1_node_info_get**](docs/InfoApi.md#api_v1_node_info_get) | **GET** /api/v1/node-info | Retrieves the dynamic information for this node.
*SwaggerClient::SettingsApi* | [**api_v1_node_settings_get**](docs/SettingsApi.md#api_v1_node_settings_get) | **GET** /api/v1/node-settings | Retrieves the static settings for this node.
*SwaggerClient::TransactionsApi* | [**api_v1_transactions_fees_post**](docs/TransactionsApi.md#api_v1_transactions_fees_post) | **POST** /api/v1/transactions/fees | Estimate the fees which would originate from the payment.
*SwaggerClient::TransactionsApi* | [**api_v1_transactions_post**](docs/TransactionsApi.md#api_v1_transactions_post) | **POST** /api/v1/transactions | Generates a new transaction from the source to one or multiple target addresses.
*SwaggerClient::TransactionsApi* | [**api_v1_transactions_wallet_id_get**](docs/TransactionsApi.md#api_v1_transactions_wallet_id_get) | **GET** /api/v1/transactions/{walletId} | Returns the transaction history, i.e the list of all the past transactions.
*SwaggerClient::WalletsApi* | [**api_v1_wallets_get**](docs/WalletsApi.md#api_v1_wallets_get) | **GET** /api/v1/wallets | Returns all the available wallets.
*SwaggerClient::WalletsApi* | [**api_v1_wallets_post**](docs/WalletsApi.md#api_v1_wallets_post) | **POST** /api/v1/wallets | Creates a new or restores an existing Wallet.
*SwaggerClient::WalletsApi* | [**api_v1_wallets_wallet_id_delete**](docs/WalletsApi.md#api_v1_wallets_wallet_id_delete) | **DELETE** /api/v1/wallets/{walletId} | Deletes the given Wallet and all its accounts.
*SwaggerClient::WalletsApi* | [**api_v1_wallets_wallet_id_get**](docs/WalletsApi.md#api_v1_wallets_wallet_id_get) | **GET** /api/v1/wallets/{walletId} | Returns the Wallet identified by the given walletId.
*SwaggerClient::WalletsApi* | [**api_v1_wallets_wallet_id_password_put**](docs/WalletsApi.md#api_v1_wallets_wallet_id_password_put) | **PUT** /api/v1/wallets/{walletId}/password | Updates the password for the given Wallet.
*SwaggerClient::WalletsApi* | [**api_v1_wallets_wallet_id_put**](docs/WalletsApi.md#api_v1_wallets_wallet_id_put) | **PUT** /api/v1/wallets/{walletId} | Update the Wallet identified by the given walletId.


## Documentation for Models

 - [SwaggerClient::Account](docs/Account.md)
 - [SwaggerClient::AccountUpdate](docs/AccountUpdate.md)
 - [SwaggerClient::Address](docs/Address.md)
 - [SwaggerClient::AddressValidity](docs/AddressValidity.md)
 - [SwaggerClient::AssuranceLevel](docs/AssuranceLevel.md)
 - [SwaggerClient::BlockchainHeight](docs/BlockchainHeight.md)
 - [SwaggerClient::EstimatedFees](docs/EstimatedFees.md)
 - [SwaggerClient::LocalTimeDifference](docs/LocalTimeDifference.md)
 - [SwaggerClient::Metadata](docs/Metadata.md)
 - [SwaggerClient::NewAccount](docs/NewAccount.md)
 - [SwaggerClient::NewAddress](docs/NewAddress.md)
 - [SwaggerClient::NewWallet](docs/NewWallet.md)
 - [SwaggerClient::NodeInfo](docs/NodeInfo.md)
 - [SwaggerClient::NodeInfoBlockchainHeight](docs/NodeInfoBlockchainHeight.md)
 - [SwaggerClient::NodeInfoLocalBlockchainHeight](docs/NodeInfoLocalBlockchainHeight.md)
 - [SwaggerClient::NodeInfoLocalTimeDifference](docs/NodeInfoLocalTimeDifference.md)
 - [SwaggerClient::NodeInfoSyncProgress](docs/NodeInfoSyncProgress.md)
 - [SwaggerClient::NodeSettings](docs/NodeSettings.md)
 - [SwaggerClient::NodeSettingsSlotDuration](docs/NodeSettingsSlotDuration.md)
 - [SwaggerClient::NodeSettingsSoftwareInfo](docs/NodeSettingsSoftwareInfo.md)
 - [SwaggerClient::Page](docs/Page.md)
 - [SwaggerClient::PaginationMetadata](docs/PaginationMetadata.md)
 - [SwaggerClient::PasswordUpdate](docs/PasswordUpdate.md)
 - [SwaggerClient::Payment](docs/Payment.md)
 - [SwaggerClient::PaymentDistribution](docs/PaymentDistribution.md)
 - [SwaggerClient::PaymentSource](docs/PaymentSource.md)
 - [SwaggerClient::PerPage](docs/PerPage.md)
 - [SwaggerClient::ResponseStatus](docs/ResponseStatus.md)
 - [SwaggerClient::SlotDuration](docs/SlotDuration.md)
 - [SwaggerClient::SyncProgress](docs/SyncProgress.md)
 - [SwaggerClient::Transaction](docs/Transaction.md)
 - [SwaggerClient::TransactionDirection](docs/TransactionDirection.md)
 - [SwaggerClient::TransactionType](docs/TransactionType.md)
 - [SwaggerClient::V1Address](docs/V1Address.md)
 - [SwaggerClient::V1BackupPhrase](docs/V1BackupPhrase.md)
 - [SwaggerClient::V1Coin](docs/V1Coin.md)
 - [SwaggerClient::V1InputSelectionPolicy](docs/V1InputSelectionPolicy.md)
 - [SwaggerClient::V1PassPhrase](docs/V1PassPhrase.md)
 - [SwaggerClient::V1SoftwareVersion](docs/V1SoftwareVersion.md)
 - [SwaggerClient::Version](docs/Version.md)
 - [SwaggerClient::Wallet](docs/Wallet.md)
 - [SwaggerClient::WalletAddress](docs/WalletAddress.md)
 - [SwaggerClient::WalletId](docs/WalletId.md)
 - [SwaggerClient::WalletOperation](docs/WalletOperation.md)
 - [SwaggerClient::WalletResponseAccount](docs/WalletResponseAccount.md)
 - [SwaggerClient::WalletResponseAddress](docs/WalletResponseAddress.md)
 - [SwaggerClient::WalletResponseAddressValidity](docs/WalletResponseAddressValidity.md)
 - [SwaggerClient::WalletResponseEstimatedFees](docs/WalletResponseEstimatedFees.md)
 - [SwaggerClient::WalletResponseNodeInfo](docs/WalletResponseNodeInfo.md)
 - [SwaggerClient::WalletResponseNodeSettings](docs/WalletResponseNodeSettings.md)
 - [SwaggerClient::WalletResponseTransaction](docs/WalletResponseTransaction.md)
 - [SwaggerClient::WalletResponseWallet](docs/WalletResponseWallet.md)
 - [SwaggerClient::WalletResponseWalletAddress](docs/WalletResponseWalletAddress.md)
 - [SwaggerClient::WalletUpdate](docs/WalletUpdate.md)


## Documentation for Authorization

 All endpoints do not require authorization.

