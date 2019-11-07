include Math
require 'variables'

class ClassicHarm
  attr_accessor
  include ActiveModel::Model

  def initialize(notes, root, key)
    @notes = notes.map{ |n| n - key }
    @root = root - key
    @key = key
  end
end
