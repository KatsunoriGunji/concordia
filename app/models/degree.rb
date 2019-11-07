include Math
require 'variables'

class Degree
  attr_reader :fifth, :tonic_fifth, :degree_fifth, :abs_name_in_tonal, :abs_accidental_in_tonal
  include ActiveModel::Model

  def set_note(chromatic, tonic)
    @fifth = ( chromatic * 7 + 4 - tonic ) % 12 - 4 + tonic
    @chromatic = chromatic
    @tonic_fifth = tonic
    @abs_name_in_tonal  = (@fifth * 4) % 7
    r = (@fifth + 1) % 7 - 1
    @abs_accidental_in_tonal  = ( @fifth - r ) / 7
  end
  
  def degree_name(root)
    diff = @fifth - root
    return (diff * 4 ) % 7
  end

  def degree_accidental(root)
    diff = @fifth - root
    whole = ( diff + 1 ) % 7 - 1
    return ( diff - whole ) / 7
  end
end