#
# src/Word.rb
#
# Time-stamp: <2017-03-10 15:07:06 (ryosuke)>
require('Letter')

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
