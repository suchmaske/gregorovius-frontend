<template>
<q-page padding>
  <div class="row justify-center">
    <div v-if="data.teiHeader" class="col-md-8 col-12 q-py-xl q-gutter-y-lg">
      <q-card class="q-pa-xl" flat>
        <q-card-section>
          <div class="text-h6">{{ titleMain }}</div>
          <div class="text-subtitle3 text-secondary">{{ titleSecondary }}</div>
        </q-card-section>
        <q-separator dark />
        <q-tabs v-model="tab" class="text-primary">
          <q-tab label="Textgrundlage" name="tgl" />
          <q-tab v-if="abstractGerman != ''" label="Regest" name="reg" />
          <q-tab v-if="supplement != ''" label="Beilagen" name="spl" />
          <q-tab v-if="context.length > 0" label="Korrespondenzkontext" name="ctx" />
        </q-tabs>
        <q-separator />
        <q-tab-panels v-model="tab" animated>
          <q-tab-panel name="tgl">
            <v-runtime-template :template="msDesc"/>
          </q-tab-panel>
          <q-tab-panel name="reg">
            {{ abstractGerman }}
          </q-tab-panel>
          <q-tab-panel name="spl">
            <v-runtime-template :template="supplement"/>
          </q-tab-panel>
          <q-tab-panel name="ctx">
            <div v-for="line in context" :key="line"> {{ line }} </div>
          </q-tab-panel>
        </q-tab-panels>
      </q-card>
    </div>
  </div>
  <div class="row justify-center">
    <q-card class="col-md-8 col-12 q-pa-xl q-mb-xl" bordered flat>
      <div class="row justify-end">
        <q-btn 
          label="TEI XML"
          flat icon="code" 
          @click="openUrl(`http://localhost:8000${$route.path}`)"
          color="primary"
          size="sm"
        />
      </div>
      <div class="row">
        <LettersText/>
      </div>
    </q-card>
  </div>
</q-page>
</template>

<script>
import VRuntimeTemplate from 'v-runtime-template';
import LettersText from '@/components/LettersText.vue';
import { dataService } from '@/shared';

export default {
  name: 'item',
  components: {
    LettersText,
    VRuntimeTemplate,
  },
  data() {
    return {
      data: [],
      tab: 'reg',
      msDesc: '',
      supplement: '',
      physDesc: '',
    };
  },

  mounted() {
    this.getItems(),
    this.getXSLT('LettersMsDesc', 'msDesc'),
    this.getXSLT('LettersSupplement', 'supplement');
  },

  methods: {
    async getItems() {
      try {
        const response = await fetch(
          `http://localhost:8000${this.$route.path}`, {
            headers: { Accept: 'application/json' },
          },
        );
        this.data = await response.json();
      } catch (error) {
        // eslint-disable-next-line
        console.error(error)
      }
    },
    async getXSLT(fileName, targetProp) {
      this[targetProp] = await dataService.XSLTransform(this.$route.path, fileName);
    },
    openUrl(url) {
      url ? window.open(url) : null;
    }
  },
  computed: {
    abstractGerman() {
      return this.data.teiHeader.profileDesc.abstract.p[0]['#text'];
    },
    titleMain() {
      const title = this.data.teiHeader.fileDesc.titleStmt.title.replace(/[\n ]+/g, ' ');
      return title.split(/\. (?=([A-Z][a-zà-ý]*|St\.)( [a-zà-ý]*)?( [A-Z][a-zà-ý]*)?,)/)[0];
    },
    titleSecondary() {
      const title = this.data.teiHeader.fileDesc.titleStmt.title.replace(/[\n ]+/g, ' ');
      const secondPart = title.split(/ .?.? ?[A-Z][a-zà-ý)]*( [a-zà-ý]*)?( [A-Z][a-zà-ý]*)?\./);
      return secondPart[secondPart.length - 1];
    },
    context() {
      try {
        const context = this.data.teiHeader.profileDesc.correspDesc.correspContext.ref;
        var formatted = []
        if (context.length > 1) {
          context.map(c => {
            if (c["@type"] == "prev") {
              formatted.push(`B: ${c["#text"]}`)
            } else if (c["@type"] == "next") {
              formatted.push(`A: ${c["#text"]}`)
            }
          })
        } else {
          if (context["@type"] == "prev") {
            formatted.push(`B: ${context["#text"]}`)
          } else if (context["@type"] == "next") {
            formatted.push(`A: ${context["#text"]}`)
          }
        }
        return formatted
      } catch (error) {
        console.log(error)
        return [];
      }
    },
  },
};
</script>

<style>
</style>
