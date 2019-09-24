<template>
  <v-runtime-template :template="data"></v-runtime-template>
</template>

<script>
import VRuntimeTemplate from 'v-runtime-template'
import { xslt } from '@/mixins/xslt'

export default {
  name: 'LettersText',
  components: {
    VRuntimeTemplate
  },
  mixins: [xslt],
  data () {
    return {
      data: null
    }
  },

  mounted () {
    this.getItems()
  },

  methods: {
    async getItems () {
      try {
        const response = await fetch('http://localhost:8000' + this.$route.path)
        const data = await response.text()
        this.data = await this.processXML(data, 'LettersText')
      } catch (error) {
        // eslint-disable-next-line
        console.error(error)
      }
    }
  }

}
</script>

<style>
@font-face {
  font-family: Cardo;
  src: url('../assets/fonts/Cardo-Regular.ttf');
}

.edition-text {
  font-family: Cardo;
  font-size: 14pt;
  padding: 16px;
}

span.pb {
  display: block;
  position: absolute;
  left: -2.5em;
  margin-top: -1.7em;
  font-size: 0.8em;
}

</style>
