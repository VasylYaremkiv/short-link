console.log 'test'


$ ->
  $('#create_new_short_url').on 'click', ->
    $error = $('.error')
    $error.html('')
    $new_short_url = $('.new-short-url')
    $new_short_url.hide() 
    $.ajax
      data: 
        short_url:
          origin_url: $('#original_short_url').val()
      dataType: 'json'
      method: 'post'
      success: (data) ->
        console.log data
        if data.success
          $new_short_url.find('strong').html(data.short_url)
          $new_short_url.show()
        else
          $error.html(data.errors)
