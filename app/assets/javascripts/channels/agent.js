App.call = App.cable.subscriptions.create('AgentChannel', {
  connected: function() {
    $('body').addClass('agentChannelConnect')
  },

  disconnected: function() {

  },

  received: function(data) {
    $('.container').prepend("<div class='alert alert-danger alert-dismissible margin-v' role='alert'>"
        + data.message +
        "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button></div>")
  }
});