#
# Experiment.rb
#
# Time-stamp: <2017-02-22 01:51:52 (ryosuke)>

class Element
  attr_accessor :id
  def initialize(id)
    @id = id
  end
end

class Letter < Element
  def initialize(id, char)
    super(id)
    @char = char
  end
end

class Word < Element
  def initialize(id)
    super(id)
    @elements = []
  end

  def add(elem)
    @elements << elem
  end

  def remove(elem)
    @elements.delete(elem)
  end

myword = Word.new(0)
myword.add(Letter.new(1, "a"))
myword.add(Letter.new(2, "b"))
myword.add(Letter.new(3, "c"))

p myword
end
#-------------------------------------------------
# class Component
#   attr_accessor :name
#   def initialize(name)
#     @name = name
#   end
# end

# class FileComponent < Component
#   def initialize(name)
#     super(name)
#   end
# end

# class DirectoryComponent < Component
#   def initialize(name)
#     super(name)
#     @components = []
#   end

#   def add(component)
#     @components << component
#   end

#   def remove(component)
#     @components.delete(component)
#   end

# end

# picture = DirectoryComponent.new("PICTURE")
# picture.add(FileComponent.new("child.jpg"))
# picture.add(FileComponent.new("car.jpg"))
# picture.add(FileComponent.new("landscape.jpe"))

# usb = DirectoryComponent.new("UsbDevice")
# usb.add(picture)

#End of File
