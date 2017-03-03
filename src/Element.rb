#
# src/Element.rb
#
# Time-stamp: <2017-03-03 18:06:19 (ryosuke)>

module Element #:nodoc: all
  #---
  InvalidArgument = Class.new(ArgumentError)
  #---
  def initialize
    @factors = []
    @name = ''
    set_name
  end
  #---
  def set_name
    @name = @factors.map(&:show).join
  end
  #---
  def show
    @name
  end
  def to_s
    show
  end
  #---
  def length
    @factors.length
  end
  #---
  def product_with(another_element)
    raise(InvalidArgument) unless another_element.is_a?(Element)
    @factors << another_element
    set_name
    self
  end
  def *(other)
    product_with(other)
  end
  #---
  def ==(other)
    show == other.show
  end
end
