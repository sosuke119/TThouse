<template>
    <li v-on:click="clickChatroom"  :class="{current: isActive(chatroom.id)}" class="d-flex user-list-wrap" >
      <img v-bind:src="chatroom.user.profile_pic" alt="" class="rounded-circle user-list-img-big">

      <div class="p-2 mr-auto flex-column" >
        <div class="user-list-name" style="color:#000;">
          {{ chatroom.user.first_name }}{{ chatroom.user.last_name }}
        </div>
        <div class="user-list-message">
          {{ messageLength || '' }}
        </div>
      </div>
      <div class="user-list-last">
        <p class="user-list-time">
          {{ chatroomLastMessage.created_at | moment("YYYY-MM-DD HH:mm")}}
        </p>

          <img v-if="showBell" src="images/icon-bell.png" class="user-list--img-small" width="20px" height="20px" >
          <img v-else-if="showPartnerProfilePic" v-bind:src="receiverProfilePic" class="user-list--img-small" width="20px" height="20px" >
          <div v-else="" ></div>

      </div>
    </li>




</template>

<script>

export default {
  props: ["chatroom"],
  data: function() {
    return {
      showBell: false
    }
  },
  computed: {
    showPartnerProfilePic(){
      if (this.receiver != null ){
        if (this.receiverProfilePic != ''){
          return true
        }
      }
      return false
    },
    messageLength(){
      var string = this.chatroomLastMessage.text
      return string.length > 7 ? string.substring(0, 10) + " .." : string
    },
    receiverProfilePic(){
      if(this.receiver != null && this.chatroom.user.session.status == 'conversation'){
        return this.receiver.profile_pic
      }else {
        return ''
      }
    },
    chatroomLastMessage() {
      if (this.chatroom.message_logs[this.chatroom.message_logs.length - 1])
        return this.chatroom.message_logs[this.chatroom.message_logs.length - 1]
    },
    receiver() {
      const index = this.$store.state.chatrooms.findIndex(chatroom => chatroom.user.id == this.chatroom.user.session.conversation_with_user_id)
      if (this.$store.state.chatrooms[index] != null){
        return this.$store.state.chatrooms[index].user
      }else{
        return null
      }


    },
    status(){
      return this.chatroom.user.session.status
    },
    statusIcon() {
      switch( this.status ) {
        case 'handed_over':
          return '接管中'
        case 'conversation':
          return '和「'+this.receiver.first_name+'」對話中'
        default:
           return false
      }
    },
  },
  methods:{
    clickChatroom(){
      this.showBell = false
      this.swichChatroom()
    },
    swichChatroom() {
      this.$store.state.message_logs = this.chatroom.message_logs
      this.$store.state.current_chatroom  = this.chatroom
    },
    isActive(id) {
      return this.$store.state.current_chatroom.id == id
    },

  },
  watch:{
    alertStatus: function(val, oldVal){
      if (oldVal == 'bot' && val == 'handed_over'){
        this.showBell = true
      }
    }
  }
}
</script>

<style lang="sass" scoped>
.user-list-last
  img
    width: 20px
    margin-left: 100px

</style>
