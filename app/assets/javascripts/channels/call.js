App.calls = App.cable.subscriptions.create('CallChannel', {
  connected: function() {
  },

  disconnected: function() {
  },

  received: function(data) {
    document.querySelector('#caller-information').innerHTML = data
  }
});