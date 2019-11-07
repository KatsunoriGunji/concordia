class NotesController < ApplicationController
  def index
  end

  def new
    @sounds = []
    params[:sounds].each do |sound|
      new_sound = Sound.new()
      new_sound.set_sound(sound[1][:chromatic].to_i, sound[1][:register].to_i)
      @sounds << new_sound
    end
    respond_to do |format|
      format.html
      format.json
    end
  end
end