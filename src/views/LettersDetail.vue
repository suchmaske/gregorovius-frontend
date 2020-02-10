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
          </q-tabs>
          <q-separator />
          <q-tab-panels v-model="tab" animated>
            <q-tab-panel name="tgl">
              <v-runtime-template :template="msDesc" />
            </q-tab-panel>
            <q-tab-panel name="reg">
              {{ abstractGerman }}
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
            flat
            icon="arrow_right_alt"
            color="primary"
            size="md"
            @click="openUrl(`http://gregorovius-edition.dhi-roma.it/api${$route.path}`)"
          />
        </div>
        <div class="row">
          <transition
            appear
            enter-active-class="animated fadeIn"
            leave-active-class="animated fadeOut"
          >
            <LettersText v-show="showLetter" />
          </transition>
        </div>
      </q-card>
    </div>
  </q-page>
</template>

<script>
import VRuntimeTemplate from "v-runtime-template";
import LettersText from "@/components/LettersText.vue";
import { dataService } from "@/shared";
import { API } from "@/shared/config";

export default {
  name: "Item",
  components: {
    LettersText,
    VRuntimeTemplate
  },
  data() {
    return {
      data: [],
      visible: true,
      showLetter: false,
      tab: "reg",
      msDesc: "",
      supplement: "",
      physDesc: ""
    };
  },
  computed: {
    abstractGerman() {
      return this.data.teiHeader.profileDesc.abstract.p[0]["#text"];
    },
    // Splits the title and returns the first part.
    titleMain() {
      const title = this.data.teiHeader.fileDesc.titleStmt.title.replace(/[\n ]+/g, " ");
      return title.split(/\. (?=([A-Z][a-zà-ý]*|St\.)( [a-zà-ý]*)?( [A-Z][a-zà-ý]*)?,)/)[0];
    },
    // Splits the title and returns the second part.
    // Is different than titleMain because of lookbehind limitations.
    titleSecondary() {
      const title = this.data.teiHeader.fileDesc.titleStmt.title.replace(/[\n ]+/g, " ");
      const secondPart = title.split(
        / .?.? ?[A-Z][a-zà-ý)]*( [a-zà-ý]*)?( [A-Z][a-zà-ý]*)?(-[A-Z][-a-zà-ý]*)?(\(\?\))?\./
      );
      return secondPart[secondPart.length - 1];
    }
  },

  async mounted() {
    await this.getItems();
    await this.getXSLT("LettersMsDesc", "msDesc");
  },

  methods: {
    async getItems() {
      try {
        const response = await fetch(`${API}${this.$route.path}`, {
          headers: { Accept: "application/json" }
        });
        this.data = await response.json();
        this.visible = false;
        this.showLetter = true;
      } catch (error) {
        console.error(error);
      }
    },
    async getXSLT(fileName, targetProp) {
      this[targetProp] = await dataService.XSLTransform(this.$route.path, fileName);
    },
    openUrl(url) {
      url ? window.open(url) : null;
    }
  }
};
</script>

<style></style>
