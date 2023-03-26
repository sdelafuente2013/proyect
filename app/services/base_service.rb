class BaseService
  def self.call(*args)
    new(*args).call
  end

  def self.call!(*args)
    new(*args).call!
  end
end
