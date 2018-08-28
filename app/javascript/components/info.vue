<template lang="pug">



  #info
   .user-image.d-flex
     img.rounded-circle(v-bind:src='current_chatroom.user.profile_pic')
     div
       h4 {{ current_chatroom.name }}
       button#btn-addContactPerson
         i.fas.fa-plus
         span 新增聯絡人

   .user-message
     img(src="images/message.png", alt="")
     input#message(type="text" :placeholder="current_chatroom.name")
     img#img-line(src="images/icon-line.png", alt="")
     input#space(type="text" placeholder="暫存")

     .user-detail
       .user-city
         span 現居城市
         input(type="text"  v-model="current_user.address")
       .user-number
         span 電話號碼
         input(type="text" placeholder="0963-383-234")
       .user-email
         span 電子郵件
         input(type="text" v-model="current_user.email")
       .user-tag
         span 用戶標籤
         img(src="images/icon-add.png", alt="" v-on:click="showTag = !showTag" v-if="!showTag")
         img(src="images/icon-add4.png", alt="" v-on:click="showTag = !showTag" v-if="showTag")
         .user-tag-add(v-if="showTag")
           input(type="text" placeholder="新增標籤" v-model="userTag")
           img(src="images/icon-add.png", @click="submitUserTag" v-model="userInfo.tag")
       .user-tag-list(v-for="(item, index) in userTags")
         button.user-tag-list-button.d-flex
           p {{item.userTag}}
           #btn-delete(@click="deleteUserTag(index)" v-on:mouseover="changeImg")


</template>

<script>



export default {
  // components: { partner_list },
  data: function() {
    return {
      showPartners: false,
      showTag: false,
      userTag: '',
      userTags:[],
      userInfo:'',
      //- current_user: Object
    }
  },
  //- mounted: function(){
  //-   current_user = current_chatroom.user
  //- },
  computed: {
    current_chatroom() {
      return this.$store.state.current_chatroom
    },
    current_user(){
      return this.current_chatroom.user
    },
    chatrooms(){
      return this.$store.state.chatrooms
    },
    status() {
      if (this.current_chatroom.user.session){
        if (this.current_chatroom.user.session.conversation_with_user_id){
          return "conversation"
        }
        else if (this.current_chatroom.user.session.state == 'handed_over' & !this.current_chatroom.user.session.finished_at){
          return "handed_over"
        }
      }
      else{
        return "normal"
      }
    },
    user_is_partner_index() {
      var index = this.partners.findIndex(
        partner => partner.id == this.current_chatroom.user.id)
      return index
    },
    current_partner_index() {
      if ( this.current_chatroom.user.session.status != 'done' ){
        var receiver_id = this.current_chatroom.user.session.conversation_with_user_id
        var index = this.partners.findIndex(
          partner => partner.id == receiver_id)
        return index
      }
      else{
        return -1
      }
    },
    showing_partners() {
      var partners_array        = this.partners
      var current_partner_index = this.current_partner_index
      var user_is_partner_index = this.user_is_partner_index

      // if (current_partner_index != -1 ){
      //   partners_array.splice(current_partner_index, 1)
      // }
      if (user_is_partner_index != -1 ){
        partners_array.splice(user_is_partner_index, 1)
      }

      return partners_array
    }
  },
  methods:{
    changeImg(){
      console.log(this.img);
      this.src = 'images/icon-add4.png'
    },
    submitUserTag(){
      this.userTags.push({
        userTag: this.userTag
      })
      this.userTag = ''
    },
    deleteUserTag(index){
      this.userTags.splice(index, 1)
    }, 
    stopConversationAndHandover(partner_id){
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

      $.ajax({
          url: "/sessions/finish_handover_chat.json",
          data: {user_id: this.current_chatroom.user.id },
          method:"PATCH",
          success: (data) => {
            this.$store.commit('updateSession',data)
          },
        });

      $.ajax({
          url: "/sessions/finish_handover_chat.json",
          data: {user_id: partner_id },
          method:"PATCH",
          success: (data) => {
            this.$store.commit('updateSession',data)
          },
        });
    }
  }
}
</script>

<style lang="scss" scoped>

@import 'app/assets/stylesheets/chatrooms.sass';


</style>
