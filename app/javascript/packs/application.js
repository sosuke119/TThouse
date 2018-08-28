import TurbolinksAdapter from 'vue-turbolinks'
import VueResource from 'vue-resource'
import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'
import App from '../app.vue'

Vue.use(TurbolinksAdapter)
Vue.use(Vuex)
Vue.use(VueResource)
Vue.use(require('vue-moment'));

window.store = new Vuex.Store({
  state: {
    chatrooms: [],
    current_chatroom: Object,
    message_logs:[],
  },

  mutations: {
    addMessageLog(state, data) {
      const index = state.chatrooms.findIndex(chatroom => chatroom.user.id == data.user_id)
      state.chatrooms[index].message_logs.push(data)
    },
    updateSession(state, data) {
      const index = state.chatrooms.findIndex(chatroom => chatroom.user.id == data.user_id)
      state.chatrooms[index].user.session = data
    },
  }
})

document.addEventListener("turbolinks:load", function() {
  var element = document.querySelector("#boards")

  if (element != undefined) {
    Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    
    window.store.state.chatrooms         = JSON.parse(element.dataset.chatrooms)
    window.store.state.current_chatroom  = window.store.state.chatrooms[0]
    if (window.store.state.chatrooms[0])
      window.store.state.message_logs    = window.store.state.chatrooms[0].message_logs

    const app = new Vue({
      el: element,
      store: window.store,
      template: "<App />",
      components: { App }
    })
  }
});

