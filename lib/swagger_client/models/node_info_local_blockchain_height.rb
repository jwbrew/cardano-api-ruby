=begin
#Cardano Wallet API

#This is the specification for the Cardano Wallet API, automatically generated as a [Swagger](https://swagger.io/) spec from the [Servant](http://haskell-servant.readthedocs.io/en/stable/) API of [Cardano](https://github.com/input-output-hk/cardano-sl).  Software Version   | Git Revision -------------------|------------------- cardano-sl:0 | 07e1b7860fec59f94844a3f424603af07da54978  > **Warning**: This version is currently a **BETA-release** which is still under testing before its final stable release. Should you encounter any issues or have any remarks, please let us know; your feedback is highly appreciated.   Getting Started ===============  In the following examples, we will use *curl* to illustrate request to an API running on the default port **8090**.  Please note that wallet web API uses TLS for secure communication. Requests to the API need to send a client CA certificate that was used when launching the node and identifies the client as being permitted to invoke the server API.  Creating a New Wallet ---------------------  You can create your first wallet using the `POST /api/v1/wallets` endpoint as follow:  ``` curl -X POST https://localhost:8090/api/v1/wallets                     \\      -H \"Content-Type: application/json; charset=utf-8\"                \\      -H \"Accept: application/json; charset=utf-8\"                      \\      --cacert ./scripts/tls-files/ca.crt                               \\      -d '{                                                             \\   \"operation\": \"create\",                                               \\   \"backupPhrase\": [\"squirrel\", \"material\", \"silly\", \"twice\", \"direct\", \\     \"slush\", \"pistol\", \"razor\", \"become\", \"junk\", \"kingdom\", \"flee\"],  \\   \"assuranceLevel\": \"normal\",                                          \\   \"name\": \"MyFirstWallet\"                                              \\ }' ```  > **Warning**: Those 12 mnemonic words given for the backup phrase act as an example. **Do not** use them on a production system. See the section below about mnemonic codes for more information.  As a response, the API provides you with a wallet `id` used in subsequent requests to uniquely identity the wallet. Make sure to store it / write it down. Note that every API response is [jsend-compliant](https://labs.omniti.com/labs/jsend); Cardano also augments responses with meta-data specific to pagination. More details in the section below about *Pagination*.  ```json {     \"status\": \"success\",     \"data\": {         \"id\": \"Ae2tdPwUPE...8V3AVTnqGZ\",         \"name\": \"MyFirstWallet\",         \"balance\": 0     },     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 1,             \"totalEntries\": 1         }     } } ```  You have just created your first wallet. Information about this wallet can be retrieved using the `GET /api/v1/wallets/{walletId}` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}} \\      -H \"Accept: application/json; charset=utf-8\"              \\      --cacert ./scripts/tls-files/ca.crt                       \\ ```  Receiving Money ---------------  To receive money from other users you should provide your address. This address can be obtained from an account. Each wallet contains at least one account, you can think of account as a pocket inside of your wallet. Besides, you can view all existing accounts of a wallet by using the `GET /api/v1/wallets/{{walletId}}/accounts` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}}/accounts?page=1&per_page=10 \\      -H \"Accept: application/json; charset=utf-8\"                                          \\      --cacert ./scripts/tls-files/ca.crt                                                   \\ ```  Since you have, for now, only a single wallet, you'll see something like this:  ```json {     \"status\": \"success\",     \"data\": [         {             \"index\": 2147483648,             \"addresses\": [                 \"DdzFFzCqrh...fXSru1pdFE\"             ],             \"amount\": 0,             \"name\": \"Initial account\",             \"walletId\": \"Ae2tdPwUPE...8V3AVTnqGZ\"         }     ],     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 10,             \"totalEntries\": 1         }     } } ```  Each account has at least one address, all listed under the `addresses` field. You can communicate one of these addresses to receive money on the associated account.   Sending Money -------------  In order to send money from one of your account to another address, you can create a new payment transaction using the `POST /api/v1/transactions` endpoint as follow:  ``` curl -X POST https://localhost:8090/api/v1/transactions \\      -H \"Content-Type: application/json; charset=utf-8\" \\      -H \"Accept: application/json; charset=utf-8\"       \\      --cacert ./scripts/tls-files/ca.crt                \\      -d '{                                              \\   \"destinations\": [{                                    \\     \"amount\": 14,                                       \\     \"address\": \"A7k5bz1QR2...Tx561NNmfF\"                \\   }],                                                   \\   \"source\": {                                           \\     \"accountIndex\": 0,                                  \\     \"walletId\": \"Ae2tdPwUPE...8V3AVTnqGZ\"               \\   }                                                     \\ }' ```  Note that, in order to perform a transaction, you need to have some existing coins on the source account! Beside, the Cardano API is designed to accomodate multiple recipients payments out-of-the-box; notice how `destinations` is a list of addresses.  When the transaction succeeds, funds are becomes unavailable from the sources addresses, and available to the destinations in a short delay.  Note that, you can at any time see the status of your wallets by using the `GET /api/v1/transactions/{{walletId}}` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}}?account_index=0  \\      -H \"Accept: application/json; charset=utf-8\"                               \\      --cacert ./scripts/tls-files/ca.crt                                        \\ ```  We have here constrainted the request to a specific account, with our previous transaction the output should look roughly similar to this:  ```json {     \"status\": \"success\",     \"data\": [         {             \"amount\": 14,             \"inputs\": [{               \"amount\": 14,               \"address\": \"DdzFFzCqrh...fXSru1pdFE\"             }],             \"direction\": \"outgoing\",             \"outputs\": [{               \"amount\": 14,               \"address\": \"A7k5bz1QR2...Tx561NNmfF\"             }],             \"confirmations\": 42,             \"id\": \"43zkUzCVi7...TT31uDfEF7\",             \"type\": \"local\"         }     ],     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 10,             \"totalEntries\": 1         }     } } ```  In addition, and because it is not possible to _preview_ a transaction, one can lookup a transaction's fees using the `POST /api/v1/transactions/fees` endpoint to get an estimation of those fees.   Pagination ==========  **All GET requests of the API are paginated by default**. Whilst this can be a source of surprise, is the best way of ensuring the performance of GET requests is not affected by the size of the data storage.  Version `V1` introduced a different way of requesting information to the API. In particular, GET requests which returns a _collection_ (i.e. typically a JSON array of resources) lists extra parameters which can be used to modify the shape of the response. In particular, those are:  * `page`: (Default value: **1**). * `per_page`: (Default value: **10**)  For a more accurate description, see the section `Parameters` of each GET request, but as a brief overview the first two control how many results and which results to access in a paginated request.   Filtering and sorting =====================  `GET` endpoints which list collection of resources supports filters & sort operations, which are clearly marked in the swagger docs with the `FILTER` or `SORT` labels. The query format is quite simple, and it goes this way:   Filter operators ----------------  | Operator | Description                                                               | Example                | |----------|---------------------------------------------------------------------------|------------------------| | -        | If **no operator** is passed, this is equivalent to `EQ` (see below).     | `balance=10`           | | `EQ`     | Retrieves the resources with index _equal_ to the one provided.           | `balance=EQ[10]`       | | `LT`     | Retrieves the resources with index _less than_ the one provided.          | `balance=LT[10]`       | | `LTE`    | Retrieves the resources with index _less than equal_ the one provided.    | `balance=LTE[10]`      | | `GT`     | Retrieves the resources with index _greater than_ the one provided.       | `balance=GT[10]`       | | `GTE`    | Retrieves the resources with index _greater than equal_ the one provided. | `balance=GTE[10]`      | | `RANGE`  | Retrieves the resources with index _within the inclusive range_ [k,k].    | `balance=RANGE[10,20]` |  Sort operators --------------  | Operator | Description                                                               | Example                | |----------|---------------------------------------------------------------------------|------------------------| | `ASC`    | Sorts the resources with the given index in _ascending_ order.            | `sort_by=ASC[balance]` | | `DES`    | Sorts the resources with the given index in _descending_ order.           | `sort_by=DES[balance]` | | -        | If **no operator** is passed, this is equivalent to `DES` (see above).    | `sort_by=balance`      |   Errors ======  In case a request cannot be served by the API, a non-2xx HTTP response will be issue, together with a [JSend-compliant](https://labs.omniti.com/labs/jsend) JSON Object describing the error in detail together with a numeric error code which can be used by API consumers to implement proper error handling in their application. For example, here's a typical error which might be issued:  ``` json {     \"status\": \"error\",     \"diagnostic\": {},     \"message\": \"WalletNotFound\" } ```  Existing wallet errors ----------------------  Error Name | HTTP Error code | Example -----------|-----------------|--------- `NotEnoughMoney`|403|`{\"status\":\"error\",\"diagnostic\":{\"needMore\":1400},\"message\":\"NotEnoughMoney\"}` `OutputIsRedeem`|403|`{\"status\":\"error\",\"diagnostic\":{\"address\":\"b10b24203f1f0cadffcfd16277125cf7f3ad598983bef9123be80d93\"},\"message\":\"OutputIsRedeem\"}` `SomeOtherError`|418|`{\"status\":\"error\",\"diagnostic\":{\"foo\":\"foo\",\"bar\":14},\"message\":\"SomeOtherError\"}` `MigrationFailed`|422|`{\"status\":\"error\",\"diagnostic\":{\"description\":\"migration\"},\"message\":\"MigrationFailed\"}` `JSONValidationFailed`|400|`{\"status\":\"error\",\"diagnostic\":{\"validationError\":\"Expected String, found Null.\"},\"message\":\"JSONValidationFailed\"}` `WalletNotFound`|404|`{\"status\":\"error\",\"diagnostic\":{},\"message\":\"WalletNotFound\"}`   Mnemonic Codes ==============  The full list of accepted mnemonic codes to secure a wallet is defined by the [BIP-39 specifications](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki). Note that picking up 12 random words from the list **is not enough** and leads to poor security. Make sure to carefully follow the steps described in the protocol when you generate words for a new wallet.   Versioning & Legacy ===================  The API is **versioned**, meaning that is possible to access different versions of the API by adding the _version number_ in the URL.  **For the sake of backward compatibility, we expose the legacy version of the API, available simply as unversioned endpoints.**  This means that _omitting_ the version number would call the old version of the API. Deprecated endpoints are currently grouped under an appropriate section; they would be removed in upcoming released, if you're starting a new integration with Cardano-SL, please ignore these.  Note that Compatibility between major versions is not _guaranteed_, i.e. the request & response formats might differ.   Disable TLS (Not Recommended) -----------------------------  If needed, you can disable TLS by providing the `--no-tls` flag to the wallet or by running a wallet in debug mode with `--wallet-debug` turned on. 

OpenAPI spec version: cardano-sl:0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require 'date'

module SwaggerClient
  # Local blockchain height, in number of blocks
  class NodeInfoLocalBlockchainHeight
    attr_accessor :quantity

    attr_accessor :unit

    class EnumAttributeValidator
      attr_reader :datatype
      attr_reader :allowable_values

      def initialize(datatype, allowable_values)
        @allowable_values = allowable_values.map do |value|
          case datatype.to_s
          when /Integer/i
            value.to_i
          when /Float/i
            value.to_f
          else
            value
          end
        end
      end

      def valid?(value)
        !value || allowable_values.include?(value)
      end
    end

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'quantity' => :'quantity',
        :'unit' => :'unit'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'quantity' => :'Float',
        :'unit' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}){|(k,v), h| h[k.to_sym] = v}

      if attributes.has_key?(:'quantity')
        self.quantity = attributes[:'quantity']
      end

      if attributes.has_key?(:'unit')
        self.unit = attributes[:'unit']
      end

    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @quantity.nil?
        invalid_properties.push("invalid value for 'quantity', quantity cannot be nil.")
      end

      if @quantity > 18446744073709551615
        invalid_properties.push("invalid value for 'quantity', must be smaller than or equal to 18446744073709551615.")
      end

      if @quantity < 0
        invalid_properties.push("invalid value for 'quantity', must be greater than or equal to 0.")
      end

      return invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @quantity.nil?
      return false if @quantity > 18446744073709551615
      return false if @quantity < 0
      unit_validator = EnumAttributeValidator.new('String', ["blocks"])
      return false unless unit_validator.valid?(@unit)
      return true
    end

    # Custom attribute writer method with validation
    # @param [Object] quantity Value to be assigned
    def quantity=(quantity)
      if quantity.nil?
        fail ArgumentError, "quantity cannot be nil"
      end

      if quantity > 18446744073709551615
        fail ArgumentError, "invalid value for 'quantity', must be smaller than or equal to 18446744073709551615."
      end

      if quantity < 0
        fail ArgumentError, "invalid value for 'quantity', must be greater than or equal to 0."
      end

      @quantity = quantity
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] unit Object to be assigned
    def unit=(unit)
      validator = EnumAttributeValidator.new('String', ["blocks"])
      unless validator.valid?(unit)
        fail ArgumentError, "invalid value for 'unit', must be one of #{validator.allowable_values}."
      end
      @unit = unit
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          quantity == o.quantity &&
          unit == o.unit
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [quantity, unit].hash
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def build_from_hash(attributes)
      return nil unless attributes.is_a?(Hash)
      self.class.swagger_types.each_pair do |key, type|
        if type =~ /\AArray<(.*)>/i
          # check to ensure the input is an array given that the the attribute
          # is documented as an array but the input is not
          if attributes[self.class.attribute_map[key]].is_a?(Array)
            self.send("#{key}=", attributes[self.class.attribute_map[key]].map{ |v| _deserialize($1, v) } )
          end
        elsif !attributes[self.class.attribute_map[key]].nil?
          self.send("#{key}=", _deserialize(type, attributes[self.class.attribute_map[key]]))
        end # or else data not found in attributes(hash), not an issue as the data can be optional
      end

      self
    end

    # Deserializes the data based on type
    # @param string type Data type
    # @param string value Value to be deserialized
    # @return [Object] Deserialized data
    def _deserialize(type, value)
      case type.to_sym
      when :DateTime
        DateTime.parse(value)
      when :Date
        Date.parse(value)
      when :String
        value.to_s
      when :Integer
        value.to_i
      when :Float
        value.to_f
      when :BOOLEAN
        if value.to_s =~ /\A(true|t|yes|y|1)\z/i
          true
        else
          false
        end
      when :Object
        # generic object (usually a Hash), return directly
        value
      when /\AArray<(?<inner_type>.+)>\z/
        inner_type = Regexp.last_match[:inner_type]
        value.map { |v| _deserialize(inner_type, v) }
      when /\AHash<(?<k_type>.+?), (?<v_type>.+)>\z/
        k_type = Regexp.last_match[:k_type]
        v_type = Regexp.last_match[:v_type]
        {}.tap do |hash|
          value.each do |k, v|
            hash[_deserialize(k_type, k)] = _deserialize(v_type, v)
          end
        end
      else # model
        temp_model = SwaggerClient.const_get(type).new
        temp_model.build_from_hash(value)
      end
    end

    # Returns the string representation of the object
    # @return [String] String presentation of the object
    def to_s
      to_hash.to_s
    end

    # to_body is an alias to to_hash (backward compatibility)
    # @return [Hash] Returns the object in the form of hash
    def to_body
      to_hash
    end

    # Returns the object in the form of hash
    # @return [Hash] Returns the object in the form of hash
    def to_hash
      hash = {}
      self.class.attribute_map.each_pair do |attr, param|
        value = self.send(attr)
        next if value.nil?
        hash[param] = _to_hash(value)
      end
      hash
    end

    # Outputs non-array value in the form of hash
    # For object, use to_hash. Otherwise, just return the value
    # @param [Object] value Any valid value
    # @return [Hash] Returns the value in the form of hash
    def _to_hash(value)
      if value.is_a?(Array)
        value.compact.map{ |v| _to_hash(v) }
      elsif value.is_a?(Hash)
        {}.tap do |hash|
          value.each { |k, v| hash[k] = _to_hash(v) }
        end
      elsif value.respond_to? :to_hash
        value.to_hash
      else
        value
      end
    end

  end

end
