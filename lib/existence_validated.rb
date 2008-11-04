# def existence_validated(assocs=[], options={})
#   def existing_assoc(sym, mock=nil)
#     klass = sym.to_s.capitalize.constantize
#     obj = mock || mock_model(klass)
#     klass.should_receive(:exists?).any_number_of_times.with(obj.id).and_return(true)
#     {
#       sym.to_s.concat("_id").to_sym => obj.id,
#       sym => obj
#     }
#   end
#   assocs.map do |sym| 
#     if options.has_key?(sym) && !options[sym]
#       {sym => options[sym]} 
#     else 
#       existing_assoc(sym, options[sym]) 
#     end
#   end.inject {|s,i| s.merge(i)}
# end