<template>
  <div>
    <p>Visitors: {{ visitors }}</p>
    <qrcode-stream @detect="onDetect"></qrcode-stream>
  </div>
</template>

<script>
  import { QrcodeStream, QrcodeDropZone, QrcodeCapture } from 'vue-qrcode-reader'
  import axios from 'axios';

  export default {

    components: {
      QrcodeStream,
      QrcodeDropZone,
      QrcodeCapture
    },
    data() {
      return {
        event: null,
        visitors: 0
      }
    },
    methods: {
      async onDetect (promise) {
        try {
          const {
            imageData,    // raw image data of image/frame
            content,      // decoded String
            location      // QR code coordinates
          } = await promise

          if (content === null) {
            // decoded nothing
          } else {
            console.log(content)
          }
        } catch (error) {
          // ...
        }
      }
    },
    created() {
      var csrfToken = document.head.querySelector("[name~=csrf-token][content]").content;
      axios.defaults.headers['x-csrf-token'] = csrfToken;

      axios.post(`https://0.0.0.0:4001/api/scan/user`, {uuid: "804822a4-d33d-11ea-ba26-784f439a034a"})
        .then(response => {
          // JSON responses are automatically parsed.
          console.log(response.data)
        })
        .catch(e => {
          this.errors.push(e)
        })

      axios.post(`https://0.0.0.0:4001/api/scan/event_infos`,{id: 1})
        .then(response => {
          this.visitors = response.data.visitors
          console.log(response.data)
        })
        .catch(e => {
          this.errors.push(e)
        })
    }
  }
</script>