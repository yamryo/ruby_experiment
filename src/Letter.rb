#
# src/Letter.rb
#
# Time-stamp: <2017-03-03 18:27:21 (ryosuke)>
require('Element')

class Letter
  include Element
  #---
  def initialize(char = '1', name: nil)
    super()
    @factors = nil
    unless char[0] =~ /[1a-zA-Z]/
      raise InvalidArgument, "You can use alphabet and '1'"
    end
    @char = char[0]
    @name = name.nil? ? char : name
    @length = 1
  end
  attr_reader :char, :length
  #---
  def show
    p @name
  end
  #---
  def inverse?
    # binding.pry if @char == 'A'
    @char == @char.upcase
    # nil if @char == '1'
  end
  #---
  def =~(other)
    raise(InvalidArgument) unless other.is_a?(Letter)
    @char.downcase == other.char.downcase
  end
  #---
  def ==(other)
    (self =~ other) && (inverse? == other.inverse?)
  end
  #---
  def ===(other)
    raise(InvalidArgument) unless other.is_a?(Letter)
    @object_id == other.object_id
  end
  #---
  def <=>(other)
    raise(InvalidArgument) unless other.is_a?(Letter)
    show <=> other.show
  end
  #---
  def product_with(another)
    Word.new * self * another
  end
  #---
  def inversion
    inv_char = inverse? ? @char.downcase : @char.upcase
    inv_s = '^{-1}'
    inv_name = @name.end_with?(inv_s) ? @name.gsub(inv_s, '') : @name + inv_s
    Letter.new(inv_char, name: inv_name)
  end
end

#-------------
# End of File
#-------------
