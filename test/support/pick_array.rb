module PickArray
  refine Array do
    def pick(*methods)
      map do |item|
        methods.map do |method|
          item.public_send(method)
        end
      end
    end
  end
end
