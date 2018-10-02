$(document).on('ready page:load page:restore', attachFileUpdateEvent)

function attachFileUpdateEvent() {
  $('#file').change(function(e) {
    const file = $('#file')[0].files[0]
    if(file) {
      $('.import-button').prop('disabled', false)
      $('#filename').text(file.name)
    } else {
      $('.import-button').prop('disabled', true)
      $('#filename').text("Select a file to see it's name")
    }
  });
}
