include Math
require 'variables'

class Structure
  attr_accessor :notes, :root, :relative_degrees, :length, :base, :inversion
  include ActiveModel::Model

  def initialize(notes, root, base)
    @notes = notes
    @root = root
    @relative_degrees = @notes.map { |note|
      note - root
    }
    @length = self.sort.map { |deg, acc| deg }
    @base = base
    #@inversion = self.inversion
  end

  def sort
    structure = self.relative_degrees.map { |note|
      [note.degree_odd, note.accidental]
    }
    structure.sort_by! { |note| note[0] }
  end

  def position
    position = {
      "3": [], "5": [], "7": [], "9": [], "11": [], "13": []
    }
    self.sort.each do |note|
      key = note[0]
      position[key.to_s.to_sym] << note[1] if key != 1
    end
    return position
  end

  def inversion
    deg_inv = ( self.base - self.root ).degree_odd
    inv = "none"
    if deg_inv == 1
      inv = ""
    elsif deg_inv >= 3 && deg_inv <= 7
      inv = "/#{base.note_name}"
    end
    return inv
  end

  def triad
    chord_tones = self.position
    triad = ""

    th = chord_tones[:"3"][0]
    fi = chord_tones[:"5"][0]
    if th == -1 && fi == -1
      triad = "dim"
    elsif th == -1 && fi == 0
      triad = "m"
    elsif th == 0 && fi == -1
      triad = "-5"
    elsif th == 0 && fi == 0
      triad = ""
    elsif th == 0 && fi == 1
      triad = "aug"
    elsif !th.present? && fi == 0 && chord_tones[:"11"][0] == 0
      triad = "sus4"
      self.length.delete(11)
      self.length.push(4)
    elsif th && !fi
      triad = " omit5 "
    elsif !th && fi
      triad = " omit3 "
    elsif !th && !fi
      triad = " omit3 omit5 "
    else
      triad = "?"
    end
    return triad
  end

  def seventh
    seventh = ""
    seventh_accidental = self.position[:"7"][0]
    thirteenth_accidental = self.position[:"13"][0]
    if seventh_accidental.present?
      seventh = ["𝄫", "", "Δ"][ 2 + seventh_accidental ] + "7"
    elsif thirteenth_accidental == 0 && self.inversion == ""
      seventh = "6"
      self.length.delete(13)
      self.length.push(6)
    end
    return seventh
  end

  def tension
    tension = ""
    array_accidental = ["𝄫", "♭", "", "#", "𝄪"]

    ninth      = self.position[:"9"][0]
    eleventh   = self.position[:"11"][0]
    thirteenth = self.position[:"13"][0]

    tension += "(#{ array_accidental[2 + ninth] }9)"       if ninth.present?
    tension += "(#{ array_accidental[2 + eleventh] }11)"   if eleventh.present? && self.triad != "sus4"
    tension += "(#{ array_accidental[2 + thirteenth] }13)" if thirteenth.present? && self.seventh != "6"
    
    tension.gsub(/\)\(/, ", ")
    #binding.pry
  end

  def borrowing_key(tonic, scale_type) # Structureインスタンスに対して所属する借用調を五度圏表記で表示する
    notes = self.notes
    borrowing_key = ""
    if scale_type == "maj"
      notes.map! { |note| note - tonic }
      if notes.min >= -1
        if notes.max <= 5
          borrowing_key = 0
        elsif notes.max == 6
          borrowing_key = 1
        elsif notes.max == 7
          borrowing_key = 2
        elsif notes.max == 8
          borrowing_key = 3
        elsif notes.max == 9
          borrowing_key = 4
        elsif notes.max == 10
          borrowing_key = 5
        elsif notes.max == 11
          borrowing_key = 6
        end
      elsif notes.max <= 5
        case notes.min
        when -2
          borrowing_key = -1
        when -3
          borrowing_key = -2
        when -4
          borrowing_key = -3
        when -5
          borrowing_key = -4
        when -6
          borrowing_key = -5
        when -7
          borrowing_key = -6
        end
      end
    elsif scale_type == "min"
    end
    return borrowing_key
  end

end
