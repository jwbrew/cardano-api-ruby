=begin
#Cardano Wallet API

#This is the specification for the Cardano Wallet API, automatically generated as a [Swagger](https://swagger.io/) spec from the [Servant](http://haskell-servant.readthedocs.io/en/stable/) API of [Cardano](https://github.com/input-output-hk/cardano-sl).  Software Version   | Git Revision -------------------|------------------- cardano-sl:0 | 07e1b7860fec59f94844a3f424603af07da54978  > **Warning**: This version is currently a **BETA-release** which is still under testing before its final stable release. Should you encounter any issues or have any remarks, please let us know; your feedback is highly appreciated.   Getting Started ===============  In the following examples, we will use *curl* to illustrate request to an API running on the default port **8090**.  Please note that wallet web API uses TLS for secure communication. Requests to the API need to send a client CA certificate that was used when launching the node and identifies the client as being permitted to invoke the server API.  Creating a New Wallet ---------------------  You can create your first wallet using the `POST /api/v1/wallets` endpoint as follow:  ``` curl -X POST https://localhost:8090/api/v1/wallets                     \\      -H \"Content-Type: application/json; charset=utf-8\"                \\      -H \"Accept: application/json; charset=utf-8\"                      \\      --cacert ./scripts/tls-files/ca.crt                               \\      -d '{                                                             \\   \"operation\": \"create\",                                               \\   \"backupPhrase\": [\"squirrel\", \"material\", \"silly\", \"twice\", \"direct\", \\     \"slush\", \"pistol\", \"razor\", \"become\", \"junk\", \"kingdom\", \"flee\"],  \\   \"assuranceLevel\": \"normal\",                                          \\   \"name\": \"MyFirstWallet\"                                              \\ }' ```  > **Warning**: Those 12 mnemonic words given for the backup phrase act as an example. **Do not** use them on a production system. See the section below about mnemonic codes for more information.  As a response, the API provides you with a wallet `id` used in subsequent requests to uniquely identity the wallet. Make sure to store it / write it down. Note that every API response is [jsend-compliant](https://labs.omniti.com/labs/jsend); Cardano also augments responses with meta-data specific to pagination. More details in the section below about *Pagination*.  ```json {     \"status\": \"success\",     \"data\": {         \"id\": \"Ae2tdPwUPE...8V3AVTnqGZ\",         \"name\": \"MyFirstWallet\",         \"balance\": 0     },     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 1,             \"totalEntries\": 1         }     } } ```  You have just created your first wallet. Information about this wallet can be retrieved using the `GET /api/v1/wallets/{walletId}` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}} \\      -H \"Accept: application/json; charset=utf-8\"              \\      --cacert ./scripts/tls-files/ca.crt                       \\ ```  Receiving Money ---------------  To receive money from other users you should provide your address. This address can be obtained from an account. Each wallet contains at least one account, you can think of account as a pocket inside of your wallet. Besides, you can view all existing accounts of a wallet by using the `GET /api/v1/wallets/{{walletId}}/accounts` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}}/accounts?page=1&per_page=10 \\      -H \"Accept: application/json; charset=utf-8\"                                          \\      --cacert ./scripts/tls-files/ca.crt                                                   \\ ```  Since you have, for now, only a single wallet, you'll see something like this:  ```json {     \"status\": \"success\",     \"data\": [         {             \"index\": 2147483648,             \"addresses\": [                 \"DdzFFzCqrh...fXSru1pdFE\"             ],             \"amount\": 0,             \"name\": \"Initial account\",             \"walletId\": \"Ae2tdPwUPE...8V3AVTnqGZ\"         }     ],     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 10,             \"totalEntries\": 1         }     } } ```  Each account has at least one address, all listed under the `addresses` field. You can communicate one of these addresses to receive money on the associated account.   Sending Money -------------  In order to send money from one of your account to another address, you can create a new payment transaction using the `POST /api/v1/transactions` endpoint as follow:  ``` curl -X POST https://localhost:8090/api/v1/transactions \\      -H \"Content-Type: application/json; charset=utf-8\" \\      -H \"Accept: application/json; charset=utf-8\"       \\      --cacert ./scripts/tls-files/ca.crt                \\      -d '{                                              \\   \"destinations\": [{                                    \\     \"amount\": 14,                                       \\     \"address\": \"A7k5bz1QR2...Tx561NNmfF\"                \\   }],                                                   \\   \"source\": {                                           \\     \"accountIndex\": 0,                                  \\     \"walletId\": \"Ae2tdPwUPE...8V3AVTnqGZ\"               \\   }                                                     \\ }' ```  Note that, in order to perform a transaction, you need to have some existing coins on the source account! Beside, the Cardano API is designed to accomodate multiple recipients payments out-of-the-box; notice how `destinations` is a list of addresses.  When the transaction succeeds, funds are becomes unavailable from the sources addresses, and available to the destinations in a short delay.  Note that, you can at any time see the status of your wallets by using the `GET /api/v1/transactions/{{walletId}}` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}}?account_index=0  \\      -H \"Accept: application/json; charset=utf-8\"                               \\      --cacert ./scripts/tls-files/ca.crt                                        \\ ```  We have here constrainted the request to a specific account, with our previous transaction the output should look roughly similar to this:  ```json {     \"status\": \"success\",     \"data\": [         {             \"amount\": 14,             \"inputs\": [{               \"amount\": 14,               \"address\": \"DdzFFzCqrh...fXSru1pdFE\"             }],             \"direction\": \"outgoing\",             \"outputs\": [{               \"amount\": 14,               \"address\": \"A7k5bz1QR2...Tx561NNmfF\"             }],             \"confirmations\": 42,             \"id\": \"43zkUzCVi7...TT31uDfEF7\",             \"type\": \"local\"         }     ],     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 10,             \"totalEntries\": 1         }     } } ```  In addition, and because it is not possible to _preview_ a transaction, one can lookup a transaction's fees using the `POST /api/v1/transactions/fees` endpoint to get an estimation of those fees.   Pagination ==========  **All GET requests of the API are paginated by default**. Whilst this can be a source of surprise, is the best way of ensuring the performance of GET requests is not affected by the size of the data storage.  Version `V1` introduced a different way of requesting information to the API. In particular, GET requests which returns a _collection_ (i.e. typically a JSON array of resources) lists extra parameters which can be used to modify the shape of the response. In particular, those are:  * `page`: (Default value: **1**). * `per_page`: (Default value: **10**)  For a more accurate description, see the section `Parameters` of each GET request, but as a brief overview the first two control how many results and which results to access in a paginated request.   Filtering and sorting =====================  `GET` endpoints which list collection of resources supports filters & sort operations, which are clearly marked in the swagger docs with the `FILTER` or `SORT` labels. The query format is quite simple, and it goes this way:   Filter operators ----------------  | Operator | Description                                                               | Example                | |----------|---------------------------------------------------------------------------|------------------------| | -        | If **no operator** is passed, this is equivalent to `EQ` (see below).     | `balance=10`           | | `EQ`     | Retrieves the resources with index _equal_ to the one provided.           | `balance=EQ[10]`       | | `LT`     | Retrieves the resources with index _less than_ the one provided.          | `balance=LT[10]`       | | `LTE`    | Retrieves the resources with index _less than equal_ the one provided.    | `balance=LTE[10]`      | | `GT`     | Retrieves the resources with index _greater than_ the one provided.       | `balance=GT[10]`       | | `GTE`    | Retrieves the resources with index _greater than equal_ the one provided. | `balance=GTE[10]`      | | `RANGE`  | Retrieves the resources with index _within the inclusive range_ [k,k].    | `balance=RANGE[10,20]` |  Sort operators --------------  | Operator | Description                                                               | Example                | |----------|---------------------------------------------------------------------------|------------------------| | `ASC`    | Sorts the resources with the given index in _ascending_ order.            | `sort_by=ASC[balance]` | | `DES`    | Sorts the resources with the given index in _descending_ order.           | `sort_by=DES[balance]` | | -        | If **no operator** is passed, this is equivalent to `DES` (see above).    | `sort_by=balance`      |   Errors ======  In case a request cannot be served by the API, a non-2xx HTTP response will be issue, together with a [JSend-compliant](https://labs.omniti.com/labs/jsend) JSON Object describing the error in detail together with a numeric error code which can be used by API consumers to implement proper error handling in their application. For example, here's a typical error which might be issued:  ``` json {     \"status\": \"error\",     \"diagnostic\": {},     \"message\": \"WalletNotFound\" } ```  Existing wallet errors ----------------------  Error Name | HTTP Error code | Example -----------|-----------------|--------- `NotEnoughMoney`|403|`{\"status\":\"error\",\"diagnostic\":{\"needMore\":1400},\"message\":\"NotEnoughMoney\"}` `OutputIsRedeem`|403|`{\"status\":\"error\",\"diagnostic\":{\"address\":\"b10b24203f1f0cadffcfd16277125cf7f3ad598983bef9123be80d93\"},\"message\":\"OutputIsRedeem\"}` `SomeOtherError`|418|`{\"status\":\"error\",\"diagnostic\":{\"foo\":\"foo\",\"bar\":14},\"message\":\"SomeOtherError\"}` `MigrationFailed`|422|`{\"status\":\"error\",\"diagnostic\":{\"description\":\"migration\"},\"message\":\"MigrationFailed\"}` `JSONValidationFailed`|400|`{\"status\":\"error\",\"diagnostic\":{\"validationError\":\"Expected String, found Null.\"},\"message\":\"JSONValidationFailed\"}` `WalletNotFound`|404|`{\"status\":\"error\",\"diagnostic\":{},\"message\":\"WalletNotFound\"}`   Mnemonic Codes ==============  The full list of accepted mnemonic codes to secure a wallet is defined by the [BIP-39 specifications](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki). Note that picking up 12 random words from the list **is not enough** and leads to poor security. Make sure to carefully follow the steps described in the protocol when you generate words for a new wallet.   Versioning & Legacy ===================  The API is **versioned**, meaning that is possible to access different versions of the API by adding the _version number_ in the URL.  **For the sake of backward compatibility, we expose the legacy version of the API, available simply as unversioned endpoints.**  This means that _omitting_ the version number would call the old version of the API. Deprecated endpoints are currently grouped under an appropriate section; they would be removed in upcoming released, if you're starting a new integration with Cardano-SL, please ignore these.  Note that Compatibility between major versions is not _guaranteed_, i.e. the request & response formats might differ.   Disable TLS (Not Recommended) -----------------------------  If needed, you can disable TLS by providing the `--no-tls` flag to the wallet or by running a wallet in debug mode with `--wallet-debug` turned on. 

OpenAPI spec version: cardano-sl:0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require 'date'
require 'json'
require 'logger'
require 'tempfile'
require 'typhoeus'
require 'uri'

module SwaggerClient
  class ApiClient
    # The Configuration object holding settings to be used in the API client.
    attr_accessor :config

    # Defines the headers to be used in HTTP requests of all API calls by default.
    #
    # @return [Hash]
    attr_accessor :default_headers

    # Initializes the ApiClient
    # @option config [Configuration] Configuration for initializing the object, default to Configuration.default
    def initialize(config = Configuration.default)
      @config = config
      @user_agent = "Swagger-Codegen/#{VERSION}/ruby"
      @default_headers = {
        'Content-Type' => "application/json",
        'User-Agent' => @user_agent
      }
    end

    def self.default
      @@default ||= ApiClient.new
    end

    # Call an API with given options.
    #
    # @return [Array<(Object, Fixnum, Hash)>] an array of 3 elements:
    #   the data deserialized from response body (could be nil), response status code and response headers.
    def call_api(http_method, path, opts = {})
      request = build_request(http_method, path, opts)
      response = request.run

      if @config.debugging
        @config.logger.debug "HTTP response body ~BEGIN~\n#{response.body}\n~END~\n"
      end

      unless response.success?
        if response.timed_out?
          fail ApiError.new('Connection timed out')
        elsif response.code == 0
          # Errors from libcurl will be made visible here
          fail ApiError.new(:code => 0,
                            :message => response.return_message)
        else
          fail ApiError.new(:code => response.code,
                            :response_headers => response.headers,
                            :response_body => response.body),
               response.status_message
        end
      end

      if opts[:return_type]
        data = deserialize(response, opts[:return_type])
      else
        data = nil
      end
      return data, response.code, response.headers
    end

    # Builds the HTTP request
    #
    # @param [String] http_method HTTP method/verb (e.g. POST)
    # @param [String] path URL path (e.g. /account/new)
    # @option opts [Hash] :header_params Header parameters
    # @option opts [Hash] :query_params Query parameters
    # @option opts [Hash] :form_params Query parameters
    # @option opts [Object] :body HTTP body (JSON/XML)
    # @return [Typhoeus::Request] A Typhoeus Request
    def build_request(http_method, path, opts = {})
      url = build_request_url(path)
      http_method = http_method.to_sym.downcase

      header_params = @default_headers.merge(opts[:header_params] || {})
      query_params = opts[:query_params] || {}
      form_params = opts[:form_params] || {}


      # set ssl_verifyhosts option based on @config.verify_ssl_host (true/false)
      _verify_ssl_host = @config.verify_ssl_host ? 2 : 0

      req_opts = {
        :method => http_method,
        :headers => header_params,
        :params => query_params,
        :params_encoding => @config.params_encoding,
        :timeout => @config.timeout,
        :ssl_verifypeer => @config.verify_ssl,
        :ssl_verifyhost => _verify_ssl_host,
        :sslcert => @config.cert_file,
        :sslkey => @config.key_file,
        :verbose => @config.debugging
      }

      # set custom cert, if provided
      req_opts[:cainfo] = @config.ssl_ca_cert if @config.ssl_ca_cert

      if [:post, :patch, :put, :delete].include?(http_method)
        req_body = build_request_body(header_params, form_params, opts[:body])
        req_opts.update :body => req_body
        if @config.debugging
          @config.logger.debug "HTTP request body param ~BEGIN~\n#{req_body}\n~END~\n"
        end
      end

      request = Typhoeus::Request.new(url, req_opts)
      download_file(request) if opts[:return_type] == 'File'
      request
    end

    # Check if the given MIME is a JSON MIME.
    # JSON MIME examples:
    #   application/json
    #   application/json; charset=UTF8
    #   APPLICATION/JSON
    #   */*
    # @param [String] mime MIME
    # @return [Boolean] True if the MIME is application/json
    def json_mime?(mime)
       (mime == "*/*") || !(mime =~ /Application\/.*json(?!p)(;.*)?/i).nil?
    end

    # Deserialize the response to the given return type.
    #
    # @param [Response] response HTTP response
    # @param [String] return_type some examples: "User", "Array[User]", "Hash[String,Integer]"
    def deserialize(response, return_type)
      body = response.body

      # handle file downloading - return the File instance processed in request callbacks
      # note that response body is empty when the file is written in chunks in request on_body callback
      return @tempfile if return_type == 'File'

      return nil if body.nil? || body.empty?

      # return response body directly for String return type
      return body if return_type == 'String'

      # ensuring a default content type
      content_type = response.headers['Content-Type'] || 'application/json'

      fail "Content-Type is not supported: #{content_type}" unless json_mime?(content_type)

      begin
        data = JSON.parse("[#{body}]", :symbolize_names => true)[0]
      rescue JSON::ParserError => e
        if %w(String Date DateTime).include?(return_type)
          data = body
        else
          raise e
        end
      end

      convert_to_type data, return_type
    end

    # Convert data to the given return type.
    # @param [Object] data Data to be converted
    # @param [String] return_type Return type
    # @return [Mixed] Data in a particular type
    def convert_to_type(data, return_type)
      return nil if data.nil?
      case return_type
      when 'String'
        data.to_s
      when 'Integer'
        data.to_i
      when 'Float'
        data.to_f
      when 'BOOLEAN'
        data == true
      when 'DateTime'
        # parse date time (expecting ISO 8601 format)
        DateTime.parse data
      when 'Date'
        # parse date time (expecting ISO 8601 format)
        Date.parse data
      when 'Object'
        # generic object (usually a Hash), return directly
        data
      when /\AArray<(.+)>\z/
        # e.g. Array<Pet>
        sub_type = $1
        data.map {|item| convert_to_type(item, sub_type) }
      when /\AHash\<String, (.+)\>\z/
        # e.g. Hash<String, Integer>
        sub_type = $1
        {}.tap do |hash|
          data.each {|k, v| hash[k] = convert_to_type(v, sub_type) }
        end
      else
        # models, e.g. Pet
        SwaggerClient.const_get(return_type).new.tap do |model|
          model.build_from_hash data
        end
      end
    end

    # Save response body into a file in (the defined) temporary folder, using the filename
    # from the "Content-Disposition" header if provided, otherwise a random filename.
    # The response body is written to the file in chunks in order to handle files which
    # size is larger than maximum Ruby String or even larger than the maximum memory a Ruby
    # process can use.
    #
    # @see Configuration#temp_folder_path
    def download_file(request)
      tempfile = nil
      encoding = nil
      request.on_headers do |response|
        content_disposition = response.headers['Content-Disposition']
        if content_disposition and content_disposition =~ /filename=/i
          filename = content_disposition[/filename=['"]?([^'"\s]+)['"]?/, 1]
          prefix = sanitize_filename(filename)
        else
          prefix = 'download-'
        end
        prefix = prefix + '-' unless prefix.end_with?('-')
        encoding = response.body.encoding
        tempfile = Tempfile.open(prefix, @config.temp_folder_path, encoding: encoding)
        @tempfile = tempfile
      end
      request.on_body do |chunk|
        chunk.force_encoding(encoding)
        tempfile.write(chunk)
      end
      request.on_complete do |response|
        tempfile.close
        @config.logger.info "Temp file written to #{tempfile.path}, please copy the file to a proper folder "\
                            "with e.g. `FileUtils.cp(tempfile.path, '/new/file/path')` otherwise the temp file "\
                            "will be deleted automatically with GC. It's also recommended to delete the temp file "\
                            "explicitly with `tempfile.delete`"
      end
    end

    # Sanitize filename by removing path.
    # e.g. ../../sun.gif becomes sun.gif
    #
    # @param [String] filename the filename to be sanitized
    # @return [String] the sanitized filename
    def sanitize_filename(filename)
      filename.gsub(/.*[\/\\]/, '')
    end

    def build_request_url(path)
      # Add leading and trailing slashes to path
      path = "/#{path}".gsub(/\/+/, '/')
      URI.encode(@config.base_url + path)
    end

    # Builds the HTTP request body
    #
    # @param [Hash] header_params Header parameters
    # @param [Hash] form_params Query parameters
    # @param [Object] body HTTP body (JSON/XML)
    # @return [String] HTTP body data in the form of string
    def build_request_body(header_params, form_params, body)
      # http form
      if header_params['Content-Type'] == 'application/x-www-form-urlencoded' ||
          header_params['Content-Type'] == 'multipart/form-data'
        data = {}
        form_params.each do |key, value|
          case value
          when ::File, ::Array, nil
            # let typhoeus handle File, Array and nil parameters
            data[key] = value
          else
            data[key] = value.to_s
          end
        end
      elsif body
        data = body.is_a?(String) ? body : body.to_json
      else
        data = nil
      end
      data
    end

    # Update hearder and query params based on authentication settings.
    #
    # @param [Hash] header_params Header parameters
    # @param [Hash] query_params Query parameters
    # @param [String] auth_names Authentication scheme name
    def update_params_for_auth!(header_params, query_params, auth_names)
      Array(auth_names).each do |auth_name|
        auth_setting = @config.auth_settings[auth_name]
        next unless auth_setting
        case auth_setting[:in]
        when 'header' then header_params[auth_setting[:key]] = auth_setting[:value]
        when 'query'  then query_params[auth_setting[:key]] = auth_setting[:value]
        else fail ArgumentError, 'Authentication token must be in `query` of `header`'
        end
      end
    end

    # Sets user agent in HTTP header
    #
    # @param [String] user_agent User agent (e.g. swagger-codegen/ruby/1.0.0)
    def user_agent=(user_agent)
      @user_agent = user_agent
      @default_headers['User-Agent'] = @user_agent
    end

    # Return Accept header based on an array of accepts provided.
    # @param [Array] accepts array for Accept
    # @return [String] the Accept header (e.g. application/json)
    def select_header_accept(accepts)
      return nil if accepts.nil? || accepts.empty?
      # use JSON when present, otherwise use all of the provided
      json_accept = accepts.find { |s| json_mime?(s) }
      return json_accept || accepts.join(',')
    end

    # Return Content-Type header based on an array of content types provided.
    # @param [Array] content_types array for Content-Type
    # @return [String] the Content-Type header  (e.g. application/json)
    def select_header_content_type(content_types)
      # use application/json by default
      return 'application/json' if content_types.nil? || content_types.empty?
      # use JSON when present, otherwise use the first one
      json_content_type = content_types.find { |s| json_mime?(s) }
      return json_content_type || content_types.first
    end

    # Convert object (array, hash, object, etc) to JSON string.
    # @param [Object] model object to be converted into JSON string
    # @return [String] JSON string representation of the object
    def object_to_http_body(model)
      return model if model.nil? || model.is_a?(String)
      local_body = nil
      if model.is_a?(Array)
        local_body = model.map{|m| object_to_hash(m) }
      else
        local_body = object_to_hash(model)
      end
      local_body.to_json
    end

    # Convert object(non-array) to hash.
    # @param [Object] obj object to be converted into JSON string
    # @return [String] JSON string representation of the object
    def object_to_hash(obj)
      if obj.respond_to?(:to_hash)
        obj.to_hash
      else
        obj
      end
    end

    # Build parameter value according to the given collection format.
    # @param [String] collection_format one of :csv, :ssv, :tsv, :pipes and :multi
    def build_collection_param(param, collection_format)
      case collection_format
      when :csv
        param.join(',')
      when :ssv
        param.join(' ')
      when :tsv
        param.join("\t")
      when :pipes
        param.join('|')
      when :multi
        # return the array directly as typhoeus will handle it as expected
        param
      else
        fail "unknown collection format: #{collection_format.inspect}"
      end
    end
  end
end
