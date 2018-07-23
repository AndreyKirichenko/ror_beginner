module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :instances

    def instances_amount
      instances.size
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instances ||= []
      self.class.instances << self
    end
  end
end
