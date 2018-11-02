App.calls = App.cable.subscriptions.create('CallChannel', {
  connected: function() {
    $('body').addClass('callChannelConnect')
  },

  disconnected: function() {
  },

  received: function(data) {
    window.location = '/zendesk/users/search_results?search=*' + data.search_param
  }
});