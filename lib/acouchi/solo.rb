require "httparty"
require "json"

module Acouchi
  class Solo
    MENU = 82
    LEFT = 21
    RIGHT = 22

    def initialize(configuration)
      @configuration = configuration
    end

    def send_key key
      call_method("sendKey", [key])
    end

    def enter_text text, index=0
      call_method("enterText", [index, text])
    end

    def clear_text index=0
      call_method("clearEditText", [index])
    end

    def has_text? text, options={}
      options = {
        :scroll          => true,
        :minimum_matches => 0,
        :must_be_visible => true
      }.merge(options)
      call_method("searchText", [
        text,
        options[:minimum_matches],
        options[:scroll],
        options[:must_be_visible]
      ])
    end

    def buttons
      call_method("getCurrentButtons")
    end

    def has_button? text
      buttons.any? { |b| b["text"] == text }
    end

    def text_views
      call_method("getTextViews")
    end

    def content
      call_method("getCurrentContent")
    end

    def all_content
      all_content = []
      until scroll_up == false; end
      begin
        all_content << text_views.map {|t| t["text"]}
      end while scroll_down
      all_content << text_views.map {|t| t["text"]}
      all_content.flatten.uniq
    end

    def click_text text, options={}
      options = {
        :match => 1,
        :auto_scroll => true
      }.merge(options)
      call_method("clickOnText", [
        text,
        options[:match],
        options[:auto_scroll]
      ])
    end

    def click_menu_item text, options={}
      options = {
        :sub_menu => true
      }.merge(options)
      call_method("clickOnMenuItem", [
        text,
        options[:sub_menu]
      ])
    end

    def views
      call_method("getViews")
    end

    def click_view id
      call_method("clickOnViewById", [id])
    end

    def click_image index
      call_method("clickOnImage", [index])
    end

    def scroll_up
      call_method("scrollUp")
    end

    def scroll_down
      call_method("scrollDown")
    end

    def scroll_up_list index=0
      call_method("scrollUpList", [index])
    end

    def scroll_down_list index=0
      call_method("scrollDownList", [index])
    end

    def scroll_to_left
      call_method("scrollToSide", [LEFT])
    end

    def scroll_to_right
      call_method("scrollToSide", [RIGHT])
    end

    def go_back
      call_method("goBack")
    end

    def wait_for_text text, options = {}
      options = {
        :minimum_number_of_matches => 0,
        :timeout                   => 20,
        :scroll                    => true,
        :must_be_visible           => true
      }.merge(options)
      call_method("waitForText", [
        text,
        options[:minimum_number_of_matches],
        options[:timeout],
        options[:scroll],
        options[:must_be_visible]
      ])
    end

    private
      def call_method name, arguments = []
        arguments = arguments.map {|a| a.to_s}
        options = { :body => {:parameters => arguments.to_json} }
        response = HTTParty.post("http://127.0.0.1:#{@configuration.port}/execute_method/#{name}", options)
        json = JSON.parse(response.body, :max_nesting => 100)

        if json.empty?
          nil
        else
          json["result"]
        end
      end
  end
end
