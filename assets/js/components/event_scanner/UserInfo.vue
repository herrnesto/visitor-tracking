<template>
  <b-message type="is-info">
    <h2 class="title is-3 mb-2" v-text="visitor.firstname + ' ' + visitor.lastname"></h2>
    <span class="icon has-text-success" v-if="visitor.phone_verified"><i class="fas fa-check"></i></span>
    <span class="icon has-text-danger" v-else><i class="fas fa-times"></i></span> Mobilnummer

    <br>
    <span class="icon has-text-success" v-if="visitor.email_verified"><i class="fas fa-check"></i></span>
    <span class="icon has-text-danger" v-else><i class="fas fa-times"></i></span> E-Mail
  </b-message>
</template>

<script>
  export default {
    name: "UserInfo",
    props: {
      visitor: Array
    }
  }
</script>