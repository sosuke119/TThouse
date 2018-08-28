<template>

    <li class="d-flex">

        <img v-bind:src="partner.profile_pic" alt="" class="rounded-circle ">
        <div class="ml-2">
          <p>
            {{ partner.first_name+" "+partner.last_name }}
          </p>
        </div>
        <span v-if="busy" v-on:click="stopConversation(partner.id)" class="service ml-auto">
          <button type="button" name="button">指派中</button>
        </span>
        <span v-if="!busy" v-on:click="setConversation(partner.id)" class="service ml-auto">
          <button type="button" name="button">指派</button>
        </span>
    </li>







</template>

<script>

export default {
  props: ["partner"],
  computed:{
    current_chatroom() {
      return this.$store.state.current_chatroom
    },
    busy() {
      return (this.partner.session.conversation_with_user_id && this.partner.session.status != 'done')
    }
  },
  methods:{
    setConversation(partner_id){
      $.ajax({
        url: "/sessions/handover_chat.json",
        data: {
          user_id: this.current_chatroom.user.id,
          receiver_id: partner_id,
        },
        method:"PATCH",
        success: (data) => {
          this.$store.commit('updateSession',data)
        }
      })

      $.ajax({
        url: "/sessions/handover_chat.json",
        data: {
          user_id: partner_id ,
          receiver_id: this.current_chatroom.user.id,
        },
        method:"PATCH",
        success: (data) => {
          this.$store.commit('updateSession',data)
        }
      })

    },
    stopConversation(partner_id){

      $.ajax({
        url: "/sessions/finish_conversation.json",
        data: {
          user_id: this.current_chatroom.user.id,
          receiver_id: partner_id,
        },
        method:"PATCH",
        success: (data) => {
          this.$store.commit('updateSession',data)
        }
      })

      $.ajax({
        url: "/sessions/finish_conversation.json",
        data: {
          user_id: partner_id ,
          receiver_id: this.current_chatroom.user.id,
        },
        method:"PATCH",
        success: (data) => {
          this.$store.commit('updateSession',data)
        }
      })

    },
  }
}
</script>

<style scoped>
.partner_img{
  width:40px;
  height:40px;
}

.border-bottom{
  border-bottom-right-radius: 0px;
  border-bottom-left-radius: 0px;
}
</style>
