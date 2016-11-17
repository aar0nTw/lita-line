module Lita
  module Adapters
    class Line < Adapter
      # insert adapter code here

      Lita.register_adapter(:line, self)
    end
  end
end
