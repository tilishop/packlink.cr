require "../spec_helper"

describe Packlink::Base do
  before_each do
    configure_test_api_key
  end

  describe "macros" do
    describe "will_create" do
      it "provides a method to create a resource" do
        WebMock.stub(:post, "https://apisandbox.packlink.com/v1/base/object/jip/janneke")
          .with(
            body: %({"fab":"ul.us"}),
            headers: {"Authorization" => packlink_test_api_key})
          .to_return(body: %({"message": "Created successfully"}))

        object = Packlink::BaseObject.create(
          body: {fab: "ul.us"},
          params: {vendor: "jip", id: "janneke"})
        object.should be_a(Packlink::BaseObject::CreatedResponse)
        object.message.should eq("Created successfully")
      end

      it "accepts a client to preform the request" do
        WebMock.stub(:post, "https://apisandbox.packlink.com/v1/base/object/jip/janneke")
          .with(headers: {"Authorization" => "custom_api_key"})
          .to_return(body: %({"message": "Created successfully"}))

        Packlink::BaseObject.create(
          body: {fab: "ul.us"},
          params: {vendor: "jip", id: "janneke"},
          client: Packlink::Client.new("custom_api_key"))
      end

      it "accepts additional headers for the request" do
        headers = {"Auth" => "super_secret"}
        WebMock.stub(:post, "https://apisandbox.packlink.com/v1/base/object/jip/janneke")
          .with(headers: headers)
          .to_return(body: %({"message": "Created successfully"}))

        Packlink::BaseObject.create(
          body: {fab: "ul.us"},
          params: {vendor: "jip", id: "janneke"},
          headers: headers)
      end

      it "accepts additional query params" do
        WebMock.stub(:post, "https://apisandbox.packlink.com/v1/base/object/jip/janneke?platform=pro")
          .to_return(body: %({"message": "Created successfully"}))

        Packlink::BaseObject.create(
          body: {fab: "ul.us"},
          params: {vendor: "jip", id: "janneke"},
          query: {platform: "pro"})
      end

      it "allows mapping to be optional" do
        WebMock.stub(:post, "https://apisandbox.packlink.com/v1/base/object/fabulous")
          .to_return(body: "")

        response = Packlink::BaseObjectWithoutMapping.create(params: {id: "fabulous"})
        response.should be_true
      end

      it "fails with missing parameters" do
        expect_raises(Packlink::ParamsMissingException) do
          Packlink::BaseObject.create(
            body: {fab: "ul.us"},
            params: {vendor: "jip"})
        end
      end
    end

    describe "will_find" do
      it "provides a method to find one resource" do
        WebMock.stub(:get, "https://apisandbox.packlink.com/v1/base/object/janneke")
          .with(headers: {"Authorization" => packlink_test_api_key})
          .to_return(body: %({"name": "Jip", "price": 12.5}))

        resource = Packlink::BaseObject.find({id: "janneke"})
        resource.should be_a(Packlink::BaseObject::FoundResponse)
        resource.name.should eq("Jip")
        resource.price.should eq(12.5)
      end

      it "accepts a client to preform the request" do
        WebMock.stub(:get, "https://apisandbox.packlink.com/v1/base/object/fabulous")
          .with(headers: {"Authorization" => "custom_api_key"})
          .to_return(body: %({"name": "Jip", "price": 12.5}))

        Packlink::BaseObject.find(
          params: {id: "fabulous"},
          client: Packlink::Client.new("custom_api_key"))
      end

      it "accepts additional headers for the request" do
        headers = {"Auth" => "super_secret"}
        WebMock.stub(:get, "https://apisandbox.packlink.com/v1/base/object/fabulous")
          .with(headers: headers)
          .to_return(body: %({"name": "Jip", "price": 12.5}))

        Packlink::BaseObject.find(
          params: {id: "fabulous"},
          headers: headers)
      end

      it "allows mapping to be optional" do
        WebMock.stub(:get, "https://apisandbox.packlink.com/v1/base/object/fabulous")
          .to_return(body: "")

        response = Packlink::BaseObjectWithoutMapping.find(params: {id: "fabulous"})
        response.should be_true
      end

      it "fails with missing parameters" do
        expect_raises(Packlink::ParamsMissingException) do
          Packlink::BaseObject.find
        end
      end
    end

    describe "will_list" do
      it "provides a method to find a list of items" do
        WebMock.stub(:get, "https://apisandbox.packlink.com/v1/base/object")
          .with(headers: {"Authorization" => packlink_test_api_key})
          .to_return(body: %([{"name":"Super saver","delivery":true}]))

        list = Packlink::BaseObject.all
        list.should be_a(Packlink::List(Packlink::BaseObject::Item))
        list.first.name.should eq("Super saver")
        list.first.delivery.should be_true
      end

      it "accepts additional headers for the request" do
        headers = {"Auth" => "super_secret"}
        WebMock.stub(:get, "https://apisandbox.packlink.com/v1/base/object")
          .with(headers: headers)
          .to_return(body: %([]))

        Packlink::BaseObject.all(headers: headers)
      end

      it "stores the original uri parameters in the list object" do
        WebMock.stub(:get, "https://apisandbox.packlink.com/v1/base/object")
          .to_return(body: %([]))

        params = {some: "param", id: 123}
        list = Packlink::BaseObject.all(params: params)
        list.params.should eq(Packlink::Util.normalize_hash(params))
      end

      it "stores the original query parameters in the list object" do
        WebMock.stub(:get, "https://apisandbox.packlink.com/v1/base/object?nice=coat&parent_id=123")
          .to_return(body: %([]))

        query = {nice: "coat", parent_id: 123}
        list = Packlink::BaseObject.all(query: query)
        list.query.should eq(Packlink::Util.normalize_hash(query))
      end

      it "accepts a client to preform the request" do
        WebMock.stub(:get, "https://apisandbox.packlink.com/v1/base/object")
          .with(headers: {"Authorization" => "custom_api_key"})
          .to_return(body: %([]))

        Packlink::BaseObject.all(client: Packlink::Client.new("custom_api_key"))
      end

      it "assumes an array of strings if no mapping is provided" do
        WebMock.stub(:get, "https://apisandbox.packlink.com/v1/base/object/X75Z/strings")
          .to_return(body: %(["pack", "link"]))

        list = Packlink::BaseObjectWithoutMapping.all({id: "X75Z"})
        list.should be_a(Packlink::List(String))
        list.size.should eq(2)
        list.first.should eq("pack")
        list.last.should eq("link")
      end
    end
  end
end

struct Packlink
  struct BaseObject < Packlink::Base
    will_create "base/object/:vendor/:id", {
      message: String,
    }
    will_find "base/object/:id", {
      name:  String,
      price: Float64,
    }
    will_list "base/object", {
      name:     String,
      delivery: Bool,
    }
  end

  struct BaseObjectWithoutMapping < Packlink::Base
    will_create "base/object/:id"
    will_find "base/object/:id"
    will_list "base/object/:id/strings"
  end
end
