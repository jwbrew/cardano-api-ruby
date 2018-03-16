=begin
#Cardano Wallet API

#This is the specification for the Cardano Wallet API, automatically generated as a [Swagger](https://swagger.io/) spec from the [Servant](http://haskell-servant.readthedocs.io/en/stable/) API of [Cardano](https://github.com/input-output-hk/cardano-sl).  Software Version   | Git Revision -------------------|------------------- cardano-sl:0 | 07e1b7860fec59f94844a3f424603af07da54978  > **Warning**: This version is currently a **BETA-release** which is still under testing before its final stable release. Should you encounter any issues or have any remarks, please let us know; your feedback is highly appreciated.   Getting Started ===============  In the following examples, we will use *curl* to illustrate request to an API running on the default port **8090**.  Please note that wallet web API uses TLS for secure communication. Requests to the API need to send a client CA certificate that was used when launching the node and identifies the client as being permitted to invoke the server API.  Creating a New Wallet ---------------------  You can create your first wallet using the `POST /api/v1/wallets` endpoint as follow:  ``` curl -X POST https://localhost:8090/api/v1/wallets                     \\      -H \"Content-Type: application/json; charset=utf-8\"                \\      -H \"Accept: application/json; charset=utf-8\"                      \\      --cacert ./scripts/tls-files/ca.crt                               \\      -d '{                                                             \\   \"operation\": \"create\",                                               \\   \"backupPhrase\": [\"squirrel\", \"material\", \"silly\", \"twice\", \"direct\", \\     \"slush\", \"pistol\", \"razor\", \"become\", \"junk\", \"kingdom\", \"flee\"],  \\   \"assuranceLevel\": \"normal\",                                          \\   \"name\": \"MyFirstWallet\"                                              \\ }' ```  > **Warning**: Those 12 mnemonic words given for the backup phrase act as an example. **Do not** use them on a production system. See the section below about mnemonic codes for more information.  As a response, the API provides you with a wallet `id` used in subsequent requests to uniquely identity the wallet. Make sure to store it / write it down. Note that every API response is [jsend-compliant](https://labs.omniti.com/labs/jsend); Cardano also augments responses with meta-data specific to pagination. More details in the section below about *Pagination*.  ```json {     \"status\": \"success\",     \"data\": {         \"id\": \"Ae2tdPwUPE...8V3AVTnqGZ\",         \"name\": \"MyFirstWallet\",         \"balance\": 0     },     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 1,             \"totalEntries\": 1         }     } } ```  You have just created your first wallet. Information about this wallet can be retrieved using the `GET /api/v1/wallets/{walletId}` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}} \\      -H \"Accept: application/json; charset=utf-8\"              \\      --cacert ./scripts/tls-files/ca.crt                       \\ ```  Receiving Money ---------------  To receive money from other users you should provide your address. This address can be obtained from an account. Each wallet contains at least one account, you can think of account as a pocket inside of your wallet. Besides, you can view all existing accounts of a wallet by using the `GET /api/v1/wallets/{{walletId}}/accounts` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}}/accounts?page=1&per_page=10 \\      -H \"Accept: application/json; charset=utf-8\"                                          \\      --cacert ./scripts/tls-files/ca.crt                                                   \\ ```  Since you have, for now, only a single wallet, you'll see something like this:  ```json {     \"status\": \"success\",     \"data\": [         {             \"index\": 2147483648,             \"addresses\": [                 \"DdzFFzCqrh...fXSru1pdFE\"             ],             \"amount\": 0,             \"name\": \"Initial account\",             \"walletId\": \"Ae2tdPwUPE...8V3AVTnqGZ\"         }     ],     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 10,             \"totalEntries\": 1         }     } } ```  Each account has at least one address, all listed under the `addresses` field. You can communicate one of these addresses to receive money on the associated account.   Sending Money -------------  In order to send money from one of your account to another address, you can create a new payment transaction using the `POST /api/v1/transactions` endpoint as follow:  ``` curl -X POST https://localhost:8090/api/v1/transactions \\      -H \"Content-Type: application/json; charset=utf-8\" \\      -H \"Accept: application/json; charset=utf-8\"       \\      --cacert ./scripts/tls-files/ca.crt                \\      -d '{                                              \\   \"destinations\": [{                                    \\     \"amount\": 14,                                       \\     \"address\": \"A7k5bz1QR2...Tx561NNmfF\"                \\   }],                                                   \\   \"source\": {                                           \\     \"accountIndex\": 0,                                  \\     \"walletId\": \"Ae2tdPwUPE...8V3AVTnqGZ\"               \\   }                                                     \\ }' ```  Note that, in order to perform a transaction, you need to have some existing coins on the source account! Beside, the Cardano API is designed to accomodate multiple recipients payments out-of-the-box; notice how `destinations` is a list of addresses.  When the transaction succeeds, funds are becomes unavailable from the sources addresses, and available to the destinations in a short delay.  Note that, you can at any time see the status of your wallets by using the `GET /api/v1/transactions/{{walletId}}` endpoint as follow:  ``` curl -X GET https://localhost:8090/api/v1/wallets/{{walletId}}?account_index=0  \\      -H \"Accept: application/json; charset=utf-8\"                               \\      --cacert ./scripts/tls-files/ca.crt                                        \\ ```  We have here constrainted the request to a specific account, with our previous transaction the output should look roughly similar to this:  ```json {     \"status\": \"success\",     \"data\": [         {             \"amount\": 14,             \"inputs\": [{               \"amount\": 14,               \"address\": \"DdzFFzCqrh...fXSru1pdFE\"             }],             \"direction\": \"outgoing\",             \"outputs\": [{               \"amount\": 14,               \"address\": \"A7k5bz1QR2...Tx561NNmfF\"             }],             \"confirmations\": 42,             \"id\": \"43zkUzCVi7...TT31uDfEF7\",             \"type\": \"local\"         }     ],     \"meta\": {         \"pagination\": {             \"totalPages\": 1,             \"page\": 1,             \"perPage\": 10,             \"totalEntries\": 1         }     } } ```  In addition, and because it is not possible to _preview_ a transaction, one can lookup a transaction's fees using the `POST /api/v1/transactions/fees` endpoint to get an estimation of those fees.   Pagination ==========  **All GET requests of the API are paginated by default**. Whilst this can be a source of surprise, is the best way of ensuring the performance of GET requests is not affected by the size of the data storage.  Version `V1` introduced a different way of requesting information to the API. In particular, GET requests which returns a _collection_ (i.e. typically a JSON array of resources) lists extra parameters which can be used to modify the shape of the response. In particular, those are:  * `page`: (Default value: **1**). * `per_page`: (Default value: **10**)  For a more accurate description, see the section `Parameters` of each GET request, but as a brief overview the first two control how many results and which results to access in a paginated request.   Filtering and sorting =====================  `GET` endpoints which list collection of resources supports filters & sort operations, which are clearly marked in the swagger docs with the `FILTER` or `SORT` labels. The query format is quite simple, and it goes this way:   Filter operators ----------------  | Operator | Description                                                               | Example                | |----------|---------------------------------------------------------------------------|------------------------| | -        | If **no operator** is passed, this is equivalent to `EQ` (see below).     | `balance=10`           | | `EQ`     | Retrieves the resources with index _equal_ to the one provided.           | `balance=EQ[10]`       | | `LT`     | Retrieves the resources with index _less than_ the one provided.          | `balance=LT[10]`       | | `LTE`    | Retrieves the resources with index _less than equal_ the one provided.    | `balance=LTE[10]`      | | `GT`     | Retrieves the resources with index _greater than_ the one provided.       | `balance=GT[10]`       | | `GTE`    | Retrieves the resources with index _greater than equal_ the one provided. | `balance=GTE[10]`      | | `RANGE`  | Retrieves the resources with index _within the inclusive range_ [k,k].    | `balance=RANGE[10,20]` |  Sort operators --------------  | Operator | Description                                                               | Example                | |----------|---------------------------------------------------------------------------|------------------------| | `ASC`    | Sorts the resources with the given index in _ascending_ order.            | `sort_by=ASC[balance]` | | `DES`    | Sorts the resources with the given index in _descending_ order.           | `sort_by=DES[balance]` | | -        | If **no operator** is passed, this is equivalent to `DES` (see above).    | `sort_by=balance`      |   Errors ======  In case a request cannot be served by the API, a non-2xx HTTP response will be issue, together with a [JSend-compliant](https://labs.omniti.com/labs/jsend) JSON Object describing the error in detail together with a numeric error code which can be used by API consumers to implement proper error handling in their application. For example, here's a typical error which might be issued:  ``` json {     \"status\": \"error\",     \"diagnostic\": {},     \"message\": \"WalletNotFound\" } ```  Existing wallet errors ----------------------  Error Name | HTTP Error code | Example -----------|-----------------|--------- `NotEnoughMoney`|403|`{\"status\":\"error\",\"diagnostic\":{\"needMore\":1400},\"message\":\"NotEnoughMoney\"}` `OutputIsRedeem`|403|`{\"status\":\"error\",\"diagnostic\":{\"address\":\"b10b24203f1f0cadffcfd16277125cf7f3ad598983bef9123be80d93\"},\"message\":\"OutputIsRedeem\"}` `SomeOtherError`|418|`{\"status\":\"error\",\"diagnostic\":{\"foo\":\"foo\",\"bar\":14},\"message\":\"SomeOtherError\"}` `MigrationFailed`|422|`{\"status\":\"error\",\"diagnostic\":{\"description\":\"migration\"},\"message\":\"MigrationFailed\"}` `JSONValidationFailed`|400|`{\"status\":\"error\",\"diagnostic\":{\"validationError\":\"Expected String, found Null.\"},\"message\":\"JSONValidationFailed\"}` `WalletNotFound`|404|`{\"status\":\"error\",\"diagnostic\":{},\"message\":\"WalletNotFound\"}`   Mnemonic Codes ==============  The full list of accepted mnemonic codes to secure a wallet is defined by the [BIP-39 specifications](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki). Note that picking up 12 random words from the list **is not enough** and leads to poor security. Make sure to carefully follow the steps described in the protocol when you generate words for a new wallet.   Versioning & Legacy ===================  The API is **versioned**, meaning that is possible to access different versions of the API by adding the _version number_ in the URL.  **For the sake of backward compatibility, we expose the legacy version of the API, available simply as unversioned endpoints.**  This means that _omitting_ the version number would call the old version of the API. Deprecated endpoints are currently grouped under an appropriate section; they would be removed in upcoming released, if you're starting a new integration with Cardano-SL, please ignore these.  Note that Compatibility between major versions is not _guaranteed_, i.e. the request & response formats might differ.   Disable TLS (Not Recommended) -----------------------------  If needed, you can disable TLS by providing the `--no-tls` flag to the wallet or by running a wallet in debug mode with `--wallet-debug` turned on. 

OpenAPI spec version: cardano-sl:0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

# load the gem
require 'swagger_client'

# The following  was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
=end
end
