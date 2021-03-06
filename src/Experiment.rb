#
# Experiment.rb
#
# Time-stamp: <2017-03-01 13:32:14 (ryosuke)>

#----------------------------
module Element
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
#----------------------------
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
    @char == a_letter.char
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
    show <=> another.show
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
#----------------------------
class Word
  include Element
  #---
  Identity = Letter.new
  #---
  def initialize(str = '')
    super()
    set(str)
  end
  #---
  def set(str)
    raise InvalidArgument unless str.is_a?(String)
    @factors = []
    str.each_char { |c| self * Letter.new(c) if c =~ /[1a-zA-Z]/ }
    self
  end
  #---
  def flatten
    Word.new(to_s)
  end
  def flatten!
    set(to_s)
  end
  #---
  def show_parens
    @factors.map { |f| (f.length == 1) ? f.show : "(#{f.show_parens})" }.join
  end
  #---
  def pop
    @factors.pop
  end
  #---
  def gen_at(int)
    (@factors.flatten)[int]
  end
  def [](int)
    gen_at(int)
  end
  #---
  def contract
    # binding.pry
    ff = @factors.flatten
    #
    size_diff = 1
    while (size_diff > 0 && ff.size > 1)
      previous_size = ff.size
      #
      ff.each_with_index do |_, idx|
        next if (idx >= ff.size - 1)
        pair = ff.slice!(idx, 2)
        if (pair[0] =~ pair[1])
          # DO SOMETHING
        end
        ff.insert(idx, pair[0] * pair[1]).flatten! if pair[0].show
      end
      #
      size_diff = previous_size - ff.size
    end
    #
    set(ff.flatten.join)
  end
end

#-------------
# End of File
#-------------
