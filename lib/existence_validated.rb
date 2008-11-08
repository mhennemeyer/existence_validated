def existence_validated(assocs=[], options={})
  assocs = [assocs] unless assocs.respond_to?(:each)
  assocs.inject({}) do |memo, assoc|
    unless options.has_key?(assoc) && options[assoc] == nil
      klass = assoc.to_s.camelize.constantize
      mock = options[assoc] || mock_model(klass)
      klass.should_receive(:exists?).any_number_of_times.and_return do |fk|
        #fk.nil? || fk == mock.id ? true : false
        fk == mock.id ? true : false
      end
      klass.should_receive(:find).any_number_of_times.and_return do |id, options|
        id == mock.id ? mock : false
      end
      memo.update({
        assoc.to_s.concat("_id").to_sym => mock.id,
        assoc => mock
      })
    end || {}
  end
end