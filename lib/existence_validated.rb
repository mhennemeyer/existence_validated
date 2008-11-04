def existence_validated(assocs=[], options={})
  hash ||= {}
  assocs.each do |assoc|
    klass = assoc.camelize.constantize
    mock = mock_model(klass)
    hash = {
      assoc.to_s.concat("_id").to_sym => mock.id,
      assoc => mock
    }
  end
  hash
end