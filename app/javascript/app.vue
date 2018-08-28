<template lang="pug">
  #app
    .row
      .d-sm-none.col-12.border.fixed-top.bg-white(style='height:50px')
    .row
      .container-fluid
        .header
          .float-left
            .logo
              img(src="images/pic-saymacLogo.png", alt="")

          .float-right.user.d-flex
            .user-name UserName
            .user-login 登出
            .user-image
              img(src="images/pic-user2.png", alt="")

    .row
      .col-3.p-0.side-bar
        .col-12.search-wrap
          .search-wrap-box
            i.fas.fa-search
            input(type="text", placeholder="搜尋對話")


        .col-12.menu-wrap.p-0.d-flex(v-on:click="showChatroomOptions = !showChatroomOptions")
          i.fas.fa-bars
          p {{selectedChatroomsTypeName(selectedChatroomType)}} ( {{selectedChatroomsCount(selectedChatroomType)}} )

        .col-12.menu-fixed.p-0(v-if="showChatroomOptions")
          ul.list-group.list-group-flush.justify-content-center
            li(v-on:click="selecteChatroomType('all')", :class="{'current' : selectedChatroomType == 'all' }")
              p(style="font-weight: normal;") 全部對話 ({{ selectedChatroomsCount('all') }})
              
            li(v-on:click="selecteChatroomType('bot')", :class="{'current' : selectedChatroomType == 'bot' }")
              p 線上對話中 ({{ selectedChatroomsCount('bot') }})
             
            li(v-on:click="selecteChatroomType('handed_over')", :class="{'current' : selectedChatroomType == 'handed_over' }")
              p 後台人員對話中 ({{ selectedChatroomsCount('handed_over') }})
            li(v-on:click="selecteChatroomType('conversation')", :class="{'current' : selectedChatroomType == 'conversation' }")
              p 轉接指派人員對話中 ({{ selectedChatroomsCount('conversation') }})


        .col-12.p-0.user-list
          ul.list-group.list-group-flush
            chatroom(v-for='chatroom in selectedChatrooms', :chatroom='chatroom', :key='chatroom.id')

      .col-9.p-0.user-top
        .row.p-0(style="border-left: 1px solid #808080;border-bottom: 1px solid #808080;")
          .col-auto.mr-auto(style="padding-left: 10px;")
            .user-top-left.d-flex(:current_chatroom="current_chatroom")
              img.rounded-circle(v-bind:src='current_chatroom.user.profile_pic')            
              h4 {{ current_chatroom.name }}
                p {{ current_chatroom.updated_at | moment("YYYY-MM-DD HH:mm")}}
              
          .col-auto.user-top-right.p-0.d-flex
            .service-appoint(:class="{flex: serviceAppoint}")
              img.img-user(src="images/user-1.png", alt="")
              div
                p.service-name XinyuLin
                p.service-time(v-if='last_echo_message_log') {{last_echo_message_log.created_at | moment("hh:mm") }}
              img#pic-appoint(src="images/icon-service.png", alt="")
              button#btn-appoint(v-on:click="showServiceAppointList = !showServiceAppointList") 指派客服
            img#btn-info(src="images/icon-i.png", alt="" v-if="!isError" v-on:click='isError = !isError')        
            img#btn-info(src="images/icon-ihover.png", alt="" v-if="isError" v-on:click='isError = !isError')        
          

        .user-content(:class="{ r300: isError }")
          .user-content-message#main(:class="{ r300: isError }")
            message_log(v-for='(message_log, index) in message_logs ', :message_log='message_log', :key='message_log.id')
            
          .d-flex.justify-content-between.user-content-message-submit(:class="{ r300: isError}")
            .UCMS-upload
              label(for='file-upload' style="margin-bottom: 0px;")
                img.btn-add(src="images/icon-add3.png", alt="")
              input#file-upload(type='file')
            
            .UCMS-inputMessage
              input#main-message(type="text" placeholder="輸入訊息 .." v-on:keypress.enter='submitMessage' v-model='message', ref='message')
          
            
            .UCMS-submit.d-flex(:class="{ r300: isError }")
              img.btn-submit(src="images/icon-submit.png" v-on:click='submitMessage' )
              button#btn-endService(v-if="serviceAppoint" v-on:click='stopHandoverChat') 結束客服
  

                
        .user-info(v-if='isError')
          info(:current_chatroom="current_chatroom")
        
        .partner(v-if='showServiceAppointList')
          i.fas.fa-search
          input(type="text", placeholder="搜尋客服人員")
          ul
            partner_list(v-for='partner in partners', :partner='partner', :key='partner.id')      

</template>


<script>

import chatroom from 'components/chatroom'
import message_log from 'components/message_log'
import info from 'components/info'
import partner_list from 'components/partner_list'



export default {
  components: { message_log, chatroom, info, partner_list },

  data: function() {
    return {
      message: "",
      selectedChatroomType: 'all',
      showChatroomOptions: false,
      isError: false,
      showServiceAppointList: false
    }
  },
  computed: {    
    chatrooms (){
      return this.$store.state.chatrooms
    },
    current_chatroom (){
      return this.$store.state.current_chatroom
    },
    message_logs () {
      return this.$store.state.message_logs
    },
    status() {
      return this.current_chatroom.user.session.status
    },
    takingOver(){
      return (this.status == 'handed_over' )
    },
    selectedChatrooms() {
      const chatroomType = this.selectedChatroomType
      if (chatroomType != 'all') {
        return this.chatrooms.filter(function(c) {
          return c.user.session.status == chatroomType
        })
      }
      else{
        return this.chatrooms
      }
    },
    partners() {
      var partners_chatrooms = this.chatrooms.filter(function(c) {
          return c.user.role == 'partner'
        })
      return partners_chatrooms.map(c => c.user)
    },
    serviceAppoint() {
      if ( (this.status == 'conversation') || (this.status == 'handed_over') ){
        return true  
      }else{
        return false
      }
    },
    last_echo_message_log() {
      var echo_message_logs = this.message_logs.filter(function(m) {
          return (m.message_type != null) && (m.message_type.indexOf('echo') >= 0)
      })
      
      if (echo_message_logs[echo_message_logs.length - 1]){
        return echo_message_logs[echo_message_logs.length - 1]
      }
      
    }
  },
  mounted: function() {
    var el = document.querySelector("#main")
    el.height = $(window).height()
    console.log($(window).height())
    console.log(el.height)
    el.scrollTop = el.scrollHeight
  }, 
  watch: {
    message_logs: function (val) {
      this.$nextTick(() => {
        var el = document.querySelector("#main")
        el.scrollTop = el.scrollHeight
      })
    }
  },
  methods: {
    submitMessage(event){
        event.preventDefault()
        this.takeOver()
        this.addMessageLog()
      },
    selecteChatroomType(type) {
      this.selectedChatroomType = type
      this.showChatroomOptions = false
    },
    takeOver(){
      if (this.status == 'bot' || this.status == 'done' ){
        this.handoverChat()
      }
      if (this.status == 'conversation'){
        this.stopConversation()
        this.handoverChat()
      }
    },
    stopConversation(){
      var partner_id = this.current_chatroom.user.session.conversation_with_user_id;
      $.ajax({
        url: "/sessions/finish_conversation.json",
        data: {
          user_id: this.current_chatroom.user.id,
          receiver_id: partner_id,
        },
        method:"PATCH",
        
      })

      $.ajax({
        url: "/sessions/finish_conversation.json",
        data: {
          user_id: partner_id ,
          receiver_id: this.current_chatroom.user.id,
        },
        method:"PATCH",
        
      })

    },
    handoverChat(event) {
      $.ajax({
        url: "/sessions/handover_chat.json",
        data: {user_id: this.current_chatroom.user.id },
        method:"PATCH",
        
      })
    },
    selectedChatroomsTypeName(chatroomType) {
      switch (chatroomType){
        case 'all':
          return '全部對話'
        case 'handed_over':
          return '線上對話中'
        case 'conversation':
          return '轉接客服人員中'
      }
    },
    selectedChatroomsCount(chatroomType) {
      if (chatroomType != 'all'){
        return this.chatrooms.filter(function(c) {
          return c.user.session.status == chatroomType
        }).length
      }
      else{
        return this.chatrooms.length
      }
    },
    stopHandoverChat(event) {
      if (this.current_chatroom.user.session){
        $.ajax({
          url: "/sessions/finish_handover_chat.json",
          data: {user_id: this.current_chatroom.user.id },
          method:"PATCH",
          success: (data) => {
            this.$store.commit('updateSession',data)
          },
        });
      }
    },
    addMessageLog() {

      if (this.message == ""){
        return
      }

      var data = {
        message_log: {
          text: this.message,
          user_id: this.current_chatroom.user.id
        }
      }
      
      this.message = ""

      $.ajax({
        url: '/message_logs/deliver.json',
        data: data,
        method:"GET",
        success: (data) => {
          console.log('success')
          this.$refs.message.focus()
        },
        error: (error) => {
          console.log('error')
          console.log(error)
        }
      });
    },
  }
}
</script>

<style lang="scss" >
@import 'app/assets/stylesheets/chatrooms.sass';



</style>
