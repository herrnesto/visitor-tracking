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
  created() {
    console.log("Vue component created")
  }
}
</script>
