struct Packlink
  abstract struct Base
    macro will_create(pattern, mapping)
      def self.create(
        body : NamedTuple | Hash = HS2.new,
        params : NamedTuple | Hash = HS2.new,
        query : NamedTuple | Hash = HS2.new,
        headers : NamedTuple | Hash = HS2.new,
        client : Client = Client.instance
      )
        path = CreatePath.new(params).to_s
        CreatedResponse.from_json(client.post(path, body, query, headers))
      end

      struct CreatedResponse
        JSON.mapping({{ mapping }})
      end

      struct CreatePath < Packlink::Path
        getter pattern = {{ pattern }}
      end
    end

    macro will_find(pattern, mapping)
      def self.find(
        params : NamedTuple | Hash = HS2.new,
        query : NamedTuple | Hash = HS2.new,
        headers : NamedTuple | Hash = HS2.new,
        client : Client = Client.instance
      )
        path = FindPath.new(params).to_s
        FoundResponse.from_json(client.get(path, query, headers))
      end

      struct FoundResponse
        JSON.mapping({{ mapping }})
      end

      struct FindPath < Packlink::Path
        getter pattern = {{ pattern }}
      end
    end

    macro will_list(pattern, mapping)
      def self.all(
        params : NamedTuple | Hash = HS2.new,
        query : NamedTuple | Hash = HS2.new,
        headers : NamedTuple | Hash = HS2.new,
        client : Client = Client.instance
      )
        path = AllPath.new(params).to_s
        json = client.get(path, query, headers: headers)
        List(Item).from_json(%({"items":#{json}}))
      end

      struct Item
        JSON.mapping({{ mapping }})
      end

      struct AllPath < Packlink::Path
        getter pattern = {{ pattern }}
      end
    end
  end
end
