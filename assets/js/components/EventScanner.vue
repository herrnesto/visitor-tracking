<template>
  <qrcode-stream @detect="onDetect"></qrcode-stream>
</template>

<script>
  import { QrcodeStream, QrcodeDropZone, QrcodeCapture } from 'vue-qrcode-reader'

  export default {

    components: {
      QrcodeStream,
      QrcodeDropZone,
      QrcodeCapture
    },
    data() {
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
    }
  }
</script>