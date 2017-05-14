module Aaalex
  module DetectMobiles
    def detect_mobiles
      case
      when is_request_from_iphone?
        request.format = :iphone
        logger.debug "detected iPhone -> request.format = :iphone"
      when is_request_from_mobile?
        request.format = :mobile
        logger.debug "detected mobile browser -> request.format = :mobile"
      end
    end

    def is_request_from_iphone?
      request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
    end

    def is_request_from_mobile?
      return true if request.env["HTTP_X_WAP_PROFILE"]
      return true if request.env["HTTP_ACCEPT"] && /wap\.|\.wap/ =~ request.env["HTTP_ACCEPT"]
      reg_arr =      %w{midp j2me avantg docomo novarra palmos palmsource 240x320 opwv chtml pda windows\ ce mmp\/ blackberry}
      reg_arr.concat %w{mib\/ symbian wireless nokia hand mobi phone cdm up\.b audio SIE\- SEC\- samsung HTC mot\- mitsu sagem}
      reg_arr.concat %w{sony alcatel lg eric vx NEC philips mmm xx panasonic sharp wap sch rover pocket benq java pt pg vox}
      reg_arr.concat %w{amoi bird compal kg voda sany kdd dbt sendo sgh gradi jb \d\d\di moto"}
      reg_arr.each do |reg_exp|
        return true if Regexp.new(reg_exp) =~ request.env["HTTP_USER_AGENT"]
      end
      return false
    end
  end
end

raise( "cannot find actionpack") unless defined? ActionController
ActionController::Base.send(:include, Aaalex::DetectMobiles)
