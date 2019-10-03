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
          <q-tab v-if="abstractGerman != ''" label="Regest" name="reg" />
          <q-tab v-if="physDesc != ''" label="Physische Beschreibung" name="phy" />
          <q-tab v-if="supplement != ''" label="Beilagen" name="spl" />
        </q-tabs>
        <q-separator />
        <q-tab-panels v-model="tab" animated>
          <q-tab-panel name="tgl">
            <v-runtime-template :template="msDesc"/>
          </q-tab-panel>
          <q-tab-panel name="reg">
            {{ abstractGerman }}
          </q-tab-panel>
          <q-tab-panel name="phy">
            <v-runtime-template :template="physDesc"/>
          </q-tab-panel>
          <q-tab-panel name="spl">
            <v-runtime-template :template="supplement"/>
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
import LettersText from '@/components/LettersText.vue'
import VRuntimeTemplate from 'v-runtime-template'
import { dataService } from '@/shared'

export default {
  name: 'item',
  components: {
    LettersText,
    VRuntimeTemplate
  },
  data () {
    return {
      data: [],
      tab: 'reg',
      msDesc: '',
      supplement: '',
      physDesc: '',
    }
  },

  mounted () {
    this.getItems(),
    this.getXSLT('LettersMsDesc', 'msDesc'),
    this.getXSLT('LettersPhysDesc', 'physDesc'),
    this.getXSLT('LettersSupplement', 'supplement')
  },

  methods: {
    async getItems () {
      try {
        const response = await fetch(
          'http://localhost:8000' + this.$route.path, {
            headers: {'Accept': 'application/json'}
          }
        )
        this.data = await response.json()
      } catch (error) {
        // eslint-disable-next-line
        console.error(error)
      }
    },
    async getXSLT (fileName, targetProp) {
      this[targetProp] = await dataService.XSLTransform(this.$route.path, fileName)
    },
  },
  computed: {
      abstractGerman () {
        return this.data.teiHeader.profileDesc.abstract.p[0]['#text']
      },
      titleMain () {
        const title = this.data.teiHeader.fileDesc.titleStmt.title
        return title.split(/\. (?=([A-Z][a-zà-ý]*|St\.)( [a-zà-ý]*)?( [A-Z][a-zà-ý]*)?,)/)[0]
      },
      titleSecondary () {
        const title = this.data.teiHeader.fileDesc.titleStmt.title.replace('\n', '')
        const secondPart = title.split(/ .. [A-Z][a-zà-ý)]*( [a-zà-ý]*)?( [A-Z][a-zà-ý]*)?\./)
        return secondPart[secondPart.length - 1]
      },
  }
}
</script>

<style>
</style>
