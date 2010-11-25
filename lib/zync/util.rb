module Zync
  module Util
    extend self

    # Recursively convert all string keys to symbols
    #
    # @param [Hash] hash A Hash to symbolize keys
    # @return [Hash] The hash with all keys as symbols
    def symbolize_keys(hash)
      return hash unless hash.kind_of?(Hash)
      Hash[
        hash.map { |key, value|
          k = key.is_a?(String) ? key.to_sym : key
          v = symbolize_keys value
          [k,v]
      }]
    end
  end

end
