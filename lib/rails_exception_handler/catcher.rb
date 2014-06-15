class RailsExceptionHandler

  def self.catch(&block)
    begin
      block.call
    rescue Exception => exception
      raise exception
    end
  end

end
