<template>
  <datetime type="datetime" v-model="datetime" hidden-name="event[date_start]" input-class="input is-medium"></datetime>
</template>

<script>
import { Datetime } from 'vue-datetime';

export default {
  components: {
    Datetime
  },
  data() {
    return {
      datetime: ""
    }
  },
  mounted() {
    var datetime = document.querySelector("[name~=datetime-tmp]").value;
    console.log(document.querySelector("[name~=datetime-tmp]").value)
  }
}
</script>
