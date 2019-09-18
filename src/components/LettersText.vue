<template>
  <v-runtime-template :template="data"></v-runtime-template>
</template>

<script>
import lettersXSLT from '../assets/xslt/LettersText.xslt'
import VRuntimeTemplate from "v-runtime-template"

export default {
  name: 'LettersText',
  components: {
    VRuntimeTemplate
  },
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
        var parser = new DOMParser()
        var xml = parser.parseFromString(data, "text/xml")
        var xslt = parser.parseFromString(lettersXSLT, "text/xml")
        const processor = new XSLTProcessor()
        processor.importStylesheet(xslt)
        var html = processor.transformToDocument(xml)
        this.data = '<div class="edition-text" xmlns:v-bind="https://vuejs.org/v2/api/#v-bind" xmlns:v-on="https://vuejs.org/v2/api/#v-on">' 
          + html.documentElement.innerHTML + '</div>'
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
