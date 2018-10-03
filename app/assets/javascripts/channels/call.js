App.calls = App.cable.subscriptions.create('CallChannel', {
  connected: function() {
  },

  disconnected: function() {
  },

  received: function(data) {
    $('#caller-information').html(data.known_users)
  }
});