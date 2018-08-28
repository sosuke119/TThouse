<template lang="pug">



div(v-if=" !message_log.message_type.includes('echo')")

  .d-flex.flex-row.user-content-message-left(:current_chatroom="current_chatroom")
    img.rounded-circle(v-bind:src='current_chatroom.user.profile_pic') 
    p(v-if='message') {{ message }}
    span {{ message_log.created_at | moment("hh:mm") }}
    
div(v-else='')
  .d-flex.flex-row-reverse.user-content-message-right
    img(src="images/pic-saymac.png", alt="" v-if='message')
    p(v-if='message') {{ message }}
    span {{ message_log.created_at | moment("hh:mm") }}





</template>


<script>

export default {
  props: ["message_log","index"],
  computed:{
    current_chatroom (){
      return this.$store.state.current_chatroom
    },
    lastMessage () {
      this.message_log
    },
    message () {
      if (this.message_log.text !== null &
        this.message_log.text !== "None" &
        this.message_log.echo_attachments ) {
        return this.message_log.text+"template"
      }
      if (this.message_log.echo_attachments) {
        return "template"
      }
      if (this.message_log.payload_name) {

        return this.message_log.payload_name
      }
      if (this.message_log.text !== null &
        this.message_log.text !== "None") {
        return this.message_log.text
      }

      return null
    },
    message_template() {
      return JSON.parse(this.message_log.echo_attachments.replace(nil,null))
    }

  }
}
</script>

<style lang="scss"scoped>
@import 'app/assets/stylesheets/chatrooms.sass';

</style>
