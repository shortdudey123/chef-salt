module SaltCookbookHelper
  def salt_config(config)
    config.to_hash.compact.sorted_hash.to_yaml
  end
end

class Hash
  # adapted from http://bdunagan.com/2011/10/23/ruby-tip-sort-a-hash-recursively/
  def sorted_hash(&block)
    self.class[
      each do |k, v|
        if v.class == Hash
          self[k] = v.sorted_hash(&block)
        elsif v.class == Array
          s = v.collect do |a|
            if a.respond_to?(:sorted_hash)
              a.sorted_hash(&block)
            elsif a.respond_to?(:sort)
              a.sort(&block)
            else
              a
            end
          end
          self[k] = s.sort.to_a
        end
      end.sort(&block)]
  end

  # from https://github.com/sunggun-yu/chef-mongodb3/blob/master/libraries/mongodb3_helper.rb
  def compact
    each_with_object({}) do |(k, v), new_hash|
      if v.is_a?(Hash)
        v = v.compact
        new_hash[k] = v unless v.empty?
      else
        new_hash[k] = v unless v.nil?
      end
      new_hash
    end
  end
end
