def existence_validated(assocs=[], options={})
  assocs = [assocs] unless assocs.respond_to?(:each)
  hash ||= {}
  assocs.each do |assoc|
    unless options.has_key?(assoc) && options[assoc] == nil
      klass = assoc.to_s.camelize.constantize
      mock = options[assoc] || mock_model(klass)
      klass.should_receive(:exists?).any_number_of_times.and_return do |fk|
        fk ? true : false
      end
      hash.update({
        assoc.to_s.concat("_id").to_sym => mock.id,
        assoc => mock
      })
    end
  end
  hash
end