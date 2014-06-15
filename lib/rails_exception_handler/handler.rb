class RailsExceptionHandler::Handler
  def initialize(env, exception)
    @exception = exception
    @env = env
    @request = ActionDispatch::Request.new(@env)
    @parsed_error = nil
    if(@env['action_controller.instance'])
    else
    end
  end

  def handle_exception
    @parsed_error = RailsExceptionHandler::Parser.new(@env, @request, @exception)
    store_error unless(@parsed_error.ignore?)
  end
  
  private

  def store_error
    RailsExceptionHandler.configuration.storage_strategies.each do |strategy|
      if(strategy.class == Symbol)
        RailsExceptionHandler::Storage.send(strategy, @parsed_error.external_info)
      elsif(strategy.class == Hash && strategy[:remote_url])
        RailsExceptionHandler::Storage.remote_url(strategy[:remote_url][:target],@parsed_error.external_info)
      else
        raise "RailsExceptionHandler: Unknown storage strategy #{strategy.inspect}"
      end
    end
  end

end

