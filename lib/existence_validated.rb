def existence_validated(assocs=[], options={})
  assocs = [assocs] unless assocs.respond_to?(:each)
  hash ||= {}
  assocs.each do |assoc|
    unless options.has_key?(assoc) && options[assoc] == nil
      klass = assoc.to_s.camelize.constantize
      mock = options[assoc] || mock_model(klass)
      klass.should_receive(:exists?).any_number_of_times.with(mock.id).and_return(true)
      klass.should_receive(:exists?).any_number_of_times.with(nil).and_return(false)
      hash.update({
        assoc.to_s.concat("_id").to_sym => mock.id,
        assoc => mock
      })
    end
  end
  hash
end