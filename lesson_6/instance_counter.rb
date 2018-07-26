module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :instance_counter

    def instances_amount
      instance_counter
    end
  end

  module InstanceMethods
    protected

    def instance_count
      self.class.instance_counter ||= 0
      self.class.instance_counter += 1
    end
  end
end
