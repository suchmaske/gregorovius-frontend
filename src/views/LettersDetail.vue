<template>
  <q-page padding>
<div class="row justify-center">
    <div v-if="data.teiHeader" class="col-8 q-py-xl q-gutter-y-lg">

      <q-card class="col-md-8 col-12 q-pa-xl" flat>
        <q-card-section>
          <div class="text-h6">{{ titleMain }}</div>
          <div class="text-subtitle3 text-secondary">{{ titleSecondary }}</div>
        </q-card-section>
        <q-separator dark />
        <q-tabs v-model="tab" class="text-primary">
          <q-tab label="Textgrundlage" name="tgl" />
          <q-tab label="Regest" name="reg" />
        </q-tabs>
        <q-separator />
        <q-tab-panels v-model="tab" animated>
          <q-tab-panel name="tgl">
          </q-tab-panel>
          <q-tab-panel name="reg">
            {{ abstractGerman }}
          </q-tab-panel>
        </q-tab-panels>
      </q-card>
</div>

<div class="row justify-center">

      <q-card class="col-md-8 col-12 q-pa-xl">
          <a :href="'http://localhost:8000' + this.$route.path">
            <q-icon name="code" class="text-primary float-right"  style="font-size: 2em;" />
          </a>
          <LettersText/>
      </q-card>

</div>

    </div>
  </q-page>
</template>

<script>
import LettersText from '../components/LettersText.vue'

export default {
  name: 'item',
  components: {
    LettersText
  },
  data () {
    return {
      data: [],
      tab: 'reg',
    }
  },

  mounted () {
    this.getItems()
  },

  methods: {
    async getItems () {
      try {
        const response = await fetch(
          'http://localhost:8000' + this.$route.path, {
            headers: {'Accept': 'application/json'}
          }
        )
        const data = await response.json()
        this.data = data
      } catch (error) {
        // eslint-disable-next-line
        console.error(error)
      }
    }
  },
  computed: {
      abstractGerman () {
        return this.data.teiHeader.profileDesc.abstract.p[0]['#text']
      },
      titleMain () {
        return this.data.teiHeader.fileDesc.titleStmt.title.match(/.*[a-z)](?=\.)/)[0]
      },
      titleSecondary () {
        return this.data.teiHeader.fileDesc.titleStmt.title.split(/[a-z)]\./)[1]
      }
  }
}
</script>

<style>
</style>
