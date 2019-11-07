$(document).on("turbolinks:load", function() {
  var notes = [];
  $(document).on("click", ".key", function(){
    thisKey = this;
    var noteChromatic = $(thisKey).data('chromatic');
    var noteRegister = $(thisKey).parent().data('register');
    var note = {chromatic: noteChromatic, register: noteRegister};
    $('.chord-name').empty();
    
    $(thisKey).removeClass("key");
    $(thisKey).addClass("key--selected");
    notes.push(note);
    var tonicName = $(".tonic-name").val();
    var accidental = $(".accidental").val();
    var scaleType = $(".scale-type").val();
    tonality = {tonic: Number( tonicName ) + Number( accidental ), scaleType: scaleType};
    $.ajax({
      type: 'GET',
      url: '/chord/determinate_chord',
      data: { notes: notes,
              tonality: tonality
      },
      dataType: 'json'
    })
    .done(function(data){
      $('.chord-name').empty();
      $.each(data.notes, function(i){
        $('.chord-name').append(
          `${data.notes[i]}<br>`
        );
      });
    })
  });
  $(document).on("click", ".key--selected", function(){
    thisKey = this;
    var noteChromatic = $(thisKey).data('chromatic');
    var noteRegister = $(thisKey).parent().data('register');
    var note = {chromatic: noteChromatic, register: noteRegister};
    $('.chord-name').empty();

    $(thisKey).removeClass("key--selected");
    $(thisKey).addClass("key");
    notes = notes.filter(function(ele){
      return ele.chromatic != note.chromatic || ele.register != note.register;
    });
    var tonicName = $(".tonic-name").val();
    var accidental = $(".accidental").val();
    var scaleType = $(".scale-type").val();
    tonality = {tonic: Number( tonicName ) + Number( accidental ), scaleType: scaleType};
    $.ajax({
      type: 'GET',
      url: '/chord/determinate_chord',
      data: { notes: notes,
              tonality: tonality
      },
      dataType: 'json'
    })
    .done(function(data){
      $('.chord-name').empty();
      $.each(data.notes, function(i){
        $('.chord-name').append(
          `${data.notes[i]}<br>`
        );
      });
    })
  });
  $(".tonality").on("change", function(){
    var tonicName = $(".tonic-name").val();
    var accidental = $(".accidental").val();
    var scaleType = $(".scale-type").val();
    tonality = {tonic: Number( tonicName ) + Number( accidental ), scaleType: scaleType};
    $.ajax({
      type: 'GET',
      url: '/chord/determinate_chord',
      data: { notes: notes,
              tonality: tonality
      },
      dataType: 'json'
    })
    .done(function(data){
      $('.chord-name').empty();
      $.each(data.notes, function(i){
        $('.chord-name').append(
          `${data.notes[i]}<br>`
        );
      });
    })
  });
  $("#sound").on("click", function(){
    $.ajax({
      type: 'GET',
      url: '/notes/new',
      data: { notes: notes },
      dataType: 'json'
    })
    .done(function(notes){
    })
    .fail(function(notes){
      alert('キーボードを押してください')
    })
  });
  $("#clear").on("click", function(){
    notes = [];
    $('.chord-name').empty();
    $(".key--selected").each(function(i, key){
      $(key).removeClass("key--selected");
      $(key).addClass("key");
    });
  });
});