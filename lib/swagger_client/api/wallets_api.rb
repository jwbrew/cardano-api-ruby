=begin
#Cardano Wallet API

#This is the specification for the Cardano Wallet API, automatically generated as a [Swagger](https://swagger.io/) spec from the [Servant](http://haskell-servant.readthedocs.io/en/stable/) API of [Cardano](https://github.com/input-output-hk/cardano-sl).  Software Version   | Git Revision -------------------|------------------- cardano-sl:0 | 07e1b7860fec59f94844a3f424603af07da54978  > **Warning**: This version is currently a **BETA-release** which is still under testing before its final stable release. Should you encounter any issues or have any remarks, please let us know; your feedback is highly appreciated.   Getting Started ===============  In the following examples, we will use *curl* to illustrate request to an API running on the default port **8090**.  Please note that wallet web API uses TLS for secure communication. Requests to the API need to send a client CA certificate that was used when launching the node and identifies the client as being permitted to invoke the server API.  Creating a New Wallet ---------------------  You can create your first wallet using the `POST /api/v1/wallets` endpoint as follow:  ``` curl -X POST https://localhost:8090/api/v1/wallets                     \\      -H \"Content-Type: application/json; charset=utf-8\"                \\      -H \"Accept: application/json; charset=utf-8\"                      \\      --cacert ./scripts/tls-files/ca.crt                               \\      -d '{                                                             \\   \"operation\": \"create\",                                               \\   \"backupPhrase\": [\"squirrel\", \"material\", \"silly\", \"twice\", \"direct\", \\     \"slush\", \"pistol\", \"razor\", \"become\", \"junk\", \"kingdom\", \"flee\"],  \\   \"assuranceLevel\": \"normal\",                                          \\   \"name\": \"MyFirstWallet\"                                              \\ }' ```  > **Warning**: Those 12 mnemonic words given for the backup phrase act as an example. **Do not** use them on a production system. See the section below about mnemonic codes for more information.  As a response, the API provides you with a wallet `id` used in subsequent requests to uniquely identity the wallet. Make sure to store it / write it down. Note that every API response is [jsend-compliant](https://labs.omniti.com/labs/jsend); Cardano also augments responses with meta-data specific to pagination. More details in the section below about *Pagination*.  ```json {     \"status\": \"success\",     \"data\": {         \"id\": \"Ae2tdPwUPE...8V3AVTnqGZ\",         \"name\": \"MyFirstWallet\",         \"balance\": 0     },     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 1,             \"totalEntries\": 1         }     } } ```  You have just created your first wallet. Information about this wallet can be retrieved using the `GET /api/v1/wallets/{walletId}` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}} \\      -H \"Accept: application/json; charset=utf-8\"              \\      --cacert ./scripts/tls-files/ca.crt                       \\ ```  Receiving Money ---------------  To receive money from other users you should provide your address. This address can be obtained from an account. Each wallet contains at least one account, you can think of account as a pocket inside of your wallet. Besides, you can view all existing accounts of a wallet by using the `GET /api/v1/wallets/{{walletId}}/accounts` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}}/accounts?page=1&per_page=10 \\      -H \"Accept: application/json; charset=utf-8\"                                          \\      --cacert ./scripts/tls-files/ca.crt                                                   \\ ```  Since you have, for now, only a single wallet, you'll see something like this:  ```json {     \"status\": \"success\",     \"data\": [         {             \"index\": 2147483648,             \"addresses\": [                 \"DdzFFzCqrh...fXSru1pdFE\"             ],             \"amount\": 0,             \"name\": \"Initial account\",             \"walletId\": \"Ae2tdPwUPE...8V3AVTnqGZ\"         }     ],     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 10,             \"totalEntries\": 1         }     } } ```  Each account has at least one address, all listed under the `addresses` field. You can communicate one of these addresses to receive money on the associated account.   Sending Money -------------  In order to send money from one of your account to another address, you can create a new payment transaction using the `POST /api/v1/transactions` endpoint as follow:  ``` curl -X POST https://localhost:8090/api/v1/transactions \\      -H \"Content-Type: application/json; charset=utf-8\" \\      -H \"Accept: application/json; charset=utf-8\"       \\      --cacert ./scripts/tls-files/ca.crt                \\      -d '{                                              \\   \"destinations\": [{                                    \\     \"amount\": 14,                                       \\     \"address\": \"A7k5bz1QR2...Tx561NNmfF\"                \\   }],                                                   \\   \"source\": {                                           \\     \"accountIndex\": 0,                                  \\     \"walletId\": \"Ae2tdPwUPE...8V3AVTnqGZ\"               \\   }                                                     \\ }' ```  Note that, in order to perform a transaction, you need to have some existing coins on the source account! Beside, the Cardano API is designed to accomodate multiple recipients payments out-of-the-box; notice how `destinations` is a list of addresses.  When the transaction succeeds, funds are becomes unavailable from the sources addresses, and available to the destinations in a short delay.  Note that, you can at any time see the status of your wallets by using the `GET /api/v1/transactions/{{walletId}}` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}}?account_index=0  \\      -H \"Accept: application/json; charset=utf-8\"                               \\      --cacert ./scripts/tls-files/ca.crt                                        \\ ```  We have here constrainted the request to a specific account, with our previous transaction the output should look roughly similar to this:  ```json {     \"status\": \"success\",     \"data\": [         {             \"amount\": 14,             \"inputs\": [{               \"amount\": 14,               \"address\": \"DdzFFzCqrh...fXSru1pdFE\"             }],             \"direction\": \"outgoing\",             \"outputs\": [{               \"amount\": 14,               \"address\": \"A7k5bz1QR2...Tx561NNmfF\"             }],             \"confirmations\": 42,             \"id\": \"43zkUzCVi7...TT31uDfEF7\",             \"type\": \"local\"         }     ],     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 10,             \"totalEntries\": 1         }     } } ```  In addition, and because it is not possible to _preview_ a transaction, one can lookup a transaction's fees using the `POST /api/v1/transactions/fees` endpoint to get an estimation of those fees.   Pagination ==========  **All GET requests of the API are paginated by default**. Whilst this can be a source of surprise, is the best way of ensuring the performance of GET requests is not affected by the size of the data storage.  Version `V1` introduced a different way of requesting information to the API. In particular, GET requests which returns a _collection_ (i.e. typically a JSON array of resources) lists extra parameters which can be used to modify the shape of the response. In particular, those are:  * `page`: (Default value: **1**). * `per_page`: (Default value: **10**)  For a more accurate description, see the section `Parameters` of each GET request, but as a brief overview the first two control how many results and which results to access in a paginated request.   Filtering and sorting =====================  `GET` endpoints which list collection of resources supports filters & sort operations, which are clearly marked in the swagger docs with the `FILTER` or `SORT` labels. The query format is quite simple, and it goes this way:   Filter operators ----------------  | Operator | Description                                                               | Example                | |----------|---------------------------------------------------------------------------|------------------------| | -        | If **no operator** is passed, this is equivalent to `EQ` (see below).     | `balance=10`           | | `EQ`     | Retrieves the resources with index _equal_ to the one provided.           | `balance=EQ[10]`       | | `LT`     | Retrieves the resources with index _less than_ the one provided.          | `balance=LT[10]`       | | `LTE`    | Retrieves the resources with index _less than equal_ the one provided.    | `balance=LTE[10]`      | | `GT`     | Retrieves the resources with index _greater than_ the one provided.       | `balance=GT[10]`       | | `GTE`    | Retrieves the resources with index _greater than equal_ the one provided. | `balance=GTE[10]`      | | `RANGE`  | Retrieves the resources with index _within the inclusive range_ [k,k].    | `balance=RANGE[10,20]` |  Sort operators --------------  | Operator | Description                                                               | Example                | |----------|---------------------------------------------------------------------------|------------------------| | `ASC`    | Sorts the resources with the given index in _ascending_ order.            | `sort_by=ASC[balance]` | | `DES`    | Sorts the resources with the given index in _descending_ order.           | `sort_by=DES[balance]` | | -        | If **no operator** is passed, this is equivalent to `DES` (see above).    | `sort_by=balance`      |   Errors ======  In case a request cannot be served by the API, a non-2xx HTTP response will be issue, together with a [JSend-compliant](https://labs.omniti.com/labs/jsend) JSON Object describing the error in detail together with a numeric error code which can be used by API consumers to implement proper error handling in their application. For example, here's a typical error which might be issued:  ``` json {     \"status\": \"error\",     \"diagnostic\": {},     \"message\": \"WalletNotFound\" } ```  Existing wallet errors ----------------------  Error Name | HTTP Error code | Example -----------|-----------------|--------- `NotEnoughMoney`|403|`{\"status\":\"error\",\"diagnostic\":{\"needMore\":1400},\"message\":\"NotEnoughMoney\"}` `OutputIsRedeem`|403|`{\"status\":\"error\",\"diagnostic\":{\"address\":\"b10b24203f1f0cadffcfd16277125cf7f3ad598983bef9123be80d93\"},\"message\":\"OutputIsRedeem\"}` `SomeOtherError`|418|`{\"status\":\"error\",\"diagnostic\":{\"foo\":\"foo\",\"bar\":14},\"message\":\"SomeOtherError\"}` `MigrationFailed`|422|`{\"status\":\"error\",\"diagnostic\":{\"description\":\"migration\"},\"message\":\"MigrationFailed\"}` `JSONValidationFailed`|400|`{\"status\":\"error\",\"diagnostic\":{\"validationError\":\"Expected String, found Null.\"},\"message\":\"JSONValidationFailed\"}` `WalletNotFound`|404|`{\"status\":\"error\",\"diagnostic\":{},\"message\":\"WalletNotFound\"}`   Mnemonic Codes ==============  The full list of accepted mnemonic codes to secure a wallet is defined by the [BIP-39 specifications](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki). Note that picking up 12 random words from the list **is not enough** and leads to poor security. Make sure to carefully follow the steps described in the protocol when you generate words for a new wallet.   Versioning & Legacy ===================  The API is **versioned**, meaning that is possible to access different versions of the API by adding the _version number_ in the URL.  **For the sake of backward compatibility, we expose the legacy version of the API, available simply as unversioned endpoints.**  This means that _omitting_ the version number would call the old version of the API. Deprecated endpoints are currently grouped under an appropriate section; they would be removed in upcoming released, if you're starting a new integration with Cardano-SL, please ignore these.  Note that Compatibility between major versions is not _guaranteed_, i.e. the request & response formats might differ.   Disable TLS (Not Recommended) -----------------------------  If needed, you can disable TLS by providing the `--no-tls` flag to the wallet or by running a wallet in debug mode with `--wallet-debug` turned on. 

OpenAPI spec version: cardano-sl:0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require "uri"

module SwaggerClient
  class WalletsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end

    # Returns all the available wallets.
    # 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :page The page number to fetch for this request. The minimum is **1**.  If nothing is specified, **this value defaults to 1** and always shows the first entries in the requested collection.  (default to 1)
    # @option opts [Integer] :per_page The number of entries to display for each page. The minimum is **1**, whereas the maximum is **50**. If nothing is specified, **this value defaults to 10**.  (default to 10)
    # @option opts [String] :wallet_id A **FILTER** operation on a Wallet.
    # @option opts [String] :balance A **FILTER** operation on a Wallet.
    # @option opts [String] :sort_by A **SORT** operation on this Wallet. Allowed keys: &#x60;balance&#x60;. 
    # @return [WalletResponseWallet]
    def api_v1_wallets_get(opts = {})
      data, _status_code, _headers = api_v1_wallets_get_with_http_info(opts)
      return data
    end

    # Returns all the available wallets.
    # 
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :page The page number to fetch for this request. The minimum is **1**.  If nothing is specified, **this value defaults to 1** and always shows the first entries in the requested collection. 
    # @option opts [Integer] :per_page The number of entries to display for each page. The minimum is **1**, whereas the maximum is **50**. If nothing is specified, **this value defaults to 10**. 
    # @option opts [String] :wallet_id A **FILTER** operation on a Wallet.
    # @option opts [String] :balance A **FILTER** operation on a Wallet.
    # @option opts [String] :sort_by A **SORT** operation on this Wallet. Allowed keys: &#x60;balance&#x60;. 
    # @return [Array<(WalletResponseWallet, Fixnum, Hash)>] WalletResponseWallet data, response status code and response headers
    def api_v1_wallets_get_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WalletsApi.api_v1_wallets_get ..."
      end
      if @api_client.config.client_side_validation && !opts[:'page'].nil? && opts[:'page'] < 1
        fail ArgumentError, 'invalid value for "opts[:"page"]" when calling WalletsApi.api_v1_wallets_get, must be greater than or equal to 1.'
      end

      if @api_client.config.client_side_validation && !opts[:'per_page'].nil? && opts[:'per_page'] > 50
        fail ArgumentError, 'invalid value for "opts[:"per_page"]" when calling WalletsApi.api_v1_wallets_get, must be smaller than or equal to 50.'
      end

      if @api_client.config.client_side_validation && !opts[:'per_page'].nil? && opts[:'per_page'] < 1
        fail ArgumentError, 'invalid value for "opts[:"per_page"]" when calling WalletsApi.api_v1_wallets_get, must be greater than or equal to 1.'
      end

      # resource path
      local_var_path = "/api/v1/wallets"

      # query parameters
      query_params = {}
      query_params[:'page'] = opts[:'page'] if !opts[:'page'].nil?
      query_params[:'per_page'] = opts[:'per_page'] if !opts[:'per_page'].nil?
      query_params[:'wallet_id'] = opts[:'wallet_id'] if !opts[:'wallet_id'].nil?
      query_params[:'balance'] = opts[:'balance'] if !opts[:'balance'].nil?
      query_params[:'sort_by'] = opts[:'sort_by'] if !opts[:'sort_by'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=utf-8'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'WalletResponseWallet')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WalletsApi#api_v1_wallets_get\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Creates a new or restores an existing Wallet.
    # 
    # @param body 
    # @param [Hash] opts the optional parameters
    # @return [WalletResponseWallet]
    def api_v1_wallets_post(body, opts = {})
      data, _status_code, _headers = api_v1_wallets_post_with_http_info(body, opts)
      return data
    end

    # Creates a new or restores an existing Wallet.
    # 
    # @param body 
    # @param [Hash] opts the optional parameters
    # @return [Array<(WalletResponseWallet, Fixnum, Hash)>] WalletResponseWallet data, response status code and response headers
    def api_v1_wallets_post_with_http_info(body, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WalletsApi.api_v1_wallets_post ..."
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling WalletsApi.api_v1_wallets_post"
      end
      # resource path
      local_var_path = "/api/v1/wallets"

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json;charset=utf-8'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(body)
      auth_names = []
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'WalletResponseWallet')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WalletsApi#api_v1_wallets_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Deletes the given Wallet and all its accounts.
    # 
    # @param wallet_id 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def api_v1_wallets_wallet_id_delete(wallet_id, opts = {})
      api_v1_wallets_wallet_id_delete_with_http_info(wallet_id, opts)
      return nil
    end

    # Deletes the given Wallet and all its accounts.
    # 
    # @param wallet_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def api_v1_wallets_wallet_id_delete_with_http_info(wallet_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WalletsApi.api_v1_wallets_wallet_id_delete ..."
      end
      # verify the required parameter 'wallet_id' is set
      if @api_client.config.client_side_validation && wallet_id.nil?
        fail ArgumentError, "Missing the required parameter 'wallet_id' when calling WalletsApi.api_v1_wallets_wallet_id_delete"
      end
      # resource path
      local_var_path = "/api/v1/wallets/{walletId}".sub('{' + 'walletId' + '}', wallet_id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=utf-8'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WalletsApi#api_v1_wallets_wallet_id_delete\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Returns the Wallet identified by the given walletId.
    # 
    # @param wallet_id 
    # @param [Hash] opts the optional parameters
    # @return [WalletResponseWallet]
    def api_v1_wallets_wallet_id_get(wallet_id, opts = {})
      data, _status_code, _headers = api_v1_wallets_wallet_id_get_with_http_info(wallet_id, opts)
      return data
    end

    # Returns the Wallet identified by the given walletId.
    # 
    # @param wallet_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(WalletResponseWallet, Fixnum, Hash)>] WalletResponseWallet data, response status code and response headers
    def api_v1_wallets_wallet_id_get_with_http_info(wallet_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WalletsApi.api_v1_wallets_wallet_id_get ..."
      end
      # verify the required parameter 'wallet_id' is set
      if @api_client.config.client_side_validation && wallet_id.nil?
        fail ArgumentError, "Missing the required parameter 'wallet_id' when calling WalletsApi.api_v1_wallets_wallet_id_get"
      end
      # resource path
      local_var_path = "/api/v1/wallets/{walletId}".sub('{' + 'walletId' + '}', wallet_id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=utf-8'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = []
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'WalletResponseWallet')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WalletsApi#api_v1_wallets_wallet_id_get\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Updates the password for the given Wallet.
    # 
    # @param wallet_id 
    # @param body 
    # @param [Hash] opts the optional parameters
    # @return [WalletResponseWallet]
    def api_v1_wallets_wallet_id_password_put(wallet_id, body, opts = {})
      data, _status_code, _headers = api_v1_wallets_wallet_id_password_put_with_http_info(wallet_id, body, opts)
      return data
    end

    # Updates the password for the given Wallet.
    # 
    # @param wallet_id 
    # @param body 
    # @param [Hash] opts the optional parameters
    # @return [Array<(WalletResponseWallet, Fixnum, Hash)>] WalletResponseWallet data, response status code and response headers
    def api_v1_wallets_wallet_id_password_put_with_http_info(wallet_id, body, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WalletsApi.api_v1_wallets_wallet_id_password_put ..."
      end
      # verify the required parameter 'wallet_id' is set
      if @api_client.config.client_side_validation && wallet_id.nil?
        fail ArgumentError, "Missing the required parameter 'wallet_id' when calling WalletsApi.api_v1_wallets_wallet_id_password_put"
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling WalletsApi.api_v1_wallets_wallet_id_password_put"
      end
      # resource path
      local_var_path = "/api/v1/wallets/{walletId}/password".sub('{' + 'walletId' + '}', wallet_id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json;charset=utf-8'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(body)
      auth_names = []
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'WalletResponseWallet')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WalletsApi#api_v1_wallets_wallet_id_password_put\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Update the Wallet identified by the given walletId.
    # 
    # @param wallet_id 
    # @param body 
    # @param [Hash] opts the optional parameters
    # @return [WalletResponseWallet]
    def api_v1_wallets_wallet_id_put(wallet_id, body, opts = {})
      data, _status_code, _headers = api_v1_wallets_wallet_id_put_with_http_info(wallet_id, body, opts)
      return data
    end

    # Update the Wallet identified by the given walletId.
    # 
    # @param wallet_id 
    # @param body 
    # @param [Hash] opts the optional parameters
    # @return [Array<(WalletResponseWallet, Fixnum, Hash)>] WalletResponseWallet data, response status code and response headers
    def api_v1_wallets_wallet_id_put_with_http_info(wallet_id, body, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug "Calling API: WalletsApi.api_v1_wallets_wallet_id_put ..."
      end
      # verify the required parameter 'wallet_id' is set
      if @api_client.config.client_side_validation && wallet_id.nil?
        fail ArgumentError, "Missing the required parameter 'wallet_id' when calling WalletsApi.api_v1_wallets_wallet_id_put"
      end
      # verify the required parameter 'body' is set
      if @api_client.config.client_side_validation && body.nil?
        fail ArgumentError, "Missing the required parameter 'body' when calling WalletsApi.api_v1_wallets_wallet_id_put"
      end
      # resource path
      local_var_path = "/api/v1/wallets/{walletId}".sub('{' + 'walletId' + '}', wallet_id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json;charset=utf-8'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json;charset=utf-8'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(body)
      auth_names = []
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'WalletResponseWallet')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: WalletsApi#api_v1_wallets_wallet_id_put\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
