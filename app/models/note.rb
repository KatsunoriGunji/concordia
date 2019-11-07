include Math
require 'variables'

class Note
  attr_reader :fifth, :register, :tonic_fifth, :degree_fifth,
              :abs_name_in_tonal, :abs_accidental_in_tonal
  include ActiveModel::Model

  def initialize(fifth, register)
    @fifth = fifth
    @register = register
  end

  def set_note(chromatic, tonic)
    @fifth = ( chromatic * 7 + 4 - tonic ) % 12 - 4 + tonic
    @chromatic = chromatic
    @tonic_fifth = tonic
    @abs_name_in_tonal  = (@fifth * 4) % 7
    r = (@fifth + 1) % 7 - 1
    @abs_accidental_in_tonal  = ( @fifth - r ) / 7
  end
  
  def -(note)
    self_chromatic = ( 7 * self.fifth ) % 12
    self_register  = self.register
    self_height    = (self_chromatic.to_s + self_register.to_s).to_i(12)
    if note.class == "Note"
      note_chromatic = ( 7 * note.fifth ) % 12
      note_register  = note.register
      note_height    = (note_chromatic.to_s + note_register.to_s).to_i(12)
      height = note.fifth
      register -= note.register
    elsif note.class == "Integer"
      fifth -= note
    end
    Note.new(fifth, register)
  end

  # def degree_accidental(root)
  #   diff = @fifth - root
  #   whole = ( diff + 1 ) % 7 - 1
  #   return ( diff - whole ) / 7
  # end
end