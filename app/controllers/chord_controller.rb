class ChordController < ApplicationController
  def format_notes
    tonic = set_tonic
    #scale = params[:tonality][:scaleType]
    params[:notes].permit!.to_h.map { |i, value|
      position_in_C = value[:chromatic].to_i.to_fifth
      position_in(tonic, position_in_C)
    }
  end

  def set_roots
    chord_structures = format_notes.map { |root|
      Structure.new(format_notes, root)
    }
    classic_harms = chord_structures.map { |structure|
      ClassicHarm.new(structure.notes, structure.root, structure.borrowing_key)
    }
    [chord_structures, classic_harms]
  end

  def determinate_chord
    chord_structures = set_roots[0]
    tonic = set_tonic
    @chord_names = []
    chord_structures.each do |structure|
      chord_name = (structure.root + tonic).note_name + tetrad( structure.triad, structure.seventh ) + structure.tension
      complexity = structure.length.max
      @chord_names << [ chord_name, complexity ]
    end
    @chord_names.sort! { |a, b|
      a[1] <=> b[1]
    }.map! { |chord|
      chord[0]
    }


  end


  def set_tonic
    params[:tonality][:tonic].to_i
  end

  def set_scale_type
    params[:tonality][:scaleType].to_i
  end

  def position_in(tonic, position_in_C)
    ( position_in_C + 4  - tonic ) % 12 - 4
  end

  def tetrad(triad, seventh)
    tetrad = ""
    if triad == "dim"
      if seventh == "𝄫7"
        tetrad = "dim7"
      elsif seventh == "7"
        tetrad = "m7♭5"
      else
        tetrad = triad + seventh
      end
    elsif triad == "-5" || triad == "sus4"
      tetrad = seventh + triad
    else
      tetrad = triad + seventh
    end
    tetrad
  end

end